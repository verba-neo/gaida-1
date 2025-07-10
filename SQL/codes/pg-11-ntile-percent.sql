-- pg-11-ntile-percent.sql
-- NTILE 균등하게 나누기 NTILE(4) 4등분
-- NTILE(4) OVER (ORDER BY 총구매금액) AS 4분위  

WITH customer_totals AS (
	SELECT
		customer_id,
		SUM(amount) AS 총구매금액,
		COUNT(*) AS 구매횟수
	FROM orders
	GROUP BY customer_id
),
customer_grade AS (
	SELECT
		customer_id,
		총구매금액,
		구매횟수,
		NTILE(4) OVER (ORDER BY 총구매금액) AS 분위4,
		NTILE(10) OVER (ORDER BY 총구매금액) AS 분위10
	FROM customer_totals
	ORDER BY 총구매금액 DESC
)
SELECT
	c.customer_name,
	cg.총구매금액,
	cg.구매횟수,
	CASE
		WHEN 분위4=1 THEN 'Bronze'
		WHEN 분위4=2 THEN 'Silver'
		WHEN 분위4=3 THEN 'Gold'
		WHEN 분위4=4 THEN 'VIP'
	END AS 고객등급
FROM customer_grade cg
INNER JOIN customers c ON cg.customer_id=c.customer_id;

-- PERCNET_RANK()
SELECT
	product_name,
	category,
	price,
	RANK() OVER (ORDER BY price) AS 가격순위,
	PERCENT_RANK() OVER (ORDER BY price)AS 백분위순위,
	CASE
		WHEN PERCENT_RANK() OVER (ORDER BY price) >= 0.9 THEN '최고가(상위10%)'
		WHEN PERCENT_RANK() OVER (ORDER BY price) >= 0.7 THEN '고가(상위30%)'
		WHEN PERCENT_RANK() OVER (ORDER BY price) >= 0.3 THEN '중간가(상위70%)'
		ELSE '저가(하위30%)'
	END 가격등급
FROM products;

-- 카테고리별 처음등장/마지막등장 (파티션의 처음/마지막을 찾는 윈도우함수)
SELECT
	category,
	product_name,
	price,
	FIRST_VALUE(product_name) OVER (
		PARTITION BY category
		ORDER BY price DESC
		ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING  -- 파티션의 모든 행을 봐라
	) AS 최고가상품명,
	FIRST_VALUE(price) OVER (
		PARTITION BY category
		ORDER BY price DESC
		ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
	) AS 최고가격,
	LAST_VALUE(product_name) OVER (
		PARTITION BY category
		ORDER BY price DESC
		ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
	) AS 최저가상품명,
	LAST_VALUE(price) OVER (
		PARTITION BY category
		ORDER BY price DESC
		ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
	) AS 최저가격
FROM products;




