-- W2Q2: Time on website before signup
-- How much time and how many visits did users accumulate before signing up?
-- Does pre-signup engagement predict trial conversion?
-- Grain: one row per user

SELECT
    user_id,
    registration_type,
    age,
    converted_to_trial,

    -- Pre-signup engagement
    visits_before_signup,
    days_first_visit_to_signup,

    -- Overall visit behavior
    total_visits,
    unique_visit_days,
    unique_pages_visited,
    days_between_first_last_visit,

    -- Entry point
    first_visit_page,

    -- Login duration
    login_duration

FROM ANALYTICS.MARTS.MART_WEB_BEHAVIOR
