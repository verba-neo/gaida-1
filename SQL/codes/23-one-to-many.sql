-- 23-one-to-many.sql
USE lecture;

SELECT
  c.customer_id,
  c.customer_name,
  COUNT(s.id) AS 주문횟수,
  GROUP_CONCAT(s.product_name) AS 주문제품들 
FROM customers c
LEFT JOIN sales s ON c.customer_id=s.customer_id
GROUP BY c.customer_id, c.customer_name;