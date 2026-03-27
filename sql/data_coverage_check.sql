-- Data coverage check: min/max dates for each event type in mart_subscription_funnel
-- Purpose: understand what periods are actually populated per stage

SELECT
    'signup_date'    AS event_type, MIN(signup_date)    AS min_date, MAX(signup_date)    AS max_date, COUNT(DISTINCT user_id) AS user_count FROM ANALYTICS.MARTS.MART_SUBSCRIPTION_FUNNEL WHERE signup_date    IS NOT NULL
UNION ALL
SELECT
    'trial_date',                   MIN(trial_date),                 MAX(trial_date),                 COUNT(DISTINCT user_id) FROM ANALYTICS.MARTS.MART_SUBSCRIPTION_FUNNEL WHERE trial_date    IS NOT NULL
UNION ALL
SELECT
    'subscr_3m_date',               MIN(subscr_3m_date),             MAX(subscr_3m_date),             COUNT(DISTINCT user_id) FROM ANALYTICS.MARTS.MART_SUBSCRIPTION_FUNNEL WHERE subscr_3m_date IS NOT NULL
UNION ALL
SELECT
    'subscr_12m_date',              MIN(subscr_12m_date),            MAX(subscr_12m_date),            COUNT(DISTINCT user_id) FROM ANALYTICS.MARTS.MART_SUBSCRIPTION_FUNNEL WHERE subscr_12m_date IS NOT NULL

ORDER BY min_date
