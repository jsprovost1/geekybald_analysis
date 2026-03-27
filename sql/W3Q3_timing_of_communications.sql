-- W3Q3: Timing of communications
-- When are emails sent relative to user signup?
-- Which campaigns are sent early vs late in the user journey?
-- How does send timing correlate with engagement rates?
-- Grain: one row per user per email campaign

SELECT
    e.user_id,
    e.email_campaign,
    e.signup_date_clean,
    e.first_sent_date,
    e.last_sent_date,

    -- Days from signup to first email in this campaign
    DATEDIFF('day', e.signup_date_clean, e.first_sent_date) AS days_signup_to_first_email,

    -- Campaign duration for this user
    DATEDIFF('day', e.first_sent_date, e.last_sent_date)    AS days_campaign_span,

    -- Volume
    e.total_sent,
    e.total_delivered,
    e.total_opened,
    e.total_clicked,
    e.total_bounced,
    e.total_spam,

    -- Engagement rates
    e.delivery_rate,
    e.open_rate,
    e.click_to_open_rate,
    e.bounce_rate,
    e.spam_rate,

    -- Conversion outcomes (joined from funnel)
    f.has_trial,
    f.has_3m_subscription,
    f.has_12m_subscription,
    f.acquisition_type,
    f.funnel_stage

FROM ANALYTICS.MARTS.MART_EMAIL_ENGAGEMENT e
LEFT JOIN ANALYTICS.MARTS.MART_SUBSCRIPTION_FUNNEL f
    ON e.user_id = f.user_id
