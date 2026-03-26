-- W1Q2: Active customers snapshot
-- Compares Dec 2022 vs Nov 2022 (MoM) vs Dec 2021 (YoY)
--
-- Active definitions:
--   Signup    : signed up in the calendar month
--   Trial     : free trial started in the calendar month (7-day window)
--   3-month   : subscr_3m_date within 90 days before month end (subscription still running)
--   12-month  : subscr_12m_date within 365 days before month end (subscription still running)
--   Returning : upsold from 3m → 12m, with 12m starting in that month
--              OR renewed a 3m subscription (has 12m = false, 3m started in month, trial was prior)

WITH reference_months AS (
    SELECT '2021-12-01'::date AS month_start, '2021-12-31'::date AS month_end, 'Dec 2021 (YoY)'  AS label
    UNION ALL
    SELECT '2022-11-01'::date,                '2022-11-30'::date,             'Nov 2022 (prior month)'
    UNION ALL
    SELECT '2022-12-01'::date,                '2022-12-31'::date,             'Dec 2022 (current)'
)

SELECT
    m.label,
    m.month_start,

    -- New signups in the month
    COUNT(DISTINCT CASE
        WHEN f.signup_date BETWEEN m.month_start AND m.month_end
        THEN f.user_id END)                                                     AS new_signups,

    -- Users who started a free trial in the month
    COUNT(DISTINCT CASE
        WHEN f.trial_date BETWEEN m.month_start AND m.month_end
        THEN f.user_id END)                                                     AS active_trials,

    -- Users with a 3-month subscription still active (started within past 90 days)
    COUNT(DISTINCT CASE
        WHEN f.subscr_3m_date BETWEEN DATEADD('day', -90, m.month_end) AND m.month_end
        THEN f.user_id END)                                                     AS active_3m_subscribers,

    -- Users with a 12-month subscription still active (started within past 365 days)
    COUNT(DISTINCT CASE
        WHEN f.subscr_12m_date BETWEEN DATEADD('day', -365, m.month_end) AND m.month_end
        THEN f.user_id END)                                                     AS active_12m_subscribers,

    -- Returning: upsold to 12m this month (had a prior 3m subscription)
    COUNT(DISTINCT CASE
        WHEN f.has_3m_subscription
            AND f.subscr_12m_date BETWEEN m.month_start AND m.month_end
        THEN f.user_id END)                                                     AS upsold_to_12m_this_month,

    -- Returning: renewed 3m this month (has 3m but no 12m, and trial was before this month)
    COUNT(DISTINCT CASE
        WHEN f.has_3m_subscription
            AND NOT f.has_12m_subscription
            AND f.subscr_3m_date BETWEEN m.month_start AND m.month_end
            AND f.trial_date < m.month_start
        THEN f.user_id END)                                                     AS renewed_3m_this_month

FROM reference_months m
CROSS JOIN mart_subscription_funnel f
GROUP BY m.label, m.month_start
ORDER BY m.month_start
