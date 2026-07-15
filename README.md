# Fintech-Banking-SQL-Analytics
Advanced SQL analysis for banking data. Key features: Fraud detection, LTV calculation, and User behavior analytics using Window Functions &amp; CTEs.


# Fintech Data Analytics Portfolio

## Project Overview
This repository demonstrates a production-grade SQL analytical environment for a digital banking platform. It covers the full data lifecycle: from **relational schema design** to **complex business logic implementation** and **fraud detection patterns**.

## Tech Stack
- **Engine:** Oracle SQL / PostgreSQL
- **Key Techniques:** - **Window Functions:** `LAG()`, `LEAD()`, `RANK()`, `SUM() OVER()`
  - **Modular Code:** Common Table Expressions (CTEs)
  - **Performance:** Relational integrity (PK/FK) and aggregation strategies

## Business Case Studies

### Fraud & Security Analysis
Implemented a velocity-check pattern using `LAG()` to identify rapid-fire transactions. This query calculates the precise time gap between consecutive events to flag potential automated attacks.

### Customer Lifetime Value (LTV) & Ranking
Developed a multi-stage ranking system using **CTEs** and `DENSE_RANK()`. This allows stakeholders to identify top-tier customers (VIPs) within specific geographic regions based on total transaction volume.

### Financial Flow Monitoring
Built a **Rolling Balance** feature using `SUM() OVER`, enabling real-time tracking of user wallet states without expensive full-table re-scans.

## 📂 Project Structure
- `SQL_banking_analytics_queries.sql`: Single source of truth containing DDL, DML, and analytical queries.

---
Jakub D 
