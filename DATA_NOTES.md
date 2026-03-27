# Data Notes & Findings

Critical observations about the data that affect analysis interpretation.
Always consult this file before writing findings or recommendations.

---

## DN-001 — Signup & Trial Data Truncated After December 1, 2022

**Discovered:** W1Q2 / data coverage check (`sql/data_coverage_check.sql`)
**Affects:** W1Q2 · W1Q3 · W1Q4

### What we found
The documentation states the database covers January 1, 2019 through March 31, 2023.
The actual data tells a different story:

| Event | Max Date | Notes |
|-------|----------|-------|
| `signup_date` | 2022-12-01 | All December signups fall on a single day |
| `trial_date` | 2022-12-01 | Same — one day only |
| `subscr_3m_date` | 2022-12-30 | Full month present |
| `subscr_12m_date` | 2022-12-31 | Full month present |

**January–March 2023 does not exist in any table.**

### Root cause hypothesis
The signup and trial ingestion pipeline stopped after December 1, 2022.
The 3-month and 12-month subscription tables continued receiving data through month end.
This is likely a source data issue, not a dbt transformation issue.

### Impact per question

**W1Q2 — Active Customer Snapshot**
- The 53 new signups and 26 active trials reported for December 2022 represent **one day of data only**, not the full month.
- These numbers must not be used for MoM comparison on signups or trials.
- 3m and 12m subscriber counts for December remain valid.
- **Action:** Flag December signup/trial figures as unreliable in the notebook findings.

**W1Q3 — Conversion Funnel Over Time**
- The volume chart for signups and trials must be interpreted with November 2022 as the effective end date.
- December 2022 should be visually flagged or excluded from the signup/trial lines.
- Conversion rates (trial → 3m, 3m → 12m) are unaffected for cohorts prior to October 2022.
- **Action:** SQL date boundary for signup/trial volume updated to November 2022.

**W1Q4 — Signup Slowdown Oct–Dec 2022**
- October and November 2022 are valid months for trend analysis.
- December 2022 cannot be used — it is one day of data.
- The question should be reframed as: *"Is there a slowdown in Oct–Nov 2022?"*
- **Action:** Reframe the question scope in the W1Q4 notebook accordingly.

### What to tell stakeholders
> "The signup and free trial data appears to stop on December 1, 2022, rather than December 31.
> All December signup figures reflect a single day of activity and should not be treated as a
> complete monthly figure. This should be investigated with the data engineering team to determine
> whether the source system stopped sending events or whether there was a pipeline failure.
> 3-month and 12-month subscription data for December remains complete and reliable."

---
