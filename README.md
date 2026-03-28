# GeekyBald Analytics — Analysis Portfolio

End-to-end analysis of an e-learning subscription platform. Built to demonstrate SQL fluency, statistical thinking, product sense, and business communication for Data Scientist / Product Analytics Lead / Analytics Manager roles.

---

## Business Context

**GeekyBald** is an e-learning platform selling online courses via a subscription funnel:

```
Free 7-day trial  →  3-month subscription ($89.99)  →  12-month subscription ($299.99)
```

- ~43,898 unique users across **Jan 2019 – Mar 2023**
- Acquisition via paid campaigns and organic channels
- Data warehouse: **Snowflake**, transformed via **dbt** (see `../DDS_data/`)

---

## Repository Structure

```
geekybald_analysis/
├── sql/                    ← One SQL file per analysis question
├── notebooks/              ← Paired Jupyter notebook per SQL file
├── output/                 ← Exported charts (PNG)
├── src/
│   └── connection.py       ← Snowflake connection helper
├── DATA_NOTES.md           ← Documented data quality issues
├── ANALYSIS_TRACKER.md     ← Full analysis queue and status
└── requirements.txt        ← Python dependencies
```

---

## Tech Stack

| Layer | Tools |
|-------|-------|
| Data warehouse | Snowflake (`ANALYTICS.MARTS` schema) |
| Transformation | dbt Cloud (see `../DDS_data/`) |
| Analysis | Python 3.13, pandas, scipy |
| Visualization | matplotlib, seaborn |
| Environment | Jupyter notebooks, python-dotenv |

---

## Data Sources

All queries run against five mart tables in Snowflake:

| Table | Grain | Content |
|-------|-------|---------|
| `mart_users` | 1 row/user | Identity, visit metrics, acquisition type |
| `mart_subscription_funnel` | 1 row/user | Full funnel stages, days between stages |
| `mart_email_engagement` | 1 row/user/campaign | Delivery, open, click, bounce, spam rates |
| `mart_campaign_analytics` | 1 row/campaign/day | Impressions, clicks, cost, CTR, CPC |
| `mart_web_behavior` | 1 row/user | Pre-signup visits, first page, days to signup |

---

## Analysis Questions

All analyses follow the same structure: **business question → SQL → notebook → findings → recommendation**.

| # | Question | Domain | SQL | Notebook | Status |
|---|----------|--------|-----|----------|--------|
| 1 | Active customer snapshot (MoM / YoY) | Product | `W1Q2_active_customers_snapshot.sql` | `W1Q2_active_customers_snapshot.ipynb` | Complete |
| 2 | Conversion funnel rates over time | Product | `W1Q3_conversion_funnel_over_time.sql` | `W1Q3_conversion_funnel_over_time.ipynb` | Complete |
| 3 | Customer lifetime journey (time between stages) | Product | `W2Q1_customer_lifetime_journey.sql` | `W2Q1_customer_lifetime_journey.ipynb` | Complete |
| 4 | Time on website before signup | Product | `W2Q2_time_on_website_before_signup.sql` | `W2Q2_time_on_website_before_signup.ipynb` | Ready |
| 5 | Timing of email communications relative to funnel | Marketing | `W3Q3_timing_of_communications.sql` | `W3Q3_timing_of_communications.ipynb` | Ready |
| 6 | Cumulative conversion curves (2022 cohorts) | Marketing | `W3Q4_cumulative_conversion_curves.sql` | `W3Q4_cumulative_conversion_curves.ipynb` | Ready |
| 7 | Customer segments by conversion speed | Marketing | `W3Q5_customer_segments_by_conversion_time.sql` | `W3Q5_customer_segments_by_conversion_time.ipynb` | Ready |
| 8 | Email campaign quasi-experiment (May 2022) | Marketing | `W4Q1_email_quasi_experiment.sql` | `W4Q1_email_quasi_experiment.ipynb` | Ready |
| 9 | Marketing 12m initiative — before/after analysis | Marketing | `W4Q2_marketing_12m_initiative.sql` | `W4Q2_marketing_12m_initiative.ipynb` | Ready |
| 10 | Webpage entry-point conversion rate | Product | `W4Q4_webpage_conversion_rate.sql` | `W4Q4_webpage_conversion_rate.ipynb` | Ready |
| 11 | Login duration: converters vs. non-converters | Product | `W5Q3_login_duration_converters_vs_not.sql` | `W5Q3_login_duration_converters_vs_not.ipynb` | Ready |
| 12 | Customer service rep ROI | Leadership | — | — | Framework only (no CSR data in warehouse) |
| 13 | Email campaign performance (onboarding + A/B) | Marketing | `W6Q1Q2_email_campaign_performance.sql` | `W6Q1Q2_email_campaign_performance.ipynb` | Ready |
| 14 | Digital campaign ROI | Marketing | `W6Q3_digital_campaign_roi.sql` | `W6Q3_digital_campaign_roi.ipynb` | Ready |

**Status key:** Complete = SQL run + findings written · Ready = SQL + notebook built, awaiting Snowflake run

---

## Key Findings (Completed Analyses)

### W1Q2 — Active Customer Snapshot (Dec 2022)
- Upsells (3m → 12m) grew **+25.5% MoM** (763 in Dec vs. Nov), but renewals fell **-15.1%**
- Hypothesis: the upsell push may be cannibalizing renewal cohorts, not representing net growth
- Recommendation: decompose the renewal dip by cohort vintage before declaring the upsell campaign a success

### W1Q3 — Conversion Funnel Over Time
- **Signup → trial rate: ~41% — flat for 4 years.** The biggest untapped lever in the funnel; no improvement despite product changes over the period
- **Trial → 3m: improved from ~50% to 57.6%** (Jan–Sep 2022), suggesting recent conversion optimizations are working
- **3m → 12m: ~77%** — strong; annual upsell is the healthiest part of the funnel
- Note: all-time medians are distorted by 2019 structural zeros (see DN-002)

### W2Q1 — Customer Lifetime Journey
*Based on 41,817 users with signup date ≥ Jan 2020*

- **Signup → trial: median 0 days (P75 = 6 days).** The trial decision happens at or immediately after signup — this is a friction/motivation problem at the moment of account creation, not a nurturing problem
- **Trial → 3m: median 15 days, IQR 12–19.** The 7-day spread is too tight for organic behavior; consistent with a system-triggered conversion event firing ~8 days after trial expiry
- **3m → 12m: median 96 days, IQR 94–98.** A 4-day spread across 41K users is nearly impossible organically — almost certainly an auto-renewal or renewal campaign at a fixed offset from 3m expiry
- **No paid vs. organic difference at any stage.** Acquisition channel has zero bearing on journey speed
- **Funnel reach:** 41.3% reach trial, 22.7% pay once, 12.8% reach 12m — **77.3% of signups never convert to paid**
- Recommendation: optimize the day-15 and day-96 triggers (timing, content, offer) rather than segmenting by user attributes; cross-reference with W3Q3 email timing analysis

---

## Data Quality Notes

See [`DATA_NOTES.md`](DATA_NOTES.md) for full details.

| ID | Issue | Impact |
|----|-------|--------|
| DN-001 | Signup and trial data truncated after Dec 1, 2022 — only one day of December; Jan–Mar 2023 absent entirely | W1Q2, W1Q3, W1Q4 — December figures are underestimates |
| DN-002 | 3-month and 12-month subscriptions not available before Jan 2020 — pre-2020 paid conversion rates are structurally zero | All-time conversion baselines are distorted; use Jan 2020+ |

Additional constraints:
- No geographic data → geo-segmentation analyses not executable
- Demographic data limited to `age` only — no gender or SES available
- Subscription status is relative to pipeline run date, not today
- Two campaign cost tables exist (`stg_campaign_performance` / `stg_campaign_cost`) — double-counting risk flagged for W6Q3

---

## Setup

```bash
# Install dependencies
pip install -r requirements.txt

# Configure Snowflake credentials
# Create a .env file with: SNOWFLAKE_ACCOUNT, USER, PASSWORD, ROLE, WAREHOUSE, DATABASE, SCHEMA

# Run a notebook
jupyter notebook notebooks/W2Q1_customer_lifetime_journey.ipynb
```

Connection setup is handled by `src/connection.py` using `python-dotenv`.
