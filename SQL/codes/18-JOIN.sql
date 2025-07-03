-- 18-JOIN.sql
-- 고객정보 + 주문정보
USE lecture;

SELECT
  *,
  (
    SELECT customer_name FROM customers c
    WHERE c.customer_id=s.customer_id
  ) AS 주문고객이름,
  (
    SELECT customer_type FROM customers c
    WHERE c.customer_id=s.customer_id
  ) AS 고객등급
FROM sales s;

-- JOIN
SELECT
  c.customer_name,
  c.customer_type
FROM customers c
INNER JOIN sales s ON c.customer_id = s.customer_id
where s.total_amount >= 500000
ORDER BY s.total_amount DESC;



  