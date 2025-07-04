-- 21-view.sql
USE lecture;

CREATE VIEW customer_summary AS
SELECT
    c.customer_id,
    c.customer_name,
    c.customer_type,
    COUNT(s.id) AS 주문횟수,
    COALESCE(SUM(s.total_amount), 0) AS 총구매액,
    COALESCE(AVG(s.total_amount), 0) AS 평균주문액,
    COALESCE(MAX(s.order_date), '주문없음') AS 최근주문일
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_type;

-- 등급별 구매 평균
SELECT 
  customer_type,
  AVG(총구매액)
FROM customer_summary
GROUP BY customer_type;

SELECT * FROM customer_summary;

-- 충성고객 -> 주문횟수 5이상
SELECT * FROM customer_summary
WHERE 주문횟수 >= 5;

-- 잠재고객 -> 최근주문 빠른 10명
SELECT * FROM customer_summary
WHERE 최근주문일 != '주문없음'
ORDER BY 최근주문일 DESC
LIMIT 10;



-- View 2: 카테고리별 성과 요약 View
-- 카테고리 별로, 총 주문건수, 총매출액, 평균주문금액, 구매고객수, 판매상품수, 매출비중(전체매출에서 해당 카테고리가 차지하는비율)




-- View 3: 월별 매출 요약
-- 년월(24-07), 월주문건수, 월평균매출액, 월활성고객수, 월신규고객수







