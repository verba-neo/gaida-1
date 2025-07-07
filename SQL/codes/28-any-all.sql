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
WHERE total_amount > ANY(
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
SELECT
  region,
  product_name,
  total_amount
FROM sales s
WHERE total_amount > ANY(  -- 2. 보다 하나라도 더 크면 만족
  -- 1. 각 지역별 평균 매출액들  
  SELECT AVG(total_amount)
  FROM sales
  GROUP BY region
)
ORDER BY total_amount DESC;

-- ALL 벡터의 모든 값들이 조건을 만족해야 통과
-- 모든 부서의 평균연봉보다 더 높은 연봉을 받는 사람 (예시 - 실행 안됨)
SELECT * 
FROM employees
-- 서브쿼리 벡터의 모든 값보다 커야함.
WHERE salary > ALL(
    -- 각 부서의 평균 연봉 Vector
    SELECT AVG(salary)
    FROM employees
    GROUP BY department_id
);


