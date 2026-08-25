-- ============================================================
-- QUICKBITE BI
-- PART 1 — DATABASE ARCHITECTURE & ENVIRONMENT SETUP
-- ============================================================

-- CREATE DATABASE
CREATE DATABASE quickbite_bi;
-- Establishes the central QuickBite BI database for source data,
-- analytical processing, validation, and reporting.

-- Use Database quickbite_bi;
USE quickbite_bi;

-- Selects the QuickBite BI database as the active working environment for all subsequent SQL operations.

-- ------------------------------------------------------------
-- Loaded table inventory
-- ------------------------------------------------------------

SELECT'1. dim_customer' AS table_name,COUNT(*) AS total_rows FROM dim_customer
UNION ALL
SELECT'2. dim_delivery_partner',COUNT(*)FROM dim_delivery_partner
UNION ALL
SELECT '3. dim_restaurant',COUNT(*)FROM dim_restaurant
UNION ALL
SELECT'4. dim_menu_item',COUNT(*)FROM dim_menu_item
UNION ALL
SELECT'5. fact_orders',COUNT(*)FROM fact_orders
UNION ALL
SELECT'6. fact_order_items',COUNT(*)FROM fact_order_items
UNION ALL
SELECT'7. fact_delivery_performance',COUNT(*)FROM fact_delivery_performance
UNION ALL SELECT'8. fact_ratings',COUNT(*)FROM fact_ratings;

-- Provides a quick inventory of all source tables and their record volumes
-- to confirm the expected QuickBite data has been loaded successfully.


-- ============================================================
-- PART 2.1 — COMPLETE SCHEMA INSPECTION
-- ============================================================

SELECT TABLE_NAME,ORDINAL_POSITION,
COLUMN_NAME,
DATA_TYPE,IS_NULLABLE,
COLUMN_KEY,COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
AND TABLE_NAME IN (
'dim_customer','dim_delivery_partner',
'dim_restaurant','dim_menu_item',
'fact_orders','fact_order_items',
'fact_delivery_performance','fact_ratings')
ORDER BY TABLE_NAME,ORDINAL_POSITION;

-- Inspects table structures, data types, nullability, and key definitions
-- to establish a clear understanding of the QuickBite database schema.

-- ============================================================
-- PART 2.2 — KEY INSPECTION
-- ============================================================

SELECT TABLE_NAME,INDEX_NAME,COLUMN_NAME,
SEQ_IN_INDEX,NON_UNIQUE
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = DATABASE()
AND TABLE_NAME IN (
'dim_customer','dim_delivery_partner',
'dim_restaurant','dim_menu_item',
'fact_orders','fact_order_items',
'fact_delivery_performance','fact_ratings')
ORDER BY TABLE_NAME,INDEX_NAME,SEQ_IN_INDEX;

-- Reviews available keys and indexes to verify how tables are structured
-- for reliable joins and efficient analytical queries.

-- ============================================================
-- PART 2.3 — RELATIONSHIP CATALOG
-- ============================================================

SELECT
'fact_orders' AS child_table,'customer_id' AS child_column,
'dim_customer' AS parent_table,'customer_id' AS parent_column
UNION ALL
SELECT'fact_orders','restaurant_id','dim_restaurant','restaurant_id'
UNION ALL
SELECT'fact_orders','delivery_partner_id','dim_delivery_partner','delivery_partner_id'
UNION ALL
SELECT'fact_order_items','order_id','fact_orders','order_id'
UNION ALL
SELECT'fact_order_items','menu_item_id','dim_menu_item','menu_item_id'
UNION ALL
SELECT'fact_order_items','restaurant_id','dim_restaurant','restaurant_id'
UNION ALL
SELECT'fact_delivery_performance','order_id','fact_orders','order_id'
UNION ALL
SELECT'fact_ratings','order_id','fact_orders','order_id'
UNION ALL
SELECT'fact_ratings','customer_id','dim_customer','customer_id'
UNION ALL
SELECT'fact_ratings','restaurant_id','dim_restaurant','restaurant_id'
UNION ALL
SELECT'dim_menu_item','restaurant_id','dim_restaurant','restaurant_id';

-- Defines the key relationships between fact and dimension tables
-- to support consistent joins and a reliable analytical data model.

-- ============================================================
-- PART 2.4 — TABLE GRAIN VALIDATION
-- ============================================================

SELECT'dim_customer' AS table_name,'One row per customer' AS expected_grain,
COUNT(*) AS rowss,COUNT(DISTINCT customer_id) AS distinct_business_keys
FROM dim_customer
UNION ALL SELECT'dim_delivery_partner','One row per delivery partner',
COUNT(*),COUNT(DISTINCT delivery_partner_id)
FROM dim_delivery_partner
UNION ALL
SELECT'dim_restaurant','One row per restaurant',
COUNT(*),COUNT(DISTINCT restaurant_id)
FROM dim_restaurant
UNION ALL
SELECT'dim_menu_item','One row per menu item',
COUNT(*),COUNT(DISTINCT menu_item_id)
FROM dim_menu_item
UNION ALL
SELECT'fact_orders','One row per order',
COUNT(*),COUNT(DISTINCT order_id)
FROM fact_orders
UNION ALL
SELECT'fact_delivery_performance','One row per order',
COUNT(*),COUNT(DISTINCT order_id)
FROM fact_delivery_performance
UNION ALL
SELECT'fact_ratings','One rating record per order',
COUNT(*),COUNT(DISTINCT order_id)
FROM fact_ratings
UNION ALL
SELECT'fact_order_items' AS table_name,'One row per order-item combination' AS expected_grain,
COUNT(*) AS rows_count,COUNT(DISTINCT CONCAT(order_id, '|', menu_item_id)) AS distinct_business_keys
FROM fact_order_items;

-- Validates the intended grain of each table by comparing total records
-- with distinct business keys to identify unexpected duplication.

-- ============================================================
-- PART 3.1 — KEY INTEGRITY
-- ============================================================

SELECT
    'dim_customer' AS table_name,
    'customer_id NULL' AS validation,
    COUNT(*) AS invalid_records
FROM dim_customer
WHERE customer_id IS NULL

UNION ALL

SELECT'dim_customer','customer_id duplicate',
COUNT(*)
FROM (
SELECT customer_id
FROM dim_customer
WHERE customer_id IS NOT NULL
GROUP BY customer_id
HAVING COUNT(*) > 1) x

UNION ALL

SELECT
    'dim_delivery_partner',
    'delivery_partner_id NULL',
    COUNT(*)
FROM dim_delivery_partner
WHERE NULLIF(TRIM(delivery_partner_id), '') IS NULL

UNION ALL

SELECT
    'dim_delivery_partner',
    'delivery_partner_id duplicate',
    COUNT(*)
FROM (
    SELECT delivery_partner_id
    FROM dim_delivery_partner
    WHERE NULLIF(TRIM(delivery_partner_id), '') IS NOT NULL
    GROUP BY delivery_partner_id
    HAVING COUNT(*) > 1
) x

UNION ALL

SELECT
    'dim_restaurant',
    'restaurant_id NULL',
    COUNT(*)
FROM dim_restaurant
WHERE restaurant_id IS NULL

UNION ALL

SELECT
    'dim_restaurant',
    'restaurant_id duplicate',
    COUNT(*)
FROM (
    SELECT restaurant_id
    FROM dim_restaurant
    WHERE restaurant_id IS NOT NULL
    GROUP BY restaurant_id
    HAVING COUNT(*) > 1
) x

UNION ALL

SELECT
    'dim_menu_item',
    'menu_item_id NULL',
    COUNT(*)
FROM dim_menu_item
WHERE menu_item_id IS NULL

UNION ALL

SELECT
    'dim_menu_item',
    'menu_item_id duplicate',
    COUNT(*)
FROM (
    SELECT menu_item_id
    FROM dim_menu_item
    WHERE menu_item_id IS NOT NULL
    GROUP BY menu_item_id
    HAVING COUNT(*) > 1
) x

UNION ALL

SELECT
    'fact_orders',
    'order_id NULL',
    COUNT(*)
FROM fact_orders
WHERE order_id IS NULL

UNION ALL

SELECT
    'fact_orders',
    'order_id duplicate',
    COUNT(*)
FROM (
    SELECT order_id
    FROM fact_orders
    WHERE order_id IS NOT NULL
    GROUP BY order_id
    HAVING COUNT(*) > 1
) x

UNION ALL

SELECT
    'fact_delivery_performance',
    'order_id NULL',
    COUNT(*)
FROM fact_delivery_performance
WHERE order_id IS NULL

UNION ALL

SELECT
    'fact_delivery_performance',
    'order_id duplicate',
    COUNT(*)
FROM (
    SELECT order_id
    FROM fact_delivery_performance
    WHERE order_id IS NOT NULL
    GROUP BY order_id
    HAVING COUNT(*) > 1
) x

UNION ALL

SELECT
    'fact_ratings',
    'order_id NULL',
    COUNT(*)
FROM fact_ratings
WHERE order_id IS NULL

UNION ALL

SELECT
    'fact_ratings',
    'order_id duplicate',
    COUNT(*)
FROM (
    SELECT order_id
    FROM fact_ratings
    WHERE order_id IS NOT NULL
    GROUP BY order_id
    HAVING COUNT(*) > 1
) x;

-- Validates primary business keys for NULLs and duplicates
-- to ensure each entity can be reliably identified in the BI model.

-- ============================================================
-- PART 3.2 — FACT ORDER ITEM GRAIN
-- ============================================================

SELECT order_id,menu_item_id,
COUNT(*) AS record_count
FROM fact_order_items
GROUP BY order_id,menu_item_id
HAVING COUNT(*) > 1;

-- Checks the order-item grain by identifying duplicate order and menu-item combinations.
-- This ensures each order-item relationship is represented at the expected level of detail.

-- ============================================================
-- PART 3.3 — REFERENTIAL INTEGRITY
-- ============================================================

SELECT COUNT(*) AS orphan_orders_customer
FROM fact_orders o
LEFT JOIN dim_customer c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL

UNION ALL

SELECT COUNT(*) AS orphan_orders_restaurant
FROM fact_orders o
LEFT JOIN dim_restaurant r
    ON o.restaurant_id = r.restaurant_id
WHERE r.restaurant_id IS NULL

UNION ALL

SELECT COUNT(*) AS orphan_orders_delivery_partner
FROM fact_orders o
LEFT JOIN dim_delivery_partner d
    ON o.delivery_partner_id = d.delivery_partner_id
WHERE NULLIF(TRIM(o.delivery_partner_id), '') IS NOT NULL
  AND d.delivery_partner_id IS NULL

UNION ALL

SELECT COUNT(*) AS orphan_order_items
FROM fact_order_items oi
LEFT JOIN fact_orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL

UNION ALL

SELECT COUNT(*) AS orphan_order_items_restaurant
FROM fact_order_items oi
LEFT JOIN dim_restaurant r
    ON oi.restaurant_id = r.restaurant_id
WHERE r.restaurant_id IS NULL

UNION ALL

SELECT COUNT(*) AS orphan_menu_items
FROM fact_order_items oi
LEFT JOIN dim_menu_item m
    ON oi.menu_item_id = m.menu_item_id
WHERE m.menu_item_id IS NULL

UNION ALL

SELECT COUNT(*) AS orphan_delivery_records
FROM fact_delivery_performance d
LEFT JOIN fact_orders o
    ON d.order_id = o.order_id
WHERE o.order_id IS NULL

UNION ALL

SELECT COUNT(*) AS orphan_rating_records
FROM fact_ratings r
LEFT JOIN fact_orders o
    ON r.order_id = o.order_id
WHERE o.order_id IS NULL

UNION ALL

SELECT COUNT(*) AS orphan_ratings_customer
FROM fact_ratings r
LEFT JOIN dim_customer c
    ON r.customer_id = c.customer_id
WHERE NULLIF(TRIM(r.customer_id), '') IS NOT NULL
  AND c.customer_id IS NULL

UNION ALL

SELECT COUNT(*) AS orphan_ratings_restaurant
FROM fact_ratings r
LEFT JOIN dim_restaurant rest
    ON r.restaurant_id = rest.restaurant_id
WHERE NULLIF(TRIM(r.restaurant_id), '') IS NOT NULL
  AND rest.restaurant_id IS NULL;

-- Validates referential integrity across the core QuickBite fact and dimension tables.
-- This confirms that transactional records are correctly linked to their related master records.

-- ============================================================
-- PART 3.4 — BUSINESS RULE VALIDATION
-- ============================================================

SELECT'Invalid rating range' AS validation,
COUNT(*) AS invalid_records FROM fact_ratings WHERE rating < 1 OR rating > 5

UNION ALL

SELECT'Invalid quantity',
COUNT(*)FROM fact_order_items WHERE quantity <= 0

UNION ALL

SELECT'Invalid unit price',COUNT(*)
FROM fact_order_items
WHERE unit_price < 0

UNION ALL

SELECT'Invalid item discount',COUNT(*)
FROM fact_order_items WHERE item_discount < 0
OR item_discount > quantity * unit_price

UNION ALL

SELECT'Invalid order financial values',COUNT(*)FROM fact_orders
WHERE subtotal_amount < 0
OR discount_amount < 0
OR delivery_fee < 0
OR total_amount < 0

UNION ALL

SELECT'Invalid delivery measures',COUNT(*)
FROM fact_delivery_performance
WHERE actual_delivery_time_mins < 0
OR expected_delivery_time_mins < 0
OR distance_km < 0;

-- Validates core business rules across ratings, order items, orders, and delivery performance.
-- This helps ensure that operational and financial measures remain within valid business ranges.
   
-- ============================================================
-- PART 3.5 — ORDER FINANCIAL RECONCILIATION
-- ============================================================

SELECT COUNT(*) AS reconciliation_failures
FROM fact_orders
WHERE ROUND(ABS(total_amount -(subtotal_amount - discount_amount + delivery_fee)),2) > 0.01; 

-- Reconciles order totals against the underlying subtotal, discount, and delivery fee components.
-- This ensures that reported order values are financially consistent and free from material calculation errors.

-- ============================================================
-- PART 3.6 — ORDER ITEM TO ORDER RECONCILIATION
-- ============================================================

SELECT COUNT(*) AS reconciliation_failures
FROM (SELECT o.order_id,
ROUND(o.subtotal_amount - o.discount_amount, 2) AS expected_net_value,
ROUND(COALESCE(SUM(oi.line_total), 0), 2) AS item_net_value
FROM fact_orders o
LEFT JOIN fact_order_items oi
ON o.order_id = oi.order_id
WHERE o.is_cancelled = 'N'
GROUP BY 
o.order_id,o.subtotal_amount,
o.discount_amount) x
WHERE ABS(x.item_net_value - x.expected_net_value) > 0.01;

-- Reconciles order-level net values with the sum of their underlying order-item values.
-- This ensures item-level transactions accurately roll up to the corresponding order totals.

-- ============================================================
-- PART 3.7 — CANCELLED ORDER FINANCIAL CONTROL
-- ============================================================

SELECT COUNT(*) AS invalid_cancelled_orders
FROM fact_orders
WHERE is_cancelled = 'Y'
AND (subtotal_amount <> 0
OR discount_amount <> 0
OR delivery_fee <> 0
OR total_amount <> 0);

-- This control verifies that cancelled orders do not retain active financial amounts.
-- It helps maintain consistency between order status and the underlying financial records.

-- ============================================================
-- PART 4 — ANALYTICAL MODEL CHECK
-- ============================================================

SELECT'Customer → Orders' AS relationship,
COUNT(DISTINCT o.customer_id) AS child_entities,
COUNT(DISTINCT c.customer_id) AS matched_entities
FROM fact_orders o
LEFT JOIN dim_customer c
ON o.customer_id = c.customer_id

UNION ALL

SELECT'Restaurant → Orders',
COUNT(DISTINCT o.restaurant_id),
COUNT(DISTINCT r.restaurant_id)
FROM fact_orders o
LEFT JOIN dim_restaurant r
ON o.restaurant_id = r.restaurant_id

UNION ALL

SELECT'Restaurant → Menu',
COUNT(DISTINCT m.restaurant_id),
COUNT(DISTINCT r.restaurant_id)
FROM dim_menu_item m
LEFT JOIN dim_restaurant r
ON m.restaurant_id = r.restaurant_id;

-- This validates the key relationships between major fact and dimension tables.
-- It confirms that the analytical model is correctly connected for downstream reporting.

-- ============================================================
-- PART 5.1 — ORDER TRANSFORMATION LAYER
-- ============================================================

CREATE OR REPLACE VIEW vw_sql_order_enriched AS

SELECT
    o.order_id,
    o.customer_id,
    c.city AS customer_city,

    o.restaurant_id,
    r.restaurant_name,
    r.city AS restaurant_city,
    r.cuisine_type,
    r.partner_type,

    o.delivery_partner_id,
    dp.vehicle_type,
    dp.employment_type,

    o.order_timestamp,
    DATE(o.order_timestamp) AS order_date,
    TIME(o.order_timestamp) AS order_time,

    o.subtotal_amount,
    o.discount_amount,
    o.delivery_fee,
    o.total_amount,

    ROUND(o.subtotal_amount - o.discount_amount,2) AS net_subtotal,

    o.is_cod,
    o.is_cancelled,
    o.delivery_partner_assignment_status,

    d.actual_delivery_time_mins,
    d.expected_delivery_time_mins,
    d.distance_km,

    CASE
        WHEN d.actual_delivery_time_mins >
             d.expected_delivery_time_mins
        THEN d.actual_delivery_time_mins
             - d.expected_delivery_time_mins
        ELSE 0
    END AS delivery_delay_mins,

    CASE
        WHEN d.actual_delivery_time_mins >
             d.expected_delivery_time_mins
        THEN 'SLA Breached'
        WHEN d.actual_delivery_time_mins IS NULL
        THEN 'No Delivery Record'
        ELSE 'SLA Met'
    END AS sla_status,

    CASE
        WHEN o.is_cancelled = 'Y'
        THEN 'Cancelled'
        ELSE 'Completed'
    END AS order_status,

    o.business_phase

FROM fact_orders o

LEFT JOIN dim_customer c
    ON o.customer_id = c.customer_id

LEFT JOIN dim_restaurant r
    ON o.restaurant_id = r.restaurant_id

LEFT JOIN dim_delivery_partner dp
    ON o.delivery_partner_id = dp.delivery_partner_id

LEFT JOIN fact_delivery_performance d
    ON o.order_id = d.order_id;
    
-- This view enriches order-level data by combining customer, restaurant, delivery, and performance attributes.
-- It creates a reusable analytical layer for operational reporting, SLA analysis, and business-phase comparisons.

-- ============================================================
-- PART 5.2 — ORDER ITEM TRANSFORMATION
-- ============================================================

CREATE OR REPLACE VIEW vw_sql_order_item_economics AS

SELECT
    oi.order_id,

    COUNT(*) AS line_count,

    SUM(oi.quantity) AS total_quantity,

    COUNT(DISTINCT oi.menu_item_id)
        AS unique_menu_items,

    SUM(oi.unit_price * oi.quantity)
        AS gross_item_value,

    SUM(oi.item_discount)
        AS item_discount_value,

    SUM(oi.line_total)
        AS net_item_value

FROM fact_order_items oi

GROUP BY
    oi.order_id;
    
-- This view aggregates item-level transactions into order-level product and revenue metrics.
-- It provides a reusable layer for analyzing quantities, discounts, item value, and order composition.
    
-- ============================================================
-- PART 5.3 — OPERATIONAL SERVING TRANSFORMATION
-- ============================================================

CREATE OR REPLACE VIEW vw_sql_operational_order AS

SELECT
    e.order_id,
    e.customer_id,
    e.restaurant_id,
    e.delivery_partner_id,

    e.order_date,
    e.business_phase,

    e.order_status,
    e.sla_status,

    e.actual_delivery_time_mins,
    e.expected_delivery_time_mins,
    e.delivery_delay_mins,
    e.distance_km,

    oe.line_count,
    oe.total_quantity,
    oe.unique_menu_items,
    oe.gross_item_value,
    oe.item_discount_value,
    oe.net_item_value,

    e.subtotal_amount,
    e.discount_amount,
    e.delivery_fee,
    e.total_amount

FROM vw_sql_order_enriched e

LEFT JOIN vw_sql_order_item_economics oe
    ON e.order_id = oe.order_id;
    
-- This view combines enriched order information with item-level economics into a single operational dataset.
-- It provides a ready-to-use layer for operational monitoring, KPI analysis, and Power BI reporting.

-- ============================================================
-- PART 6.1 — CTE + GROUP BY + HAVING
-- ============================================================

WITH restaurant_activity AS (SELECT restaurant_id,COUNT(*) AS total_orders,SUM(total_amount) AS total_order_value
FROM fact_orders WHERE is_cancelled = 'N'GROUP BY restaurant_id)
SELECT restaurant_id,total_orders,
ROUND(total_order_value, 2) AS total_order_value
FROM restaurant_activity
WHERE total_orders >= 50
ORDER BY total_orders DESC;

-- This analysis identifies restaurants with at least 50 completed orders and summarizes their order value.
-- It helps highlight higher-activity restaurants for operational and commercial analysis.

-- ============================================================
-- PART 6.2 — RANKING ENGINE
-- ============================================================

WITH restaurant_metrics AS (SELECT restaurant_id,COUNT(*) AS completed_orders,SUM(total_amount) AS total_value
FROM fact_orders WHERE is_cancelled = 'N'GROUP BY restaurant_id)
SELECT restaurant_id,completed_orders,ROUND(total_value, 2) AS total_value,
RANK() OVER (ORDER BY completed_orders DESC) AS order_rank,
DENSE_RANK() OVER (ORDER BY total_value DESC) AS value_rank
FROM restaurant_metrics;

-- This analysis ranks restaurants by completed order volume and total order value.
-- It helps identify high-performing restaurants from both demand and commercial perspectives.

-- ============================================================
-- PART 6.3 — LAG / PERIOD COMPARISON
-- ============================================================

WITH monthly_orders AS (SELECT order_year,order_month,
MIN(order_month_name) AS month_name,
COUNT(*) AS total_orders
FROM fact_orders
GROUP BY order_year,order_month)
SELECT order_year,order_month,month_name,total_orders,
LAG(total_orders) OVER (ORDER BY order_year, order_month) AS previous_month_orders,
total_orders-LAG(total_orders) OVER (ORDER BY order_year, order_month) AS order_change
FROM monthly_orders
ORDER BY order_year,order_month;

-- This analysis compares monthly order volumes with the previous month using LAG().
-- It helps identify month-over-month changes in demand and emerging order trends.

-- ============================================================
-- PART 6.4 — RUNNING TOTAL
-- ============================================================

WITH monthly_value AS (SELECT order_year,order_month,SUM(total_amount) AS monthly_value
FROM fact_orders
WHERE is_cancelled = 'N'
GROUP BY order_year,order_month)

SELECT order_year,order_month,
ROUND(monthly_value, 2) AS monthly_value,
ROUND(SUM(monthly_value) OVER (ORDER BY order_year, order_month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),2) AS cumulative_value
FROM monthly_value

ORDER BY order_year,order_month;

-- This analysis calculates monthly order value alongside the cumulative value generated over time.
-- It helps track overall commercial growth and understand how monthly performance contributes to total value.

-- ============================================================
-- PART 6.5 — NTILE CUSTOMER VALUE SEGMENTATION
-- ============================================================

WITH customer_value AS (SELECT customer_id,COUNT(*) AS total_orders,SUM(total_amount) AS total_spend FROM fact_orders
WHERE is_cancelled = 'N'
GROUP BY customer_id),

ranked_customers AS (SELECT customer_id,total_orders,total_spend,
NTILE(20) OVER (ORDER BY total_spend DESC) AS spend_band FROM customer_value)
SELECT customer_id,total_orders,ROUND(total_spend, 2) AS total_spend,spend_band,

CASE WHEN spend_band = 1 THEN 'Top 5%'
WHEN spend_band <= 4 THEN 'Top 20%'
WHEN spend_band <= 10 THEN 'Middle 50%'
ELSE 'Bottom 50%' END AS value_band
FROM ranked_customers;

-- This analysis segments customers into value bands based on their total completed-order spend.
-- It helps distinguish high-value customers from middle- and lower-value segments for targeted decision-making.

-- ============================================================
-- PART 6.6 — SUBQUERY + CASE CLASSIFICATION
-- ============================================================

SELECT x.restaurant_id,x.total_orders,x.total_value,
CASE WHEN x.total_orders >= 1000
THEN 'Enterprise Volume'
WHEN x.total_orders >= 500 THEN 'High Volume'
WHEN x.total_orders >= 100 THEN 'Medium Volume'
ELSE 'Low Volume' END AS volume_class

FROM (SELECT restaurant_id,
COUNT(*) AS total_orders,
SUM(total_amount) AS total_value
FROM fact_orders
WHERE is_cancelled = 'N'
GROUP BY restaurant_id) x;

-- This analysis classifies restaurants into volume tiers based on completed order activity.
-- It helps distinguish high-volume restaurants and supports capacity and performance assessment.

-- ============================================================
-- PART 7.1 — CUSTOMER 360 MART
-- ============================================================

CREATE OR REPLACE VIEW mart_customer_360 AS
SELECT c.customer_id,c.city,c.acquisition_channel,c.signup_date,

COUNT(o.order_id) AS total_orders,
SUM(CASE WHEN o.is_cancelled = 'N' THEN 1 ELSE 0 END) AS completed_orders,

SUM(CASE WHEN o.is_cancelled = 'Y' THEN 1
ELSE 0 END) AS cancelled_orders,

ROUND(SUM(CASE WHEN o.is_cancelled = 'N'
THEN o.total_amount ELSE 0 END), 2) AS total_spend,

ROUND(AVG(CASE WHEN o.is_cancelled = 'N'
THEN o.total_amount END), 2) AS average_order_value,COUNT(DISTINCT o.restaurant_id) AS restaurants_used,

ROUND(AVG(x.rating), 2) AS average_rating,
ROUND(AVG(x.actual_delivery_time_mins), 2) AS average_delivery_time,

ROUND( AVG(CASE WHEN x.actual_delivery_time_mins > x.expected_delivery_time_mins 
THEN 1 ELSE 0 END), 4) AS sla_breach_rate 
FROM dim_customer c

LEFT JOIN fact_orders o ON c.customer_id = o.customer_id
LEFT JOIN (SELECT o2.order_id,MAX(r.rating) AS rating,
MAX(d.actual_delivery_time_mins) AS actual_delivery_time_mins,
MAX(d.expected_delivery_time_mins) AS expected_delivery_time_mins
FROM fact_orders o2
LEFT JOIN fact_ratings r ON o2.order_id = r.order_id
LEFT JOIN fact_delivery_performance d ON o2.order_id = d.order_id
GROUP BY o2.order_id) x ON o.order_id = x.order_id

GROUP BY c.customer_id,c.city,c.acquisition_channel,
c.signup_date;
    
-- This mart builds a 360-degree customer view by combining customer profile, order, rating, and delivery metrics.
-- It supports customer value, engagement, experience, and service-performance analysis for BI reporting.


-- ============================================================
-- PART 7.2 — RESTAURANT 360 MART
-- ============================================================

CREATE OR REPLACE VIEW mart_restaurant_360 AS

SELECT r.restaurant_id,r.restaurant_name,r.city,r.cuisine_type,r.partner_type,r.avg_prep_time_min,r.is_active,
COUNT(o.order_id) AS total_orders,
SUM(CASE WHEN o.is_cancelled = 'N' THEN 1 ELSE 0 END) AS completed_orders,
SUM(CASE WHEN o.is_cancelled = 'Y' THEN 1 ELSE 0 END) AS cancelled_orders,
ROUND(SUM(CASE WHEN o.is_cancelled = 'N'THEN o.total_amount ELSE 0 END),2) AS total_order_value,
ROUND(AVG(x.rating), 2) AS average_customer_rating,
ROUND(AVG(x.actual_delivery_time_mins),2) AS average_delivery_time,
ROUND(AVG(CASE WHEN x.actual_delivery_time_mins > x.expected_delivery_time_mins THEN 1 ELSE 0 END),4) AS sla_breach_rate
FROM dim_restaurant r

LEFT JOIN fact_orders o
ON r.restaurant_id = o.restaurant_id

LEFT JOIN (SELECT o2.order_id,rt.rating,d.actual_delivery_time_mins,d.expected_delivery_time_mins
FROM fact_orders o2

LEFT JOIN fact_ratings rt
ON o2.order_id = rt.order_id

LEFT JOIN fact_delivery_performance d
ON o2.order_id = d.order_id) x
ON o.order_id = x.order_id

GROUP BY r.restaurant_id,r.restaurant_name,r.city,r.cuisine_type,r.partner_type,r.avg_prep_time_min,r.is_active;
    
-- This mart creates a 360-degree restaurant view combining profile, order, customer rating, and delivery performance metrics.
-- It supports restaurant-level evaluation of demand, commercial performance, service quality, and operational efficiency.

-- ============================================================
-- PART 7.3 — DELIVERY PARTNER MART
-- ============================================================

CREATE OR REPLACE VIEW mart_delivery_partner_360 AS
SELECT dp.delivery_partner_id,dp.partner_name,dp.city,dp.vehicle_type,dp.employment_type,dp.avg_rating AS partner_master_rating,dp.is_active,
COUNT(o.order_id) AS assigned_orders,
ROUND(AVG(d.actual_delivery_time_mins), 2) AS average_delivery_time,
ROUND(AVG(d.expected_delivery_time_mins), 2) AS average_expected_time,
ROUND(AVG(CASE WHEN d.actual_delivery_time_mins >d.expected_delivery_time_mins
THEN 1 ELSE 0 END), 4) AS sla_breach_rate,

ROUND(AVG(d.distance_km), 2) AS average_distance
FROM dim_delivery_partner dp
LEFT JOIN fact_orders o    ON dp.delivery_partner_id = o.delivery_partner_id
LEFT JOIN (SELECT order_id,actual_delivery_time_mins,expected_delivery_time_mins,distance_km
FROM fact_delivery_performance) d ON o.order_id = d.order_id
GROUP BY dp.delivery_partner_id,dp.partner_name,dp.city,dp.vehicle_type,dp.employment_type,dp.avg_rating,dp.is_active;

-- This mart creates a 360-degree view of delivery partners using assignment, delivery, SLA, and distance metrics.
-- It supports partner-level evaluation of delivery efficiency, service reliability, and operational performance.

-- ============================================================
-- PART 8.1 — MONTHLY BI KPI VIEW
-- ============================================================

CREATE OR REPLACE VIEW vw_bi_monthly_kpi AS

SELECT order_year,order_month, 
MIN(order_month_name) AS month_name,
COUNT(*) AS total_orders,

SUM(CASE WHEN is_cancelled = 'N' THEN 1 ELSE 0 END) AS completed_orders,
SUM(CASE WHEN is_cancelled = 'Y' THEN 1 ELSE 0 END) AS cancelled_orders,
ROUND(AVG(CASE WHEN is_cancelled = 'N'THEN total_amount END), 2) AS average_order_value,
ROUND(SUM(CASE WHEN is_cancelled = 'N'THEN total_amount ELSE 0 END),2 ) AS gross_order_value,
ROUND(SUM(CASE WHEN is_cancelled = 'N'THEN discount_amount ELSE 0 END), 2) AS total_discount,
ROUND(SUM(CASE WHEN is_cancelled = 'N'THEN delivery_fee ELSE 0 END), 2) AS total_delivery_fee

FROM fact_orders

GROUP BY order_year,order_month
ORDER BY order_year,order_month;

-- This view consolidates monthly demand, order value, discounts, and delivery-fee KPIs.
-- It provides a consistent time-based reporting layer for tracking business performance and monthly trends.

-- ============================================================
-- PART 8.2 — CITY BI VIEW
-- ============================================================

CREATE OR REPLACE VIEW vw_bi_city_kpi AS

SELECT r.city,COUNT(o.order_id) AS total_orders,
SUM(CASE WHEN o.is_cancelled = 'N' THEN 1 ELSE 0 END) AS completed_orders,
SUM(CASE WHEN o.is_cancelled = 'Y' THEN 1 ELSE 0 END) AS cancelled_orders,
ROUND(SUM(CASE WHEN o.is_cancelled = 'N'THEN o.total_amount ELSE 0 END), 2) AS total_order_value,
ROUND(AVG(CASE WHEN o.is_cancelled = 'N'THEN o.total_amount END), 2) AS average_order_value,
ROUND(AVG(d.actual_delivery_time_mins), 2) AS average_delivery_time,
ROUND(AVG(CASE WHEN d.actual_delivery_time_mins > d.expected_delivery_time_mins THEN 1 ELSE 0 END), 4) AS sla_breach_rate
FROM fact_orders o
JOIN dim_restaurant r ON o.restaurant_id = r.restaurant_id
LEFT JOIN fact_delivery_performance d ON o.order_id = d.order_id
GROUP BY r.city;

-- This view provides city-level KPIs covering demand, order value, delivery performance, and SLA compliance.
-- It enables geographic comparison of business performance and operational service quality.

-- ============================================================
-- PART 8.3 — RESTAURANT BI VIEW
-- ============================================================

CREATE OR REPLACE VIEW vw_bi_restaurant_kpi AS

SELECT
restaurant_id,restaurant_name,city,cuisine_type,
partner_type,is_active,total_orders,completed_orders,
cancelled_orders,total_order_value,average_customer_rating,
average_delivery_time,sla_breach_rate

FROM mart_restaurant_360;

-- This view exposes the restaurant 360 mart as a focused BI reporting layer.
-- It provides a consistent dataset for restaurant-level performance analysis and Power BI reporting.

-- ============================================================
-- PART 8.4 — CUSTOMER BI VIEW
-- ============================================================

CREATE OR REPLACE VIEW vw_bi_customer_kpi AS

SELECT
customer_id,city,acquisition_channel,signup_date,total_orders,
completed_orders,cancelled_orders,total_spend,average_order_value,
restaurants_used,average_rating,average_delivery_time,sla_breach_rate

FROM mart_customer_360;

-- This view exposes customer-level KPIs from the Customer 360 mart for BI reporting.
-- It supports analysis of customer value, engagement, experience, and service performance.

-- ============================================================
-- PART 8.5 — DELIVERY BI VIEW
-- ============================================================

CREATE OR REPLACE VIEW vw_bi_delivery_kpi AS

SELECT 
delivery_partner_id,partner_name,city,vehicle_type,employment_type,partner_master_rating,
is_active,assigned_orders,average_delivery_time,average_expected_time,sla_breach_rate,average_distance

FROM mart_delivery_partner_360;

-- This view exposes delivery-partner KPIs from the Delivery Partner 360 mart for BI reporting.
-- It supports analysis of partner efficiency, SLA performance, delivery time, and operational coverage.

-- ============================================================
-- PART 9.1 — KPI SEMANTIC DICTIONARY
-- ============================================================

CREATE TABLE IF NOT EXISTS bi_kpi_dictionary (
kpi_id INT AUTO_INCREMENT PRIMARY KEY,
kpi_name VARCHAR(100) NOT NULL,
business_domain VARCHAR(100) NOT NULL,
definition VARCHAR(500) NOT NULL,
source_view VARCHAR(150) NOT NULL,
aggregation_rule VARCHAR(100),
refresh_priority VARCHAR(50));

-- This table defines a centralized semantic layer for key business KPIs used across the BI solution.
-- It standardizes KPI definitions, source views, aggregation logic, and reporting refresh priorities.

-- ============================================================
-- PART 9.2 — KPI DEFINITIONS
-- ============================================================

INSERT INTO bi_kpi_dictionary
(kpi_name,business_domain,definition,source_view,aggregation_rule,refresh_priority)
SELECT
'Total Orders','Demand',
'Count of order records','vw_bi_monthly_kpi',
'total_orders','Daily'

WHERE NOT EXISTS (SELECT 1 FROM bi_kpi_dictionary
WHERE kpi_name = 'Total Orders');


INSERT INTO bi_kpi_dictionary
(kpi_name,business_domain,definition,source_view,aggregation_rule,refresh_priority)
SELECT'Completed Orders','Demand',
'Orders that were not cancelled','vw_bi_monthly_kpi',
'SUM(completed_orders)','Daily'

WHERE NOT EXISTS (SELECT 1 FROM bi_kpi_dictionary
WHERE kpi_name = 'Completed Orders');


INSERT INTO bi_kpi_dictionary
(kpi_name,business_domain,definition,source_view,aggregation_rule,refresh_priority)
SELECT'Cancellation Rate','Operations',
'Cancelled orders divided by total orders','vw_bi_monthly_kpi',
'Cancelled / Total','Daily'

WHERE NOT EXISTS (SELECT 1 FROM bi_kpi_dictionary
WHERE kpi_name = 'Cancellation Rate');

INSERT INTO bi_kpi_dictionary
(kpi_name,business_domain,definition,source_view,aggregation_rule,refresh_priority)
SELECT
'Average Order Value','Commercial',
'Average monetary value per order','vw_bi_monthly_kpi',
'average_order_value','Daily'
WHERE NOT EXISTS (SELECT 1 FROM bi_kpi_dictionary
WHERE kpi_name = 'Average Order Value');


INSERT INTO bi_kpi_dictionary
(kpi_name,business_domain,definition,source_view,aggregation_rule,refresh_priority)

SELECT
'Average Delivery Time','Delivery','Average actual delivery time in minutes',
'vw_bi_delivery_kpi','average_delivery_time','Daily'
WHERE NOT EXISTS (SELECT 1 FROM bi_kpi_dictionary
WHERE kpi_name = 'Average Delivery Time');


INSERT INTO bi_kpi_dictionary
(kpi_name,business_domain,definition,source_view,aggregation_rule,refresh_priority)

SELECT'SLA Breach Rate','Delivery','Share of deliveries exceeding expected delivery time','vw_bi_delivery_kpi','sla_breach_rate','Daily'
WHERE NOT EXISTS (SELECT 1 FROM bi_kpi_dictionary
WHERE kpi_name = 'SLA Breach Rate');


INSERT INTO bi_kpi_dictionary
(kpi_name,business_domain,definition,source_view,aggregation_rule,refresh_priority)

SELECT
'Average Customer Rating','Customer Experience',
'Average recorded customer rating','vw_bi_customer_kpi',
'average_rating','Daily'
WHERE NOT EXISTS (SELECT 1 FROM bi_kpi_dictionary
WHERE kpi_name = 'Average Customer Rating');

-- This section populates the KPI dictionary with standardized business definitions and reporting logic.
-- It establishes consistent KPI interpretation across demand, commercial, delivery, and customer-experience reporting.

-- ============================================================
-- PART 9.3 — POWER BI KPI SNAPSHOT
-- ============================================================

CREATE OR REPLACE VIEW vw_bi_kpi_snapshot AS
SELECT'Total Orders' AS kpi_name,CAST(COUNT(*) AS DECIMAL(18,2)) AS kpi_value FROM fact_orders

UNION ALL
SELECT 'Completed Orders',CAST(SUM(CASE WHEN is_cancelled = 'N' THEN 1 ELSE 0 END) AS DECIMAL(18,2))FROM fact_orders

UNION ALL
SELECT'Cancelled Orders',CAST(SUM(CASE WHEN is_cancelled = 'Y' THEN 1 ELSE 0 END) AS DECIMAL(18,2))FROM fact_orders

UNION ALL

SELECT'Active Customers',CAST(COUNT(*) AS DECIMAL(18,2))
FROM (SELECT DISTINCT customer_id FROM fact_orders WHERE is_cancelled = 'N'AND customer_id IS NOT NULL) AS active_customers

UNION ALL
SELECT'Restaurant Count',CAST(COUNT(*) AS DECIMAL(18,2))FROM dim_restaurant

UNION ALL
SELECT'Delivery Records',CAST(COUNT(*) AS DECIMAL(18,2))FROM fact_delivery_performance

UNION ALL
SELECT'Rating Records',CAST(COUNT(*) AS DECIMAL(18,2))FROM fact_ratings;

-- This view creates a compact KPI snapshot for Power BI and executive-level reporting.
-- It provides a consistent set of headline metrics covering orders, customers, restaurants, delivery, and ratings.

-- ============================================================
-- PART 10.1 — INDEX INVENTORY
-- ============================================================

SELECT TABLE_NAME,INDEX_NAME,
COLUMN_NAME,SEQ_IN_INDEX,NON_UNIQUE
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = DATABASE()
ORDER BY
TABLE_NAME,INDEX_NAME,SEQ_IN_INDEX;

-- This query provides a complete inventory of indexes across the QuickBite BI database.
-- It establishes the baseline for reviewing and validating indexing used for query performance.

-- ============================================================
-- PART 10.2 — PERFORMANCE INDEXING
-- ============================================================

-- ------------------------------------------------------------
-- Source tables were imported with TEXT-based business keys.
-- Prefix indexes are therefore used without altering source data.
-- ------------------------------------------------------------


CREATE INDEX idx_orders_customer
ON fact_orders(customer_id(32));

CREATE INDEX idx_orders_restaurant
ON fact_orders(restaurant_id(32));

CREATE INDEX idx_orders_delivery_partner
ON fact_orders(delivery_partner_id(32));

CREATE INDEX idx_orders_phase
ON fact_orders(business_phase(32));

CREATE INDEX idx_orders_timestamp
ON fact_orders(order_timestamp(19));

CREATE INDEX idx_order_items_order
ON fact_order_items(order_id(32));

CREATE INDEX idx_order_items_menu
ON fact_order_items(menu_item_id(32));

CREATE INDEX idx_order_items_restaurant
ON fact_order_items(restaurant_id(32));

CREATE INDEX idx_delivery_order
ON fact_delivery_performance(order_id(32));

CREATE INDEX idx_ratings_order
ON fact_ratings(order_id(32));

CREATE INDEX idx_ratings_customer
ON fact_ratings(customer_id(32));

CREATE INDEX idx_ratings_restaurant
ON fact_ratings(restaurant_id(32));

SELECT TABLE_NAME, INDEX_NAME,COLUMN_NAME,
SUB_PART AS indexed_prefix_length,SEQ_IN_INDEX,NON_UNIQUE
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = DATABASE()
AND INDEX_NAME LIKE 'idx_%'
ORDER BY TABLE_NAME,INDEX_NAME,SEQ_IN_INDEX;

-- This section adds targeted indexes to improve filtering and join performance across core fact tables.
-- Prefix indexing is used to optimize the TEXT-based business keys without changing the source data structure.

-- ============================================================
-- PART 10.3 — QUERY OPTIMIZATION & EXECUTION PLAN
-- ============================================================

-- ------------------------------------------------------------
-- INDEX INVENTORY AFTER OPTIMIZATION
-- ------------------------------------------------------------

SELECT
TABLE_NAME,
INDEX_NAME,
COLUMN_NAME,
SUB_PART AS indexed_prefix_length,SEQ_IN_INDEX,NON_UNIQUE
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = DATABASE()
AND INDEX_NAME LIKE 'idx_%'
ORDER BY TABLE_NAME,INDEX_NAME,SEQ_IN_INDEX;

-- This query verifies the indexes created during the optimization stage.
-- It confirms the indexed columns and prefix lengths before reviewing execution plans.

-- ------------------------------------------------------------
-- QUERY 1 — MULTI-TABLE JOIN EXECUTION PLAN
-- ------------------------------------------------------------

EXPLAIN
SELECT o.order_id,c.city,r.restaurant_name,o.total_amount
FROM fact_orders o
JOIN dim_customer c
ON o.customer_id = c.customer_id
JOIN dim_restaurant r
ON o.restaurant_id = r.restaurant_id
WHERE o.business_phase = 'Crisis';

-- This execution plan evaluates how MySQL processes a multi-table join filtered by the crisis business phase.
-- It helps assess whether the available indexes support efficient joins and filtering.

-- ------------------------------------------------------------
-- QUERY 2 — ORDER-ITEM DIMENSION JOIN
-- ------------------------------------------------------------

EXPLAIN
SELECT oi.order_id,oi.menu_item_id,oi.quantity,oi.line_total,m.item_name,m.category
FROM fact_order_items oi
JOIN dim_menu_item m
ON oi.menu_item_id = m.menu_item_id
WHERE oi.quantity > 1;

-- This execution plan evaluates the join between order-item transactions and menu-item attributes.
-- It helps assess how efficiently MySQL filters item quantities and resolves the dimension join.

-- ------------------------------------------------------------
-- QUERY 3 — TIME-FILTERED CUSTOMER AGGREGATION
-- ------------------------------------------------------------

EXPLAIN
SELECT o.customer_id,COUNT(*) AS order_count,SUM(o.total_amount) AS total_value
FROM fact_orders o
WHERE o.order_timestamp >= '2025-06-01'
AND o.order_timestamp < '2025-10-01'
GROUP BY o.customer_id;

-- This execution plan evaluates time-based filtering and customer-level aggregation on order data.
-- It helps assess whether the timestamp index can efficiently support the crisis-period analysis.

-- ============================================================
-- FINAL SQL VALIDATION
-- ============================================================

-- ============================================================
-- PART 10.4 — VIEW INVENTORY
-- ============================================================

SELECT
    TABLE_NAME,
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_TYPE = 'VIEW'
ORDER BY TABLE_NAME;

-- This validation confirms that all required BI and analytical views have been created successfully.
-- It provides a final inventory of the reporting layer before downstream Power BI consumption.

-- ============================================================
-- PART 10.5 — FINAL ROW-LEVEL VALIDATION
-- ============================================================

SELECT'mart_customer_360' AS mart_name,COUNT(*) AS mart_rows FROM mart_customer_360

UNION ALL
SELECT'mart_restaurant_360',COUNT(*)FROM mart_restaurant_360

UNION ALL
SELECT'mart_delivery_partner_360',COUNT(*)FROM mart_delivery_partner_360;

-- This validation checks the row counts of the core 360-degree analytical marts.
-- It confirms that the customer, restaurant, and delivery partner reporting layers are populated correctly.

-- ============================================================
-- PART 10.6— FINAL DATE COVERAGE
-- ============================================================

SELECT
    MIN(order_timestamp) AS first_order_timestamp,
    MAX(order_timestamp) AS last_order_timestamp,
    COUNT(DISTINCT DATE(order_timestamp)) AS active_order_dates,
    COUNT(DISTINCT order_year) AS order_years
FROM fact_orders;

-- This validation confirms the overall time coverage of the order dataset.
-- It verifies the available reporting period, active order dates, and number of years represented.

-- ============================================================
-- PART 10.7 — FINAL BUSINESS PHASE CONTROL
-- ============================================================

SELECT
    business_phase,
    COUNT(*) AS order_count,
    MIN(order_timestamp) AS phase_start,
    MAX(order_timestamp) AS phase_end
FROM fact_orders
GROUP BY business_phase
ORDER BY phase_start;

-- This validation summarizes order activity across each business phase and its corresponding time period.
-- It helps confirm phase coverage and supports consistent interpretation of the operational timeline.

-- ============================================================
-- PART 10.8 — FINAL REFERENTIAL INTEGRITY CHECK
-- ============================================================

SELECT'orders → customer' AS relationship,COUNT(*) AS orphan_records
FROM fact_orders o
LEFT JOIN dim_customer c
ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL

UNION ALL

SELECT'orders → restaurant',COUNT(*)
FROM fact_orders o
LEFT JOIN dim_restaurant r
ON o.restaurant_id = r.restaurant_id
WHERE r.restaurant_id IS NULL

UNION ALL

SELECT'orders → delivery partner',COUNT(*)
FROM fact_orders o
LEFT JOIN dim_delivery_partner dp
ON o.delivery_partner_id = dp.delivery_partner_id
WHERE NULLIF(TRIM(o.delivery_partner_id), '') IS NOT NULL
AND dp.delivery_partner_id IS NULL

UNION ALL

SELECT'order items → orders',COUNT(*)
FROM fact_order_items oi
LEFT JOIN fact_orders o
ON oi.order_id = o.order_id
WHERE o.order_id IS NULL

UNION ALL

SELECT'order items → menu item',COUNT(*)
FROM fact_order_items oi
LEFT JOIN dim_menu_item m
ON oi.menu_item_id = m.menu_item_id
WHERE m.menu_item_id IS NULL

UNION ALL

SELECT'delivery → orders',COUNT(*)
FROM fact_delivery_performance d
LEFT JOIN fact_orders o
ON d.order_id = o.order_id
WHERE o.order_id IS NULL

UNION ALL

SELECT'ratings → orders',COUNT(*)
FROM fact_ratings r
LEFT JOIN fact_orders o
ON r.order_id = o.order_id
WHERE o.order_id IS NULL;

-- This final check revalidates key relationships between transactional and master tables.
-- It confirms that no orphan records remain before the SQL layer is considered ready for reporting.