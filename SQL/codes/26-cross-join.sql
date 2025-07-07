-- 26-cross-join.sql

-- 카르테시안 곱(모든 경우의 수 조합)

SELECT
  c.customer_name,
  p.product_name,
  p.category,
  p.selling_price
FROM customers c
CROSS JOIN products p
WHERE c.customer_type = 'VIP'
ORDER BY c.customer_name, p.category;

-- 구매하지 않은 상품 추천
SELECT
  c.customer_name AS 고객명,
  p.product_name AS 미구매상품
FROM customers c
CROSS JOIN products p
-- VIP 고객이며, 구매하지 않은 상품만
WHERE c.customer_type = 'VIP' 
  AND NOT EXISTS (
    SELECT 1 
    FROM sales s
    WHERE s.customer_id = c.customer_id
    AND s.product_id = p.product_id
  )
ORDER BY 고객명;
