-- W6Q3: Digital campaign ROI
-- Aggregate spend, reach, and conversion metrics per campaign.
-- Grain: one row per campaign (rolled up from daily campaign x day grain)
--
-- ⚠️ DOUBLE-COUNTING RISK: stg_campaign_performance and stg_campaign_cost are
-- separate staging tables both contributing to mart_campaign_analytics.
-- Verify that daily_cost does not double-count before trusting spend totals.
-- Flag in findings if costs appear anomalously high.
--
-- Note: total_conversions and unique_users_converted are campaign-level
-- attributes repeated on every daily row — use MAX(), not SUM(), to avoid
-- over-counting when rolling up.

SELECT
    campaign_name,
    campaign_status,

    -- Reach & engagement
    SUM(daily_impressions)                                                      AS total_impressions,
    SUM(daily_clicks)                                                           AS total_clicks,
    SUM(daily_cost)                                                             AS total_cost,

    -- Conversions (campaign-level, not day-level — use MAX to avoid duplication)
    MAX(total_conversions)                                                      AS total_conversions,
    MAX(unique_users_converted)                                                 AS unique_users_converted,

    -- Efficiency metrics (recomputed from aggregated totals)
    ROUND(SUM(daily_clicks) * 100.0 / NULLIF(SUM(daily_impressions), 0), 4)   AS overall_ctr,
    ROUND(SUM(daily_cost) / NULLIF(SUM(daily_clicks), 0), 2)                   AS overall_cpc,
    ROUND(SUM(daily_cost) / NULLIF(MAX(total_conversions), 0), 2)              AS overall_cost_per_conversion,

    -- Campaign activity window
    MIN(year_month_day)                                                         AS campaign_start,
    MAX(year_month_day)                                                         AS campaign_end,
    DATEDIFF('day', MIN(year_month_day), MAX(year_month_day)) + 1              AS campaign_days_active

FROM ANALYTICS.MARTS.MART_CAMPAIGN_ANALYTICS
GROUP BY campaign_name, campaign_status
ORDER BY total_cost DESC
