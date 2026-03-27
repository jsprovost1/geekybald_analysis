-- W3Q5: Customer segments by conversion time
-- Classify trial users by how quickly they converted to a 3m subscription.
-- Profile each segment to identify distinguishing characteristics.
-- Grain: one row per user (trial users only)
--
-- Segment definitions (days_trial_to_3m):
--   fast        : ≤ 7 days  (converted within or immediately after trial)
--   medium      : 8–30 days (converted within a month)
--   slow        : > 30 days (took more than a month)
--   never       : did not convert to 3m (has_trial = TRUE, has_3m = FALSE)
--
-- DATA NOTE (DN-002): Subscriptions not available before Jan 2020.

SELECT
    user_id,
    acquisition_type,
    registration_type,
    age,
    funnel_stage,

    -- Funnel outcomes
    has_trial,
    has_3m_subscription,
    has_12m_subscription,

    -- Timing
    days_signup_to_trial,
    days_trial_to_3m,
    days_3m_to_12m,

    -- Conversion speed segment
    CASE
        WHEN NOT has_3m_subscription        THEN 'never'
        WHEN days_trial_to_3m <= 7          THEN 'fast'
        WHEN days_trial_to_3m <= 30         THEN 'medium'
        ELSE                                     'slow'
    END AS conversion_speed

FROM ANALYTICS.MARTS.MART_SUBSCRIPTION_FUNNEL
WHERE has_trial = TRUE           -- only users who had the opportunity to convert
  AND signup_date >= '2020-01-01'  -- DN-002
