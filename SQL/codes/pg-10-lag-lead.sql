-- pg-10-lag-lead.sql

-- 매일 체중 기록
-- LAG() - 이전 값을 가져온다.
-- 전월 대비 매출 분석

-- 매달 매출을 확인
-- 위 테이블에 증감률 컬럼 추가

WITH monthly_sales AS (
	SELECT
		DATE_TRUNC('month', order_date) AS 월,
		SUM(amount) as 월매출
	FROM orders
	GROUP BY 월
),
compare_before AS (
	SELECT
		TO_CHAR(월, 'YYYY-MM') as 년월,
		월매출,
		LAG(월매출, 1) OVER (ORDER BY 월) AS 전월매출
	FROM monthly_sales
)
SELECT
	*,
	월매출 - 전월매출 AS 증감액,
	CASE
		WHEN 전월매출 IS NULL THEN NULL
		ELSE ROUND((월매출 - 전월매출) * 100 / 전월매출, 2)::TEXT || '%'
	END AS 증감률
FROM compare_before
ORDER BY 년월;








