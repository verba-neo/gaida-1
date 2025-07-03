-- 18-JOIN.sql
-- 고객정보 + 주문정보
USE lecture;

SELECT
  *,
  -- 지루하고 현학적임
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

-- LEFT JOIN -> 왼쪽 테이블(c) 의 모든 데이터와 + 매칭되는 오른쪽 데이터 | 매칭되는 오른쪽 데이터 (없어도 등장)
SELECT *
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id;  
-- WHERE s.id IS NULL;  -> 한번도 주문한적 없는 사람들이 나온다;

