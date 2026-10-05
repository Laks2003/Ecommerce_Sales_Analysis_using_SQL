SELECT * FROM customers;
SELECT * FROM geolocation;
SELECT * FROM order_items;
SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM payments;
SELECT * FROM product_category_translation;

-- Find total revenue, customer count, and average payment per state for delivered orders.

SELECT 
    c.customer_state,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    SUM(p.payment_value) AS total_revenue,
    AVG(p.payment_value) AS avg_payment_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY total_revenue DESC;


-- Top 10 States by Total Revenue & Customer Count

SELECT 
    c.customer_state,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(o.order_id) AS total_orders,
    SUM(p.payment_value) AS total_revenue,
    AVG(p.payment_value) AS avg_payment_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY total_revenue DESC;

-- Finds products that have never been ordered

SELECT TOP 20
    p.product_id,
    p.product_category_name
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- Customer Order History with Payments

SELECT TOP 15
    c.customer_id,
    c.customer_city,
    c.customer_state,
    o.order_id,
    o.order_status,
    p.payment_type,
    p.payment_value
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN payments p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
ORDER BY p.payment_value DESC;


-- Analyzing top product categories in English along with total items sold and sales amount.

SELECT TOP 10
    ISNULL(t.product_category_name_english, p.product_category_name) AS english_category,
    COUNT(oi.order_item_id) AS total_items_sold,
    SUM(oi.price) AS total_sales_amount
FROM products p
LEFT JOIN product_category_translation t ON p.product_category_name = t.product_category_name
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY ISNULL(t.product_category_name_english, p.product_category_name)
ORDER BY total_sales_amount DESC;

-- Individual payments that are higher than the overall average payment value.

SELECT order_id, payment_type, payment_value
FROM payments
WHERE payment_value > (
    SELECT AVG(payment_value) 
    FROM payments
)
ORDER BY payment_value DESC;

-- Create a view that summarizes monthly order volume and revenue trends.

IF OBJECT_ID('v_monthly_sales_summary', 'V') IS NOT NULL
    DROP VIEW v_monthly_sales_summary;
GO

CREATE VIEW v_monthly_sales_summary AS
SELECT 
    LEFT(o.order_purchase_timestamp, 7) AS order_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    SUM(p.payment_value) AS monthly_revenue,
    AVG(p.payment_value) AS average_order_value
FROM orders o
JOIN payments p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY LEFT(o.order_purchase_timestamp, 7);
GO

SELECT * FROM v_monthly_sales_summary ORDER BY order_month;

-- Create non-clustered indexes on high-frequency columns used in joins and filtering

ALTER TABLE orders ALTER COLUMN customer_id VARCHAR(50) NOT NULL;
ALTER TABLE orders ALTER COLUMN order_status VARCHAR(50) NOT NULL;
ALTER TABLE payments ALTER COLUMN order_id VARCHAR(50) NOT NULL;
ALTER TABLE order_items ALTER COLUMN product_id VARCHAR(50) NOT NULL;
GO

CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_status ON orders(order_status);
CREATE INDEX idx_payments_order_id ON payments(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
GO