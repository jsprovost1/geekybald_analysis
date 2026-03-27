-- W4Q2: Marketing 12m initiative — before/after analysis
-- Does the marketing_12m_subscr flag correlate with higher 12m conversion?
-- Compare funnel outcomes for flagged vs non-flagged users.
-- Grain: one row per user
--
-- marketing_12m_subscr: flag indicating the user was targeted by a
-- specific initiative aimed at driving 12-month subscriptions.
--
-- DATA NOTE (DN-002): Subscriptions not available before Jan 2020.

SELECT
    user_id,
    marketing_12m_subscr,
    acquisition_type,
    registration_type,
    age,

    -- Funnel outcomes
    has_trial,
    has_3m_subscription,
    has_12m_subscription,
    funnel_stage,

    -- Key timing
    signup_date::date       AS signup_date,
    subscr_3m_date,
    subscr_12m_date,
    days_3m_to_12m,
    days_signup_to_12m

FROM ANALYTICS.MARTS.MART_SUBSCRIPTION_FUNNEL
WHERE signup_date >= '2020-01-01'  -- DN-002
