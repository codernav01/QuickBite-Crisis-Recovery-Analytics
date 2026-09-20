# QuickBite Express — Crisis Recovery Analytics

> **Flagship Data Analyst case study:** validating relational data, defining business metrics, diagnosing operational deterioration, and translating findings into recovery priorities with Python and MySQL.

<p align="center">
  <img src="assets/quickbite-executive-summary.svg" alt="QuickBite Executive KPI Summary" width="100%">
</p>

## Recruiter Snapshot

| Area | Evidence |
|---|---|
| **Business problem** | Diagnose a major food-delivery disruption beginning in June 2025 |
| **Data model** | 8 relational customer, restaurant, order, item, delivery, and rating datasets |
| **Python** | inspection, cleaning, feature engineering, EDA, KPI analysis |
| **SQL** | schema inspection, grain checks, integrity validation, views, CTEs, window functions |
| **Data quality** | key checks, orphan checks, rule validation, financial and item/order reconciliation |
| **Business output** | quantified impact, affected segments, operational diagnosis, recovery priorities |

## Executive Summary

The project compares a **pre-crisis period (January–May 2025)** with a **crisis period (June–September 2025)**. The supplied case-study data shows broad deterioration across demand, customer activity, delivery performance, ratings, and retention signals.

| KPI | Pre-crisis | Crisis | Change |
|---|---:|---:|---:|
| Orders | 110,672 | 33,441 | **-69.78%** |
| Order value | ₹37.62M | ₹10.94M | **-70.92%** |
| Active customers | 83,740 | 30,511 | **-63.56%** |
| Avg. delivery time | 39.53 min | 60.11 min | **+52.09%** |
| SLA breach rate | 56.41% | 87.74% | **+31.33 pp** |
| Avg. rating | 4.51 | 2.54 | **-43.77%** |
| Cancellation rate | 3.40% | 6.87% | **+3.47 pp** |

## Business Questions

- How large was the decline in demand and order value?
- Which customers, cities, restaurants, and operational segments were most affected?
- How did delivery time, SLA performance, cancellations, and ratings change?
- Which historically valuable customers reduced activity?
- Which measured problems should management investigate first?

## Data Model

| Dataset | Intended grain | Analytical role |
|---|---|---|
| `dim_customer.csv` | one row per customer | customer profile and segmentation |
| `dim_delivery_partner_.csv` | one row per delivery partner | partner attributes |
| `dim_restaurant.csv` | one row per restaurant | restaurant attributes |
| `dim_menu_item.csv` | one row per menu item | menu and item attributes |
| `fact_orders.csv` | one row per order | core commercial metrics |
| `fact_order_items.csv` | order-item detail | item economics and reconciliation |
| `fact_delivery_performance.csv` | one row per order | delivery and SLA metrics |
| `fact_ratings.csv` | rating/review records | customer-experience signals |

See [DATA_DICTIONARY.md](DATA_DICTIONARY.md) for the portfolio-level data model summary.

## Analytical Workflow

```text
Raw relational data
      ↓
Schema and grain inspection
      ↓
Key / relationship / business-rule validation
      ↓
Python cleaning and feature engineering
      ↓
EDA and KPI analysis
      ↓
MySQL analytical views and business queries
      ↓
Cross-check findings
      ↓
Business diagnosis and recovery priorities
```

## Data Quality & Validation

The analysis does not assume the source data is clean. It explicitly checks:

- table grain and duplicate business keys
- required identifiers and nulls
- orphaned records across major relationships
- rating, quantity, financial, and delivery business rules
- order-value reconciliation
- item-level vs order-level subtotal consistency
- cancelled-order financial consistency

Some reconciliation checks identify mismatches rather than silently forcing the data to agree. These are documented as analytical limitations rather than hidden.

See [VALIDATION_NOTES.md](VALIDATION_NOTES.md).

## Key Findings

### Commercial performance
- Orders fell from **110,672 to 33,441**.
- Order value declined from **₹37.62M to ₹10.94M**.
- Active customers declined **63.56%**, indicating that the contraction extended beyond order frequency.

### Operations
- Average delivery time increased from **39.53 to 60.11 minutes**.
- SLA breach rate increased from **56.41% to 87.74%**.
- Cancellation rate increased from **3.40% to 6.87%**.

### Customer experience and value risk
- Average rating declined from **4.51 to 2.54**.
- **49 of 58** customers classified as loyal in the project analysis were classified as churned.
- **4,156 of 4,188** customers classified as high-value showed declining activity.

These are descriptive signals observed in the supplied project data; they do not independently prove that any single operational factor caused the broader crisis.

## Recovery Priorities

1. Investigate the sharp rise in SLA breaches and delivery time.
2. Prioritize retention analysis for historically high-value customers with declining activity.
3. Focus operational review on the cities and restaurants with the largest measured deterioration.
4. Investigate cancellation growth alongside delivery and service-quality signals.
5. Track ratings and review themes as customer-experience indicators during recovery.

## Repository Contents

```text
QuickBite-Crisis-Recovery-Analytics/
├── README.md
├── DATA_DICTIONARY.md
├── VALIDATION_NOTES.md
├── requirements.txt
├── quickbite_crisis_analysis.ipynb
├── sql/
│   └── quickbite_bi_analytics.sql
├── assets/
│   └── quickbite-executive-summary.svg
└── source CSV datasets
```

> Existing source files remain in their original locations so the notebook and SQL workflow are not disrupted.

## How to Review the Project

**Recruiter / hiring manager:** start with this README, the executive summary visual, and the Key Findings section.  
**Technical reviewer:** inspect `sql/quickbite_bi_analytics.sql`, then the notebook and validation notes.  
**Reproduction:** install the packages in `requirements.txt`, open the notebook, and keep the source CSV files in their current repository paths.

## Tech Stack

**Python:** Pandas, NumPy, Matplotlib, Seaborn  
**Database:** MySQL  
**SQL:** joins, CTEs, subqueries, window functions, validation queries, analytical views  
**Environment:** Jupyter Notebook, Git, GitHub

## Scope & Limitations

- The business-crisis scenario and comparison periods come from the supplied project brief.
- The analysis is descriptive and decision-support oriented, not causal.
- Financial reconciliation checks identify source-data inconsistencies; measured order value should not be presented as audited accounting revenue.
- Customer labels such as “loyal,” “high-value,” or “churned” use project-defined analytical rules.
- Findings should be interpreted within the supplied data coverage and definitions.

## What This Project Demonstrates

**Validate the data → define the metric → quantify the change → locate the problem → identify affected segments → communicate decisions.**
