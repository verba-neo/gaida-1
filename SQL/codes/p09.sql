-- p09.sql
USE practice;

SELECT COUNT(*) FROM sales
UNION
SELECT COUNT(*) FROM customers;

