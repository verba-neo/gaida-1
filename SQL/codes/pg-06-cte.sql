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
FROM region_summary rs
ORDER BY 고객수 DESC;


-- 1. 각 상품의 총 판매량과 총 매출액을 계산하세요
-- 2. 상품 카테고리별로 그룹화하여 표시하세요
-- 3. 각 카테고리 내에서 매출액이 높은 순서로 정렬하세요
-- 4. 각 상품의 평균 주문 금액도 함께 표시하세요

-- - 먼저 상품별 판매 통계를 CTE로 만들어보세요
-- - products 테이블과 orders 테이블을 JOIN하세요
-- - 카테고리별로 정렬하되, 각 카테고리 내에서는 매출액 순으로 정렬하세요

WITH product_sales AS (
	SELECT
		p.category AS 카테고리,
		p.product_name AS 제품명,
		p.price AS 상품가격,
		SUM(o.quantity) AS 총판매량,
		SUM(o.amount) AS 총매출액,
		COUNT(o.order_id) AS 주문건수,
		AVG(o.amount) AS 평균주문금액
	FROM products p
	LEFT JOIN orders o ON p.product_id=o.product_id
	GROUP BY p.category, p.product_name, p.price
)
SELECT
	카테고리,
	제품명,
	총판매량,
	총매출액,
	ROUND(평균주문금액) AS 평균주문금액,
	주문건수,
	상품가격
FROM product_sales
ORDER BY 카테고리, 총매출액 DESC;


-- 카테고리별 매출 비중 분석
WITH product_sales AS (
	SELECT
		p.category AS 카테고리,
		p.product_name AS 제품명,
		p.price AS 상품가격,
		SUM(o.quantity) AS 총판매량,
		SUM(o.amount) AS 제품총매출액,
		COUNT(o.order_id) AS 주문건수,
		AVG(o.amount) AS 평균주문금액
	FROM products p
	LEFT JOIN orders o ON p.product_id=o.product_id
	GROUP BY p.category, p.product_name, p.price
),
category_total AS (
	SELECT
		카테고리,
		SUM(제품총매출액) AS 카테고리총매출액
	FROM product_sales
	GROUP BY 카테고리
)
SELECT
	ps.카테고리,
	ps.제품명,
	ROUND(ps.제품총매출액 * 100 / ct.카테고리총매출액, 2) AS 카테고리매출비중
FROM product_sales ps
INNER JOIN category_total ct ON ps.카테고리=ct.카테고리
ORDER BY ps.카테고리, ps.제품총매출액 DESC;


-- 고객 구매금액에 따라 VIP(상위 20%) / 일반(전체평균보다 높음) / 신규(나머지) 로 나누어 등급통계를 보자.
-- [등급, 등급별 회원수, 등급별 구매액총합, 등급별 평균 주문수]

-- 1. 고객별 총 구매 금액 + 주문수
WITH customer_total AS (
	SELECT
		customer_id,
		SUM(amount) as 총구매액,
		COUNT(*) AS 총주문수
	FROM orders
	GROUP BY customer_id
),
-- 2. 구매 금액 기준 계산
purchase_threshold AS (
	SELECT
		AVG(총구매액) AS 일반기준,
		-- 상위 20% 기준값 구하기
		PERCENTILE_CONT(0.8) WITHIN GROUP (ORDER BY 총구매액) AS vip기준
	FROM customer_total
),
-- 3. 고객 등급 분류
customer_grade AS (
	SELECT
		ct.customer_id,
		ct.총구매액,
		ct.총주문수,
		CASE 
			WHEN ct.총구매액 >= pt.vip기준 THEN 'VIP'
			WHEN ct.총구매액 >= pt.일반기준 THEN '일반'
			ELSE '신규'
		END AS 등급
	FROM customer_total ct
	CROSS JOIN purchase_threshold pt
)

-- 4. 등급별 통계 출력
SELECT
	등급,
	COUNT(*) AS 등급별고객수,
	SUM(총구매액) AS 등급별총구매액,
	ROUND(AVG(총주문수), 2) AS 등급별평균주문수
FROM customer_grade
GROUP BY 등급

