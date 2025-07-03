-- p08.sql

-- practice DB에
USE practice;
-- lecture - sales, products 복사해오기
CREATE TABLE sales AS SELECT * FROM lecture.sales;
CREATE TABLE products AS SELECT * FROM lecture.products;

-- 단일값 서브쿼리
-- 1. 평균 이상 매출 주문들(성과가 좋은 주문들)

-- 2. 최고 매출 지역의 모든 주문들

-- 3. 각 카테고리에서 [카테고리별 평균] 보다 높은 주문들


-- 여러데이터 서브쿼리
-- 1. 기업 고객들의 모든 주문 내역

-- 2. 재고 부족(50개 미만) 제품의 매출 내역

-- 3. 상위 3개 매출 지역의 주문들

-- 4. 상반기(24-01-01 ~ 24-06-30) 에 주문한 고객들의 하반기(0701~1231) 주문 내역