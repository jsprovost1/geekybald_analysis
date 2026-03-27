-- W4Q4: Webpage conversion rate
-- Which landing pages (first page visited) produce the highest trial conversion rates?
-- Grain: one row per first_visit_page
--
-- Conversion definition: converted_to_trial = TRUE
-- (user went on to start a free trial)
--
-- Note: this captures the first page visited per user, not all pageviews.
-- Users who visited multiple pages before signup are attributed to their first page only.

SELECT
    first_visit_page,
    COUNT(DISTINCT user_id)                                             AS unique_visitors,
    SUM(CASE WHEN converted_to_trial THEN 1 ELSE 0 END)                AS converted_to_trial,
    ROUND(
        SUM(CASE WHEN converted_to_trial THEN 1 ELSE 0 END) * 100.0
        / NULLIF(COUNT(DISTINCT user_id), 0), 1
    )                                                                   AS trial_conversion_rate,

    -- Visit behaviour by landing page
    ROUND(AVG(visits_before_signup), 1)                                 AS avg_visits_before_signup,
    ROUND(AVG(days_first_visit_to_signup), 1)                           AS avg_days_to_signup,
    ROUND(AVG(unique_pages_visited), 1)                                 AS avg_pages_visited

FROM ANALYTICS.MARTS.MART_WEB_BEHAVIOR
WHERE first_visit_page IS NOT NULL
GROUP BY first_visit_page
ORDER BY unique_visitors DESC
