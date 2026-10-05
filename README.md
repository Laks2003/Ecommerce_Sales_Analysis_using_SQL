## 📌 Objective
The objective of this task is to use SQL queries to extract, manipulate, and analyze structured data from a relational e-commerce database (`Olist Ecommerce Dataset`) using Microsoft SQL Server (T-SQL)[cite: 1].

---

## 🛠️ Tools & Environment
* **Database Management System:** Microsoft SQL Server (SSMS)
* **Dataset:** Olist Brazilian E-Commerce Public Dataset
* **Language:** T-SQL

---

## 📂 Database Schema Overview
The analysis utilizes the following core tables:
1. **`customers`**: Customer demographic data (ID, city, state).
2. **`orders`**: Order transaction records, status, and timestamps.
3. **`order_items`**: Line items per order, listing products, sellers, and prices.
4. **`products`**: Product catalog details and category names.
5. **`payments`**: Payment types, installments, and payment values.
6. **`product_category_translation`**: English translations for product categories.

---

## 📝 SQL Queries & Analysis Implemented

### 1. Basic Filtering, Grouping & Aggregation (`SELECT`, `WHERE`, `GROUP BY`, `ORDER BY`, `SUM`, `AVG`, `COUNT`)
* **State-Level Revenue & Customer Analysis**: Aggregates total customers, total orders, total revenue, and average payment values grouped by customer state for successfully delivered orders.
* **Order Status Breakdown**: Evaluates order volume, average payment, and total revenue across different order statuses.

### 2. Table Joins (`LEFT JOIN`, `INNER JOIN`)
* **Unordered Products**: Uses a `LEFT JOIN` to identify products in the catalog that have never been ordered.
* **Category Performance in English**: Combines product categories, translations, and order items using `LEFT JOIN` and `INNER JOIN` to find the top revenue-generating product categories.
* **Customer Order & Payment History**: Connects customers, orders, and payments to retrieve high-value transaction histories.

### 3. Subqueries
* **Above-Average Payments**: Uses a nested subquery to isolate individual high-value payments that exceed the overall average payment value across the platform.

### 4. Views for Analysis
* **Monthly Sales Summary View (`v_monthly_sales_summary`)**: Creates a reusable virtual view summarizing monthly order volumes, unique customer counts, monthly revenue, and average order values.

### 5. Query Optimization (`CREATE INDEX`)
* **Performance Tuning**: Implements non-clustered indexes on high-frequency columns (`customer_id`, `order_status`, `order_id`, `product_id`) to optimize join and filtering performance.

---
