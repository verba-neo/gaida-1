-- 28-any-all.sql
-- ANY - 여러 값들 중에 하나라도 조건을 만족하면 TRUE (OR)

-- 1. VIP 고객들의 최소 주문액 보다 높은 모든 주문

SELECT s.total_amount
  FROM sales s
  INNER JOIN customers c on s.customer_id = c.customer_id
  WHERE c.customer_type = 'VIP';


SELECT
  customer_id,
  product_name,
  total_amount,
  '일반 고객이지만 VIP 최소보다 높음' AS 구분
FROM sales
WHERE total_amount > ANY(  -- a, b, c, d, e
 -- VIP 들의 모든 주문 금액들 (Vector)
  SELECT s.total_amount
  FROM sales s
  INNER JOIN customers c on s.customer_id = c.customer_id
  WHERE c.customer_type = 'VIP'
) AND
customer_id NOT IN (SELECT customer_id FROM customers WHERE customer_type = 'VIP')
ORDER BY total_amount DESC;
-- 위의 코드는 아래와 같음
SELECT
  customer_id,
  product_name,
  total_amount,
  '일반 고객이지만 VIP 최소보다 높음' AS 구분
FROM sales
WHERE total_amount > (
  SELECT MIN(s.total_amount) FROM sales s
  INNER JOIN customers c on s.customer_id = c.customer_id
  WHERE c.customer_type = 'VIP'
) AND
customer_id NOT IN (SELECT customer_id FROM customers WHERE customer_type = 'VIP')
ORDER BY total_amount DESC;

-- 어떤 지역 평균 매출액보다라도 높은 주문들.



