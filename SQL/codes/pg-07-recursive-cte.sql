-- pg-07-recursive-cte.sql

-- Recursive - 재귀

WITH RECURSIVE numbers AS (
	-- 초기값
	SELECT 1 as num
	--
	UNION ALL
	-- 재귀 부분
	SELECT num + 1
	FROM numbers
	WHERE num < 10
)
SELECT * FROM numbers;


WITH RECURSIVE calender AS (
	-- 1/1 은 제공
	SELECT '2024-01-01'::DATE as 날짜
	UNION ALL
	SELECT (날짜 + INTERVAL'1 day')::DATE
	FROM calender
	WHERE 날짜 < '2024-01-31'::DATE
)
SELECT
	날짜
FROM calender;

-- 대표부터 전체 조직도 확인
WITH RECURSIVE org_chart AS (
	SELECT
		employee_id,
		employee_name,
		manager_id,
		department,
		1 AS 레벨,
		employee_name::text AS 조직구조
	FROM employees
	WHERE manager_id is NULL  -- 대표 찾기
	UNION ALL
	SELECT
		e.employee_id,
		e.employee_name,
		e.manager_id,
		e.department,
		oc.레벨 + 1,  -- 2
		(oc.조직구조 || '>>' || e.employee_name)::text
	FROM employees e
	INNER JOIN org_chart oc ON e.manager_id=oc.employee_id  -- 박영업 내 상사인 사람들
)
SELECT 
  	*
FROM org_chart
ORDER BY 레벨;

-- 특정 인물을 첫줄에 배치 -> 해당 인물을 기준으로 부하 직원 확인하기
WITH RECURSIVE org_chart AS (
	SELECT
		employee_id,
		employee_name,
		manager_id,
		department,
		level,
		employee_name::text AS 조직구조
	FROM employees
	WHERE employee_name = '부장 김영업1'
	UNION ALL
	SELECT
		e.employee_id,
		e.employee_name,
		e.manager_id,
		e.department,
		e.level,
		(oc.조직구조 || '>>' || e.employee_name)::text
	FROM employees e
	INNER JOIN org_chart oc ON e.manager_id=oc.employee_id
)
SELECT 
  	*
FROM org_chart
ORDER BY level;
