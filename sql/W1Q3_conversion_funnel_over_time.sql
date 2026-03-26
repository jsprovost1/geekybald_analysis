-- W1Q3: Subscription conversion funnel over time (Jan 2019 – Dec 2022)
-- Grain: one row per calendar month
-- Cohort anchor: trial_date (as specified — cohorts defined by when the free trial started)
--
-- Columns:
--   cohort_month         : month the free trial started
--   new_signups          : users who signed up in that month (signup_date)
--   new_trials           : users who started a free trial in that month
--   trial_to_signup_rate : share of that month's signups who converted to trial
--   new_3m_subscribers   : users whose 3m subscription started in that month
--   trial_to_3m_rate     : share of that month's trials who eventually got a 3m sub
--   new_12m_subscribers  : users whose 12m subscription started in that month
--   m3_to_12m_rate       : share of 3m subscribers (by 3m start month) who upsold to 12m
--
-- Note: conversion rates (trial_to_3m, m3_to_12m) are lagged by nature —
--       recent cohorts will show lower rates because not enough time has passed.
--       Interpret with caution for months close to Dec 2022.

WITH monthly_signups AS (
    SELECT
        DATE_TRUNC('month', signup_date)::date AS cohort_month,
        COUNT(DISTINCT user_id)                AS new_signups
    FROM mart_subscription_funnel
    WHERE signup_date BETWEEN '2019-01-01' AND '2022-12-31'
    GROUP BY 1
),

monthly_trials AS (
    SELECT
        DATE_TRUNC('month', trial_date)::date  AS cohort_month,
        COUNT(DISTINCT user_id)                AS new_trials,
        COUNT(DISTINCT CASE WHEN has_3m_subscription THEN user_id END) AS trials_converted_to_3m,
        COUNT(DISTINCT CASE WHEN has_12m_subscription THEN user_id END) AS trials_converted_to_12m
    FROM mart_subscription_funnel
    WHERE trial_date BETWEEN '2019-01-01' AND '2022-12-31'
    GROUP BY 1
),

monthly_3m AS (
    SELECT
        DATE_TRUNC('month', subscr_3m_date)::date AS cohort_month,
        COUNT(DISTINCT user_id)                    AS new_3m_subscribers,
        COUNT(DISTINCT CASE WHEN has_12m_subscription THEN user_id END) AS m3_converted_to_12m
    FROM mart_subscription_funnel
    WHERE subscr_3m_date BETWEEN '2019-01-01' AND '2022-12-31'
    GROUP BY 1
),

monthly_12m AS (
    SELECT
        DATE_TRUNC('month', subscr_12m_date)::date AS cohort_month,
        COUNT(DISTINCT user_id)                     AS new_12m_subscribers
    FROM mart_subscription_funnel
    WHERE subscr_12m_date BETWEEN '2019-01-01' AND '2022-12-31'
    GROUP BY 1
)

SELECT
    t.cohort_month,
    COALESCE(s.new_signups, 0)          AS new_signups,
    t.new_trials,
    ROUND(t.new_trials * 100.0 / NULLIF(s.new_signups, 0), 1)                  AS trial_to_signup_rate,
    COALESCE(m3.new_3m_subscribers, 0)  AS new_3m_subscribers,
    ROUND(t.trials_converted_to_3m * 100.0 / NULLIF(t.new_trials, 0), 1)       AS trial_to_3m_rate,
    COALESCE(m12.new_12m_subscribers, 0) AS new_12m_subscribers,
    ROUND(m3.m3_converted_to_12m * 100.0 / NULLIF(m3.new_3m_subscribers, 0), 1) AS m3_to_12m_rate

FROM monthly_trials t
LEFT JOIN monthly_signups s  ON s.cohort_month  = t.cohort_month
LEFT JOIN monthly_3m       m3 ON m3.cohort_month = t.cohort_month
LEFT JOIN monthly_12m      m12 ON m12.cohort_month = t.cohort_month

ORDER BY t.cohort_month
