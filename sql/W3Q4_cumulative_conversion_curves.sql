-- W3Q4: Cumulative conversion curves — 2022 cohorts
-- For users who signed up in 2022, how does conversion accumulate over time?
-- Reveals how quickly cohorts convert vs how long conversion takes.
-- Grain: one row per user
--
-- Python will compute cumulative conversion at fixed time thresholds
-- (7, 14, 30, 60, 90, 180, 365 days post-signup).
--
-- DATA NOTE (DN-001): Signup data capped at Nov 2022.
-- DATA NOTE (DN-002): Subscriptions not available before Jan 2020 (satisfied by 2022 filter).

SELECT
    user_id,
    DATE_TRUNC('month', signup_date)::date  AS cohort_month,
    acquisition_type,
    registration_type,

    -- Funnel flags
    has_trial,
    has_3m_subscription,
    has_12m_subscription,

    -- Days from signup to each conversion event (NULL = not converted)
    days_signup_to_trial,
    days_signup_to_3m,
    days_signup_to_12m

FROM ANALYTICS.MARTS.MART_SUBSCRIPTION_FUNNEL
WHERE signup_date BETWEEN '2022-01-01' AND '2022-11-30'  -- DN-001: cap at Nov 2022
ORDER BY cohort_month, user_id
