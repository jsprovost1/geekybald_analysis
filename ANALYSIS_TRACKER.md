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
| 1 | Subscription funnel over time (cohort analysis) | W1Q2/Q3 | Product | `[~]` | `W1Q2_active_customers_snapshot.sql` · `W1Q3_conversion_funnel_over_time.sql` | `W1Q2_active_customers_snapshot.ipynb` · `W1Q3_conversion_funnel_over_time.ipynb` | SQL done, notebooks running — findings pending. Dec 2022 signup/trial data truncated (DN-001) |
| 2 | Customer lifetime journey | W2Q1 | Product | `[ ]` | | | |
| 3 | Time on website before signup | W2Q2 | Product | `[ ]` | | | |
| 4 | Timing of communications | W3Q3 | Marketing | `[ ]` | | | |
| 5 | Cumulative conversion curves (2022 cohorts) | W3Q4 | Marketing | `[ ]` | | | |
| 6 | Customer segments by conversion time | W3Q5 | Marketing | `[ ]` | | | |
| 7 | Email campaign quasi-experiment (May 2022) | W4Q1 | Marketing | `[ ]` | | | |
| 8 | Marketing 12m initiative — before/after | W4Q2 | Marketing | `[ ]` | | | |
| 9 | Webpage conversion rate | W4Q4 | Product | `[ ]` | | | |
| 10 | Login duration: converters vs. non-converters | W5Q3 | Product | `[ ]` | | | |
| 11 | Customer service rep ROI | W5Q4 | Leadership | `[ ]` | | | |
| 12 | Email performance (onboarding + A/B test) | W6Q1/Q2 | Marketing | `[ ]` | | | |
| 13 | Digital campaign ROI | W6Q3 | Marketing | `[ ]` | | | |

**Status legend:** `[ ]` Not started · `[~]` In progress · `[x]` Done

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
