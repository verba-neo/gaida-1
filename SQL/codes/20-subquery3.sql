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

--  category_suammry
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
