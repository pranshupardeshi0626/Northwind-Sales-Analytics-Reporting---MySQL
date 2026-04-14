-- 1) Customer and order count

SELECT
    c.customer_id,
    c.company_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.company_name
ORDER BY total_orders DESC;

-- 2) Total sales by product
-- net sales = unit_price * quantity * (1 - discount).
SELECT
    p.product_id,
    p.product_name,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2) AS total_sales
FROM products p
JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_sales DESC;

-- 3) Orders handled by each employee
SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    COUNT(o.order_id) AS handled_orders
FROM employees e
LEFT JOIN orders o ON e.employee_id = o.employee_id
GROUP BY e.employee_id, employee_name
ORDER BY handled_orders DESC;

-- 4) Number of products per category
SELECT
    c.category_id,
    c.category_name,
    COUNT(p.product_id) AS products_in_category
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_id, c.category_name
ORDER BY products_in_category DESC;

-- 5) Top 10 most expensive products
SELECT
    product_id,
    product_name,
    unit_price
FROM products
ORDER BY unit_price DESC
LIMIT 10;

-- 6) Customers from USA or UK
SELECT
    customer_id,
    company_name,
    country
FROM customers
WHERE country IN ('USA', 'UK')
ORDER BY country, company_name;

-- 7) Monthly order volume
-- Tracks operational trend over time by month.
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS order_month,
    COUNT(*) AS order_count
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY order_month;

-- 8) Suppliers and their supplied product count
SELECT
    s.supplier_id,
    s.company_name AS supplier_name,
    COUNT(p.product_id) AS supplied_products
FROM suppliers s
LEFT JOIN products p ON s.supplier_id = p.supplier_id
GROUP BY s.supplier_id, s.company_name
ORDER BY supplied_products DESC, supplier_name;

