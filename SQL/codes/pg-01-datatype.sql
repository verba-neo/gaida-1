-- pg-01-datatype.sql
CREATE TABLE datatype_demo(
	-- mysql 에도 있음. 이름이 다를 수는 있다.
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	age INTEGER,
	salary NUMERIC(12, 2),
	is_active BOOLEAN DEFAULT TRUE,
	created_at TIMESTAMP DEFAULT NOW(),
	-- postgresql 특화 타입
	tags TEXT[],    -- 배열
	metadata JSONB,  -- JSONB JSON binary 타입
	ip_address INET, -- IP 주소 저장 전용
	location POINT,  -- 기하학 점(x, y)
	salary_range INT4RANGE -- 범위
);

INSERT INTO datatype_demo (
    name, age, salary, tags, metadata, ip_address, location, salary_range
) VALUES
(
    '김철수',
    30,
    5000000.50,
	-- 
    ARRAY['개발자', 'PostgreSQL', '백엔드'],        -- 배열
    '{"department": "IT", "skills": ["SQL", "Python"], "level": "senior"}'::JSONB,  -- JSONB
    '192.168.1.100'::INET,                         -- IP 주소
    POINT(37.5665, 126.9780),                      -- 서울 좌표
    '[3000000,7000000)'::INT4RANGE                 -- 연봉 범위
),
(
    '이영희',
    28,
    4500000.00,
    ARRAY['디자이너', 'UI/UX'],
    '{"department": "Design", "skills": ["Figma", "Photoshop"], "level": "middle"}'::JSONB,
    '10.0.0.1'::INET,
    POINT(35.1796, 129.0756),                      -- 부산 좌표
    '[4000000,6000000)'::INT4RANGE
);

SELECT * FROM datatype_demo;
-- 배열(tags)
SELECT
	name,
	tags,
	tags[1] AS first_tag,
	'PostgreSQL' = ANY(tags) AS pg_dev
FROM datatype_demo;
-- JSONB(metadata)
SELECT
	name,
	metadata,
	metadata->>'department' AS 부서,
	metadata->'skills' AS 능력
FROM datatype_demo;

SELECT 
	name,
	metadata->>'department' AS 부서
FROM datatype_demo
WHERE metadata @> '{"level":"senior"}';

-- 범위(salary_range)
SELECT
	name,
	salary,
	salary_range,
	salary::INT <@ salary_range AS 연봉범위,
	UPPER(salary_range) - LOWER(salary_range) AS 연봉폭
FROM datatype_demo;

-- 좌표값(location)
SELECT
	name,
	location,
	location[0] AS 위도,
	location[1] AS 경도,
	POINT(37.505027, 127.005011) <-> location AS 고터거리
FROM datatype_demo;
	















