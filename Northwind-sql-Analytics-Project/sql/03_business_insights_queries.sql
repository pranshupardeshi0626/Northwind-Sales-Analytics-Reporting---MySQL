-- 1) Monthly revenue trend
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS revenue_month,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2) AS monthly_revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY revenue_month;

-- 2) Top 10 customers by lifetime revenue
SELECT
    c.customer_id,
    c.company_name,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2) AS lifetime_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
GROUP BY c.customer_id, c.company_name
ORDER BY lifetime_revenue DESC
LIMIT 10;

-- 3) Top products by revenue contribution
SELECT
    p.product_id,
    p.product_name,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2) AS product_revenue
FROM products p
JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name
ORDER BY product_revenue DESC
LIMIT 10;

-- 4) Employee performance by generated revenue
SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2) AS generated_revenue
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
JOIN order_details od ON o.order_id = od.order_id
GROUP BY e.employee_id, employee_name
ORDER BY generated_revenue DESC;

-- 5) Shipping company usage and freight totals
SELECT
    s.shipper_id,
    s.company_name AS shipper_name,
    COUNT(o.order_id) AS shipped_orders,
    ROUND(SUM(o.freight), 2) AS total_freight
FROM shippers s
LEFT JOIN orders o ON s.shipper_id = o.ship_via
GROUP BY s.shipper_id, s.company_name
ORDER BY shipped_orders DESC;

-- 6) Average processing days (order date to shipped date) by shipper
SELECT
    s.company_name AS shipper_name,
    ROUND(AVG(DATEDIFF(o.shipped_date, o.order_date)), 2) AS avg_processing_days
FROM shippers s
JOIN orders o ON s.shipper_id = o.ship_via
WHERE o.shipped_date IS NOT NULL
GROUP BY s.company_name
ORDER BY avg_processing_days;

-- 7) Countries with highest revenue
SELECT
    o.ship_country AS country,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2) AS revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.ship_country
ORDER BY revenue DESC;

-- 8) Customers with no orders (retention opportunity)
SELECT
    c.customer_id,
    c.company_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL
ORDER BY c.company_name;

