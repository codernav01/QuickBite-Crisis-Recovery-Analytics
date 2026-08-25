# QuickBite Express — Crisis Recovery & Business Intelligence Analytics

## 📌 Project Overview

**QuickBite Express — Crisis Recovery & Business Intelligence Analytics** is an end-to-end **Data Analytics & Business Intelligence project** focused on analyzing the impact of a major business crisis on a food-delivery platform.

The project analyzes QuickBite's business performance across **January–September 2025**, using **January–May 2025 as the Pre-Crisis baseline** and **June–September 2025 as the Crisis period**.

The analysis transforms raw customer, restaurant, order, delivery, and rating data into **validated, analysis-ready datasets**, performs exploratory and business analysis using **Python**, and develops a structured **SQL analytics layer** for deeper analysis and reporting.

The core focus is on understanding **demand decline, operational deterioration, customer experience, restaurant partner performance, customer value risk, and recovery priorities**.

---

## 🎯 Project Objectives

The project aims to:

- Analyze the overall business impact of the June 2025 crisis
- Compare Pre-Crisis and Crisis performance across key business metrics
- Identify changes in customer demand and ordering behavior
- Analyze city-level and restaurant-level order decline
- Evaluate delivery performance, cancellations, and SLA compliance
- Analyze customer ratings and review-based feedback
- Identify high-value and loyal customers at risk
- Analyze restaurant partner performance and recovery priorities
- Build a reusable SQL analytics layer for business reporting
- Convert analytical findings into actionable recovery recommendations

---

## 📂 Datasets Used

The project uses **8 relational datasets** covering the major components of the QuickBite business ecosystem.

| Dataset | Description |
|---|---|
| **dim_customer.csv** | Customer master and profile information |
| **dim_delivery_partner_.csv** | Delivery partner information |
| **dim_menu_item.csv** | Menu item and restaurant-level product information |
| **dim_restaurant.csv** | Restaurant and partner information |
| **fact_orders.csv** | Customer order transactions and order-value data |
| **fact_order_items.csv** | Order-level item and basket information |
| **fact_delivery_performance.csv** | Delivery time, delay, SLA and delivery performance |
| **fact_ratings.csv** | Customer ratings, reviews and feedback |

## 🛠️ Technology Stack

| Category | Tools |
|---|---|
| **Programming Language** | Python |
| **Data Analysis** | Pandas, NumPy |
| **Data Visualization** | Matplotlib, Seaborn |
| **Database / Analytics** | MySQL / SQL |
| **Business Intelligence** | Power BI |
| **Development Environment** | Jupyter Notebook |
| **Version Control** | Git, GitHub |
| **Data Formats** | CSV, Excel |

---

## ⚙️ Project Workflow

The project follows a structured end-to-end analytics pipeline:

```text
Raw Business Data
        ↓
Data Loading & Inspection
        ↓
Python Data Cleaning & Validation
        ↓
Data Quality & Integrity Checks
        ↓
Feature Engineering
        ↓
Exploratory Data Analysis
        ↓
Business Question Analysis
        ↓
MySQL Database & Validation
        ↓
SQL Analytics Layer
        ↓
Power BI / Executive Reporting
        ↓
Business Insights & Recovery Recommendations
```
## 📊 Key Findings

The analysis identified a broad-based deterioration across multiple areas of the business:

- **Orders declined by 69.78%**
- **Order value declined by 70.92%**
- **Active customers declined by 63.56%**
- **Average delivery time increased by 52.09%**
- **SLA breach rate increased by 31.33 percentage points**
- **Average customer rating declined by 43.77%**
- **Cancellation rate increased from 3.40% to 6.87%**
- **99.24% of identified high-value customers showed declining activity**

These findings indicate that the crisis was **not simply a demand problem**. The deterioration extended across **operations, customer experience, customer value, and marketplace performance**.

---

## 📈 Business Impact

The analysis highlights four interconnected areas of business deterioration:

### 📉 Demand

A substantial decline in orders and active customers indicates a significant reduction in marketplace activity during the crisis period.

### 🚚 Operations

Higher delivery times, increased SLA breaches, and rising cancellations indicate deterioration in operational reliability.

### ⭐ Customer Experience

The decline in average customer ratings and negative review patterns indicate a significant deterioration in customer experience.

### 💰 Customer & Commercial Value

Declining order value and reduced activity among high-value customers create a significant retention and revenue-recovery risk.

---

## 🎯 Recovery Priorities

Based on the analytical findings, the project identifies four major recovery priorities:

### 01 — Stabilize

Improve operational reliability by addressing delivery delays, SLA breaches, and cancellations.

### 02 — Protect

Prioritize retention of high-value and historically loyal customers showing declining activity.

### 03 — Recover

Identify high-impact restaurants and cities requiring focused recovery interventions.

### 04 — Rebuild Trust

Use customer ratings and review feedback to identify recurring experience problems and improve service reliability.

---

## 📊 Key Outputs

- Cleaned and analysis-ready datasets
- Python-based exploratory and business analysis
- Data quality and integrity validation
- Validated MySQL analytical database
- Reusable SQL analytics queries
- Customer, restaurant, and operational analysis
- Pre-Crisis vs Crisis comparison
- City-level demand analysis
- Restaurant partner performance analysis
- Delivery and SLA performance analysis
- Customer ratings and feedback analysis
- High-value customer risk analysis
- Power BI / executive reporting outputs
- Business insights and recovery recommendations

---

## 🗄️ SQL Analytics Layer

The project includes a structured SQL analytics layer designed for reusable business reporting and analysis.

The SQL analysis covers:

- Pre-Crisis vs Crisis comparisons
- Monthly order trends
- City-level performance
- Restaurant-level performance
- Customer activity analysis
- High-value customer identification
- Delivery performance
- SLA breach analysis
- Cancellation analysis
- Customer rating analysis
- Revenue / order-value analysis
- Business recovery prioritization

Advanced SQL techniques are used where appropriate, including:

- **CTEs**
- **Subqueries**
- **Aggregations**
- **CASE statements**
- **Window Functions**
- **Joins**
- **Date-based analysis**

---

The objective is not simply to display KPIs, but to connect operational metrics with **business decisions and recovery actions**.
## 🎯 Project Outcome

The project demonstrates an end-to-end **Data Analytics & Business Intelligence workflow**:

**Raw Business Data → Python → SQL → Power BI → Business Insights → Recovery Strategy**

It transforms raw QuickBite operational data into **validated, evidence-based insights** covering:

- Demand
- Customers
- Restaurants
- Delivery operations
- Customer experience
- Commercial performance
- Recovery priorities

The project demonstrates how analytics can move beyond descriptive dashboards and support **structured business diagnosis and decision-making** during a crisis.

---

## 🔄 End-to-End Analytics Architecture

```text
             RAW BUSINESS DATA
                     │
                     ▼
          DATA CLEANING & VALIDATION
                  (Python)
                     │
                     ▼
          ANALYSIS-READY DATASETS
                     │
          ┌──────────┴──────────┐
          ▼                     ▼
    EXPLORATORY ANALYSIS    MYSQL DATABASE
       (Python)                  │
          │                      ▼
          │              SQL ANALYTICS LAYER
          │                      │
          └──────────┬───────────┘
                     ▼
              POWER BI REPORTING
                     │
                     ▼
             BUSINESS INSIGHTS
                     │
                     ▼
          RECOVERY RECOMMENDATIONS
`menu_item_id`

These relationships allow customer, restaurant, order, delivery, and feedback data to be analyzed together.
```
## If you found this project useful, consider starring the repository.⭐
---
