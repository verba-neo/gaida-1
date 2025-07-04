-- 20-subquery3.sql

USE lecture;

-- 각 카테고리 별 평균매출중에서 50만원 이상만 구하기
SELECT 
  category,
  AVG(total_amount) AS 평균매출액
FROM sales GROUP BY category
HAVING 평균매출액 > 500000;

-- 인라인 뷰(View) => 내가 만든 테이블
SELECT *
FROM (
  SELECT 
    category,
  AVG(total_amount) AS 평균매출액
  FROM sales GROUP BY category
) AS cateogry_summary
WHERE 평균매출액 >= 500000;

--  category_summary
-- ┌─────────────┬─────────────┐
-- │  category   │   평균매출액   │
-- ├─────────────┼─────────────┤
-- │  전자제품     │   890,000   │
-- │  의류        │   420,000   │
-- │  생활용품     │   650,000   │
-- │  식품        │   180,000   │
-- └─────────────┴─────────────┘
-- SELECT * FROM category_summary WHERE 평균매출액 > 500000

-- 1. 카테고리별 매출 분석 후 필터링
-- 카테고리명, 주문건수, 총매출, 평균매출, 평균매출 [0 <= 저단가 < 400000 <= 중단가 < 800000 < 고단가]

SELECT
  category,
  판매건수,
  총매출,
  평균매출,
  CASE
    WHEN 평균매출 >= 800000 THEN '고단가'
    WHEN 평균매출 >= 400000 THEN '중단가'
    ELSE '저단가'
  END AS 단가구분
FROM (
  SELECT
    category,
    COUNT(*) AS 판매건수,
    SUM(total_amount) AS 총매출,
    ROUND(AVG(total_amount)) AS 평균매출
  FROM sales
  GROUP BY category
) AS c_a 
WHERE 평균매출 >= 300000;

-- 영업사원별 성과 등급 분류 [영업사원, 총매출액, 주문건수, 평균주문액, 매출등급, 주문등급]
-- 매출등급 - 총매출[0< C <= 백만 < B < 3백만 <= A < 5백만 <= S]
-- 주문등급 - 주문건수  [0 <= C < 15 <= B < 30 <= A]
-- ORDER BY 총매출액 DESC

SELECT
  영업사원, 총매출액, 주문건수, 평균주문액,
  CASE
    WHEN 총매출액 >= 15000000 THEN 'S'
    WHEN 총매출액 >= 3000000 THEN 'A'
    WHEN 총매출액 >= 1000000 THEN 'B'
    ELSE 'C'
  END AS 매출등급,
  CASE
    WHEN 주문건수 >= 20 THEN 'A'
    WHEN 주문건수 >= 10 THEN 'B'
    ELSE 'C'
  END AS 주문등급
FROM (
  SELECT
    coalesce(sales_rep, '확인불가') AS 영업사원,
    SUM(total_amount) AS 총매출액,
    COUNT(*) AS 주문건수,
    AVG(total_amount) AS 평균주문액
  FROM sales
  GROUP BY sales_rep
) AS rep_analyze
ORDER BY 총매출액 DESC;










