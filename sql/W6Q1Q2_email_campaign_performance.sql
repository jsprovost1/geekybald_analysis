-- W6Q1/Q2: Email campaign performance — onboarding + A/B test
-- Aggregate email funnel metrics per campaign.
-- Identifies which campaigns are highest performing and flags
-- potential A/B test pairs (campaigns with similar names or send patterns).
-- Grain: one row per email campaign

SELECT
    email_campaign,
    COUNT(DISTINCT user_id)                                                     AS total_recipients,
    SUM(total_sent)                                                             AS total_sent,
    SUM(total_delivered)                                                        AS total_delivered,
    SUM(total_opened)                                                           AS total_opened,
    SUM(total_clicked)                                                          AS total_clicked,
    SUM(total_bounced)                                                          AS total_bounced,
    SUM(total_spam)                                                             AS total_spam,

    -- Aggregate rates (recomputed from raw counts to avoid averaging averages)
    ROUND(SUM(total_delivered) * 100.0 / NULLIF(SUM(total_sent), 0), 2)        AS delivery_rate,
    ROUND(SUM(total_opened)    * 100.0 / NULLIF(SUM(total_delivered), 0), 2)   AS open_rate,
    ROUND(SUM(total_clicked)   * 100.0 / NULLIF(SUM(total_opened), 0), 2)      AS click_to_open_rate,
    ROUND(SUM(total_bounced)   * 100.0 / NULLIF(SUM(total_sent), 0), 2)        AS bounce_rate,
    ROUND(SUM(total_spam)      * 100.0 / NULLIF(SUM(total_sent), 0), 2)        AS spam_rate,

    -- Campaign date range
    MIN(first_sent_date)                                                        AS campaign_start,
    MAX(last_sent_date)                                                         AS campaign_end

FROM ANALYTICS.MARTS.MART_EMAIL_ENGAGEMENT
GROUP BY email_campaign
ORDER BY total_sent DESC
