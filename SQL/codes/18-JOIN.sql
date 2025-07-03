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
  COUNT(*)
FROM customers c
INNER JOIN sales s ON c.customer_id = s.customer_id;

-- 모든 고객의 구매 현황 분석(구매를 하지 않았어도 분석)
-- LEFT JOIN -> 왼쪽 테이블(c) 의 모든 데이터와 + 매칭되는 오른쪽 데이터 | 매칭되는 오른쪽 데이터 (없어도 등장)
SELECT *
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id;  
-- WHERE s.id IS NULL;  -> 한번도 주문한적 없는 사람들이 나온다;


SELECT 
  c.customer_id,
  c.customer_name,
  c.customer_type,
  COUNT(s.id) AS 구매건수,
  -- coalesce(첫번째 값, 10) -> 첫번째 값이 Null 인 경우, 10을 쓴다.
  coalesce(SUM(s.total_amount), 0) AS 총구매액,
  coalesce(AVG(s.total_amount), 0) AS 평균구매액,
  CASE
    WHEN COUNT(s.id) = 0 THEN '잠재고객'
    WHEN COUNT(s.id) >= 5 THEN '충성고객'
    WHEN COUNT(s.id) >= 3 THEN '일반고객'
    ELSE '신규고객'
  END AS 활성도
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_type;












  