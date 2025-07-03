USE lecture;
-- VIP 고객들의 구매 내역 조회 (고객명, 고객유형, 상품명, 카테고리, 주문금액)
SELECT *
FROM customers c
INNER JOIN sales s ON c.customer_id = s.customer_id
WHERE c.customer_type = 'VIP';


-- 각 등급별 구매액 평균
SELECT
  c.customer_type,
  AVG(s.total_amount)
FROM customers c
INNER JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_type;

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


-- INNER JOIN (교집합)
SELECT
  COUNT(*)
FROM customers c
INNER JOIN sales s ON c.customer_id = s.customer_id;


-- LEFT JOIN -> 왼쪽 테이블(c) 의 모든 데이터와 + 매칭되는 오른쪽 데이터 | 매칭되는 오른쪽 데이터 (없어도 등장)
SELECT *
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.id IS NULL;  -- -> 한번도 주문한적 없는 사람들이 나온다;
  

-- LEFT JOIN을 통한 [모든 고객]의 구매 현황 분석(구매를 하지 않았어도 분석)
SELECT
    c.customer_id,
    c.customer_name,
    c.customer_type,
    c.join_date,
    COUNT(s.id) AS 주문횟수,
    COALESCE(SUM(s.total_amount), 0) AS 총구매액,
    COALESCE(AVG(s.total_amount), 0) AS 평균주문액,
    COALESCE(MAX(s.order_date), '주문없음') AS 최근주문일,
    CASE
        WHEN COUNT(s.id) = 0 THEN '잠재고객'
        WHEN COUNT(s.id) >= 5 THEN '충성고객'
        WHEN COUNT(s.id) >= 4 THEN '일반고객'
        ELSE '신규고객'
    END AS 고객분류
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_type, c.join_date
ORDER BY 총구매액 DESC;
