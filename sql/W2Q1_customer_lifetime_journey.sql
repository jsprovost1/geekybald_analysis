-- W2Q1: Customer lifetime journey
-- How long does it take users to progress through each funnel stage?
-- Grain: one row per user
--
-- Returns timing metrics for each stage transition.
-- NULL values mean the user never reached that stage (expected — not all users convert).
-- Segmented by acquisition_type (paid vs organic) for comparison.
--
-- DATA NOTE (DN-002): Subscriptions not available before Jan 2020.
--   Filter applied to exclude pre-subscription era cohorts.

SELECT
    user_id,
    acquisition_type,
    registration_type,
    age,
    funnel_stage,

    -- Stage flags
    has_trial,
    has_3m_subscription,
    has_12m_subscription,

    -- Time between stages (NULL if user didn't reach next stage)
    days_signup_to_trial,
    days_trial_to_3m,
    days_3m_to_12m,

    -- Full journey duration
    days_signup_to_3m,
    days_signup_to_12m

FROM ANALYTICS.MARTS.MART_SUBSCRIPTION_FUNNEL
WHERE signup_date >= '2020-01-01'  -- DN-002: exclude pre-subscription era
ORDER BY user_id
