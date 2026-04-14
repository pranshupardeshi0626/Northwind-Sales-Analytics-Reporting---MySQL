-- 1) CTE: Revenue by year and month
WITH monthly_revenue AS (
    SELECT
        YEAR(o.order_date) AS order_year,
        MONTH(o.order_date) AS order_month,
        ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2) AS revenue
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY YEAR(o.order_date), MONTH(o.order_date)
)
SELECT *
FROM monthly_revenue
ORDER BY order_year, order_month;

-- 2) Window function: rank products by revenue
SELECT
    p.product_id,
    p.product_name,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2) AS revenue,
    DENSE_RANK() OVER (
        ORDER BY SUM(od.unit_price * od.quantity * (1 - od.discount)) DESC
    ) AS revenue_rank
FROM products p
JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name
ORDER BY revenue_rank, p.product_name;

-- 3) View: reusable customer revenue report
CREATE OR REPLACE VIEW vw_customer_revenue AS
SELECT
    c.customer_id,
    c.company_name,
    c.country,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2) AS total_revenue,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
GROUP BY c.customer_id, c.company_name, c.country;

-- Example query on view
SELECT *
FROM vw_customer_revenue
ORDER BY total_revenue DESC
LIMIT 15;

-- 4) View: reusable product performance report
CREATE OR REPLACE VIEW vw_product_performance AS
SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2) AS total_revenue,
    SUM(od.quantity) AS total_units_sold
FROM products p
JOIN categories c ON p.category_id = c.category_id
JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name, c.category_name;

-- Quick top-product output.
SELECT *
FROM vw_product_performance
ORDER BY total_revenue DESC
LIMIT 15;

-- 5) Stored procedure: top N customers by revenue
DROP PROCEDURE IF EXISTS sp_top_customers;
DELIMITER //
CREATE PROCEDURE sp_top_customers(IN p_limit INT)
BEGIN
    SELECT
        customer_id,
        company_name,
        country,
        total_revenue,
        total_orders
    FROM vw_customer_revenue
    ORDER BY total_revenue DESC
    LIMIT p_limit;
END //
DELIMITER ;

-- Example procedure call
CALL sp_top_customers(10);

