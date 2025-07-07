-- 27-self-join.sql

SELECT * FROM employees;
-- id 가 1 차이나면 적은사람이 상사, 많은사람이 직원
SELECT
  상사.name AS 상사명,
  직원.name AS 직원명
FROM employees 상사
LEFT JOIN employees 직원 ON 직원.id = 상사.id + 1;

-- 고객 간 구매 패턴 유사성
-- customers <-ij-> sales <-ij-> customers

-- [손님1, 손님2, 공통구매카테고리수, 공통카테고리이름(GROUP_CONCAT)]

