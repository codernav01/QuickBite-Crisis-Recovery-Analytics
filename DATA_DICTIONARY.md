# QuickBite Data Dictionary

This file summarizes the analytical role and expected grain of the eight source tables used in the QuickBite case study. It is intentionally a portfolio-level dictionary; the source schema and SQL inspection queries remain the technical source of truth.

| Table | Expected grain | Primary analytical key | Purpose |
|---|---|---|---|
| `dim_customer` | one row per customer | `customer_id` | customer attributes and segmentation |
| `dim_delivery_partner` | one row per delivery partner | `delivery_partner_id` | partner type, vehicle/employment attributes |
| `dim_restaurant` | one row per restaurant | `restaurant_id` | restaurant, city, cuisine and operational attributes |
| `dim_menu_item` | one row per menu item | `menu_item_id` | item-level menu attributes linked to restaurants |
| `fact_orders` | one row per order | `order_id` | order dates, status and commercial metrics |
| `fact_order_items` | order-item detail | `order_id` + `menu_item_id` | quantities, item prices, discounts and item economics |
| `fact_delivery_performance` | one row per order | `order_id` | delivery duration, SLA and related operational measures |
| `fact_ratings` | rating/review record by order | `order_id` | rating and review-based customer-experience signals |

## Main Relationships

```text
dim_customer ───────┐
                    ├── fact_orders ─── fact_order_items
dim_restaurant ─────┤       │
                    │       ├── fact_delivery_performance
dim_delivery_partner┘       └── fact_ratings

dim_restaurant ───────────── dim_menu_item
```

The SQL layer also validates customer, restaurant, menu-item, delivery-partner and order relationships before analytical joins are trusted.

## Metric Interpretation

- **Order value** is an analytical commercial measure derived from the supplied order data; it is not labelled as audited revenue.
- **SLA breach rate** is based on the project’s SLA logic in the analytical workflow.
- **Active customer** and customer-value labels use project-defined analytical rules.
- **Business phase** separates the supplied pre-crisis and crisis comparison periods.

For exact field-level types and constraints, see the schema-inspection section of `sql/quickbite_bi_analytics.sql`.
