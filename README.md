# QuickBite Express — Crisis Recovery Analytics

> End-to-end analytics case study using Python and MySQL/SQL to diagnose a food-delivery business crisis and translate the findings into recovery priorities.

## Executive Summary

QuickBite Express experienced a major disruption beginning in **June 2025**. This project compares the **pre-crisis period (January–May 2025)** with the **crisis period (June–September 2025)** across eight relational datasets covering customers, restaurants, orders, order items, delivery performance, and ratings.

The analysis shows that the problem was broader than a simple demand decline. Customer activity, order value, delivery reliability, ratings, and retention signals all deteriorated during the crisis period.

| KPI | Change |
|---|---:|
| Orders | **-69.78%** |
| Order value | **-70.92%** |
| Active customers | **-63.56%** |
| Average delivery time | **+52.09%** |
| SLA breach rate | **+31.33 percentage points** |
| Average customer rating | **-43.77%** |
| Cancellation rate | **3.40% → 6.87%** |

## Business Questions

- How large was the decline in demand and order value?
- Which customer, city, and restaurant segments were most affected?
- How did delivery time, SLA performance, and cancellations change?
- Did customer ratings deteriorate during the same period?
- Which historically valuable customers reduced activity?
- Which recovery actions should management prioritize?

## Data Model

| Dataset | Purpose / grain |
|---|---|
| `dim_customer.csv` | One row per customer |
| `dim_delivery_partner_.csv` | One row per delivery partner |
| `dim_restaurant.csv` | One row per restaurant |
| `dim_menu_item.csv` | One row per menu item |
| `fact_orders.csv` | One row per order |
| `fact_order_items.csv` | Order-item level detail |
| `fact_delivery_performance.csv` | Delivery metrics by order |
| `fact_ratings.csv` | Rating / review records |

## Analytical Workflow

```text
Raw relational data
      ↓
Python inspection and cleaning
      ↓
Data-quality and integrity validation
      ↓
Feature engineering and EDA
      ↓
MySQL relational validation
      ↓
Reusable SQL analytics layer
      ↓
KPI and segment analysis
      ↓
Business diagnosis
      ↓
Recovery priorities
```

## Data Quality Work

Before KPI analysis, the project checks:

- table grain and duplicate business keys
- null and duplicate identifiers
- orphaned records across joins
- rating and quantity business rules
- negative financial / delivery values
- order-value reconciliation
- item-level vs order-level subtotal consistency
- cancelled-order financial consistency

## SQL Analytics Layer

The SQL work includes:

- schema and index inspection
- grain validation
- key-integrity checks
- relationship validation
- pre-crisis vs crisis comparisons
- monthly KPI trends
- customer activity analysis
- restaurant and city performance
- delivery and SLA analysis
- cancellation analysis
- ratings analysis
- high-value customer analysis
- reusable analytical views

Techniques include **joins, CTEs, subqueries, CASE expressions, aggregations, date analysis, and window functions**.

## Key Findings

### Demand and commercial performance
Orders, active customers, and order value all fell sharply during the crisis period, indicating a broad contraction in marketplace activity.

### Operations
Average delivery time increased by **52.09%**, while SLA breaches and cancellations also increased. Operational deterioration therefore accompanied the demand decline.

### Customer experience
Average ratings declined substantially during the same period. This is treated as an experience signal associated with the crisis period, not proof that one metric directly caused another.

### Customer value risk
A large share of customers classified as historically high-value showed reduced activity during the crisis, making retention and service recovery a management priority.

## Recovery Priorities

1. **Stabilize operations** — reduce delivery delays, SLA breaches, and cancellations.
2. **Protect valuable customers** — focus retention efforts on previously loyal / high-value customers whose activity declined.
3. **Prioritize recovery markets** — identify restaurants and cities contributing most to lost activity.
4. **Rebuild customer experience** — use ratings and review patterns to locate recurring service issues.

## Repository Contents

```text
QuickBite-Crisis-Recovery-Analytics/
├── README.md
├── QuickBite_BI_SQL_Analytics.sql
├── Capstone end to end data analytics project 102.ipynb
└── source CSV datasets
```

> The current repository contains the analytical notebook, SQL layer, and source datasets. Power BI or executive-report assets should be added only when the actual files or screenshots are available.

## Tech Stack

**Python:** Pandas, NumPy, Matplotlib, Seaborn  
**Database:** MySQL  
**SQL:** joins, CTEs, window functions, validation queries, analytical views  
**Environment:** Jupyter Notebook, Git, GitHub

## What This Project Demonstrates

**Validate the data → define the comparison → quantify the change → locate the operational problem → identify affected segments → translate findings into decisions.**
