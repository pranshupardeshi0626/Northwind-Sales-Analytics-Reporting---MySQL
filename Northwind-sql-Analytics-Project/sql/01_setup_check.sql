SELECT DATABASE() AS active_database;

SHOW TABLES;

-- Fast row-volume profile across core transactional and master tables.
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_details', COUNT(*) FROM order_details
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'employees', COUNT(*) FROM employees
UNION ALL
SELECT 'suppliers', COUNT(*) FROM suppliers
UNION ALL
SELECT 'shippers', COUNT(*) FROM shippers;

SELECT * FROM customers LIMIT 5;
SELECT * FROM orders LIMIT 5;
SELECT * FROM order_details LIMIT 5;

