-- pg-06-cte.sql

-- CTE (Common Table Expression) -> 쿼리 속의 '이름이 있는' 임시 테이블
-- 가독성: 복잡한 쿼리를 단계별로 나누어 이해하기 쉬움
-- 재사용: 한 번 정의한 결과를 여러 번 사용 가능
-- 유지보수: 각 단계별로 수정이 용이
-- 디버깅: 단계별로 결과를 확인할 수 있음

-- [평균 주문 금액] 보다 큰 주문들의 고객 정보

SELECT c.customer_name, o.amount
FROM customers c
INNER JOIN orders o ON c.customer_id=o.customer_id
WHERE o.amount > (SELECT AVG(amount) FROM orders)
LIMIT 10;

EXPLAIN ANALYSE  -- 1.58
WITH avg_order AS (
    SELECT AVG(amount) as avg_amount
    FROM orders
)
SELECT c.customer_name, o.amount, ao.avg_amount
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN avg_order ao ON o.amount > ao.avg_amount
LIMIT 10;


-- 서브쿼리가 여러 번 실행됨 (비효율적)
EXPLAIN ANALYSE  -- 4.75
SELECT 
    customer_id,
    (SELECT AVG(amount) FROM orders) as avg_amount,
    amount,
    amount - (SELECT AVG(amount) FROM orders) as diff
FROM orders
WHERE amount > (SELECT AVG(amount) FROM orders);


--
WITH region_summary AS (
	SELECT
		c.region AS 지역명,
		COUNT(DISTINCT c.customer_id) AS 고객수,
		COUNT(o.order_id) AS 주문수,
		COALESCE(AVG(o.amount), 0) AS 평균주문금액
	FROM customers c
	LEFT JOIN orders o ON c.customer_id=o.customer_id
	GROUP BY c.region
)
SELECT
	지역명,
	고객수,
	주문수,
	ROUND(평균주문금액) AS 평균주문금액
FROM region_summary
ORDER BY 고객수 DESC









