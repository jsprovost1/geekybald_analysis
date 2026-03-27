-- W4Q1: Email campaign quasi-experiment (May 2022)
-- Compare subscription conversion rates between users who received an email
-- in May 2022 vs those who did not.
-- Grain: one row per user
--
-- Approach:
--   Treatment group  = users with at least one email sent in May 2022
--   Control group    = users with NO email sent in May 2022
--   Outcome          = trial, 3m, and 12m conversion (from funnel mart)
--
-- Limitation: this is observational, not randomised. Users in the treatment
-- group may differ from the control group on pre-existing characteristics.
-- Flag this in findings.

WITH may_email_recipients AS (
    SELECT
        user_id,
        email_campaign                          AS may_campaign,
        first_sent_date                         AS may_email_date
    FROM ANALYTICS.MARTS.MART_EMAIL_ENGAGEMENT
    WHERE first_sent_date BETWEEN '2022-05-01' AND '2022-05-31'
    QUALIFY ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY first_sent_date) = 1
)

SELECT
    f.user_id,
    f.acquisition_type,
    f.registration_type,
    f.age,

    -- Treatment flag
    CASE WHEN m.user_id IS NOT NULL THEN TRUE ELSE FALSE END    AS received_may_email,
    m.may_campaign,
    m.may_email_date,

    -- Conversion outcomes
    f.has_trial,
    f.has_3m_subscription,
    f.has_12m_subscription,
    f.funnel_stage,

    -- Timing context
    f.signup_date::date AS signup_date

FROM ANALYTICS.MARTS.MART_SUBSCRIPTION_FUNNEL f
LEFT JOIN may_email_recipients m ON f.user_id = m.user_id
WHERE f.signup_date >= '2020-01-01'  -- DN-002
