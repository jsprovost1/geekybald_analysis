# GeekyBald Analysis Tracker

## Workflow
1. Write SQL query → run against Snowflake mart tables → export result
2. Load result in Python notebook → analyze + visualize
3. SQL files live in `sql/`, notebooks in `notebooks/`, outputs in `output/`

## Data Sources
All queries run against the `ANALYTICS.MARTS` schema in Snowflake:
- `mart_users`
- `mart_subscription_funnel`
- `mart_email_engagement`
- `mart_campaign_analytics`
- `mart_web_behavior`

---

## Analysis Queue

| # | Question | Week | Domain | Status | SQL | Notebook | Key Finding |
|---|----------|------|--------|--------|-----|----------|-------------|
| 1 | Subscription funnel over time (cohort analysis) | W1Q2/Q3 | Product | `[~]` | `W1Q2_active_customers_snapshot.sql` · `W1Q3_conversion_funnel_over_time.sql` | `W1Q2_active_customers_snapshot.ipynb` · `W1Q3_conversion_funnel_over_time.ipynb` | Findings written. DN-001: Dec 2022 data truncated. DN-002: pre-2020 no paid subs. |
| 2 | Customer lifetime journey | W2Q1 | Product | `[~]` | `W2Q1_customer_lifetime_journey.sql` | `W2Q1_customer_lifetime_journey.ipynb` | SQL + notebook ready — awaiting Snowflake run |
| 3 | Time on website before signup | W2Q2 | Product | `[~]` | `W2Q2_time_on_website_before_signup.sql` | `W2Q2_time_on_website_before_signup.ipynb` | SQL + notebook ready — awaiting Snowflake run |
| 4 | Timing of communications | W3Q3 | Marketing | `[~]` | `W3Q3_timing_of_communications.sql` | `W3Q3_timing_of_communications.ipynb` | SQL + notebook ready — awaiting Snowflake run |
| 5 | Cumulative conversion curves (2022 cohorts) | W3Q4 | Marketing | `[~]` | `W3Q4_cumulative_conversion_curves.sql` | `W3Q4_cumulative_conversion_curves.ipynb` | SQL + notebook ready — awaiting Snowflake run |
| 6 | Customer segments by conversion time | W3Q5 | Marketing | `[~]` | `W3Q5_customer_segments_by_conversion_time.sql` | `W3Q5_customer_segments_by_conversion_time.ipynb` | SQL + notebook ready — awaiting Snowflake run |
| 7 | Email campaign quasi-experiment (May 2022) | W4Q1 | Marketing | `[~]` | `W4Q1_email_quasi_experiment.sql` | `W4Q1_email_quasi_experiment.ipynb` | SQL + notebook ready — awaiting Snowflake run |
| 8 | Marketing 12m initiative — before/after | W4Q2 | Marketing | `[~]` | `W4Q2_marketing_12m_initiative.sql` | `W4Q2_marketing_12m_initiative.ipynb` | SQL + notebook ready — awaiting Snowflake run |
| 9 | Webpage conversion rate | W4Q4 | Product | `[~]` | `W4Q4_webpage_conversion_rate.sql` | `W4Q4_webpage_conversion_rate.ipynb` | SQL + notebook ready — awaiting Snowflake run |
| 10 | Login duration: converters vs. non-converters | W5Q3 | Product | `[~]` | `W5Q3_login_duration_converters_vs_not.sql` | `W5Q3_login_duration_converters_vs_not.ipynb` | SQL + notebook ready — awaiting Snowflake run |
| 11 | Customer service rep ROI | W5Q4 | Leadership | `[ ]` | — | — | Critical thinking question — no dataset required. Deliverable is a written analysis framework (Markdown). |
| 12 | Email performance (onboarding + A/B test) | W6Q1/Q2 | Marketing | `[~]` | `W6Q1Q2_email_campaign_performance.sql` | `W6Q1Q2_email_campaign_performance.ipynb` | SQL + notebook ready — awaiting Snowflake run |
| 13 | Digital campaign ROI | W6Q3 | Marketing | `[~]` | `W6Q3_digital_campaign_roi.sql` | `W6Q3_digital_campaign_roi.ipynb` | SQL + notebook ready — double-counting risk flagged |

**Status legend:** `[ ]` Not started · `[~]` In progress (SQL + notebook built, awaiting run) · `[x]` Done · `[!]` Blocked

---

## Notes & Data Limitations
- No geographic data in the database (phone/email only) — Weeks 2Q3, 3Q1, 3Q2 are not executable as written
- Demographic data limited to `age` only — no gender or socioeconomic status available
- Subscription status calculations are relative to pipeline run date, not today
- Two campaign cost tables exist (`stg_campaign_performance` / `stg_campaign_cost`) — verify no double-counting before W6Q3

## Data Notes
See [`DATA_NOTES.md`](DATA_NOTES.md) for detailed findings. Summary:

| ID | Issue | Affects |
|----|-------|---------|
| DN-001 | Signup & trial data truncated after Dec 1, 2022 — one day of data only. Jan–Mar 2023 absent entirely. | W1Q2 · W1Q3 · W1Q4 |
| DN-002 | Paid subscriptions (3m, 12m) not available before Jan 2020 — 2019 conversion rates are structurally zero. All-time medians are distorted. | W1Q3 · any all-time conversion baseline |
