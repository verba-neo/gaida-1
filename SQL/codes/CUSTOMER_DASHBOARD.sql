SELECT
    c.customer_id,
    c.customer_name,
    c.customer_type,
    c.join_date,
    customer_summary.주문횟수,
    customer_summary.총구매액,
    customer_summary.평균주문액,
    customer_summary.최근주문일,
    customer_summary.구매카테고리수,
    -- 벤치마킹 데이터
    benchmarks.고객평균구매액,
    benchmarks.고객평균주문횟수,
    -- 상대적 평가
    ROUND(customer_summary.총구매액 / benchmarks.고객평균구매액, 2) AS 평균대비구매력,
    ROUND(customer_summary.주문횟수 / benchmarks.고객평균주문횟수, 2) AS 평균대비활성도,
    -- 종합 등급
    CASE
        WHEN customer_summary.총구매액 >= 3000000 AND customer_summary.주문횟수 >= 15 THEN 'VIP+'
        WHEN customer_summary.총구매액 >= 2000000 AND customer_summary.주문횟수 >= 10 THEN 'VIP'
        WHEN customer_summary.총구매액 >= 1000000 AND customer_summary.주문횟수 >= 5 THEN 'GOLD'
        WHEN customer_summary.총구매액 >= 500000 THEN 'SILVER'
        WHEN customer_summary.주문횟수 > 0 THEN 'BRONZE'
        ELSE 'PROSPECT'
    END AS 고객등급,
    -- 활성도 평가
    CASE
        WHEN customer_summary.최근주문일 IS NULL THEN 'NEVER'
        WHEN DATEDIFF('2024-12-31', customer_summary.최근주문일) <= 30 THEN 'ACTIVE'
        WHEN DATEDIFF('2024-12-31', customer_summary.최근주문일) <= 90 THEN 'WARM'
        ELSE 'COLD'
    END AS 활성도상태
FROM customers c
LEFT JOIN (
    SELECT
        customer_id,
        COUNT(*) AS 주문횟수,
        SUM(total_amount) AS 총구매액,
        AVG(total_amount) AS 평균주문액,
        MAX(order_date) AS 최근주문일,
        COUNT(DISTINCT category) AS 구매카테고리수
    FROM sales
    GROUP BY customer_id
) AS customer_summary ON c.customer_id = customer_summary.customer_id
CROSS JOIN (
    SELECT
        AVG(고객구매액) AS 고객평균구매액,
        AVG(고객주문횟수) AS 고객평균주문횟수
    FROM (
        SELECT
            customer_id,
            SUM(total_amount) AS 고객구매액,
            COUNT(*) AS 고객주문횟수
        FROM sales
        GROUP BY customer_id
    ) AS customer_stats
) AS benchmarks
ORDER BY customer_summary.총구매액 DESC;