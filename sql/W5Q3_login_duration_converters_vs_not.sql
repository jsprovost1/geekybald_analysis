-- W5Q3: Login duration — converters vs. non-converters
-- Does login duration on the first visit predict trial conversion?
-- Grain: one row per user
--
-- Python will run a Mann-Whitney U test (non-parametric) to compare
-- login_duration distributions between converters and non-converters.
-- Distribution plots (box plot + KDE) will visualise the difference.
--
-- Note: login_duration units are not documented — flag in findings if unclear
-- (could be seconds, minutes, or sessions).

SELECT
    user_id,
    converted_to_trial,
    login_duration,
    registration_type,
    age,
    total_visits,
    visits_before_signup,
    unique_pages_visited,
    days_first_visit_to_signup

FROM ANALYTICS.MARTS.MART_WEB_BEHAVIOR
WHERE login_duration IS NOT NULL
