-- SELECT 컬럼 
-- FROM 테이블 
-- WHERE 조건 
-- ORDER BY 정렬기준
--  LIMIT 개수

USE lecture;

DROP TABLE students;

CREATE TABLE students (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(20),
  age INT
);

DESC students;

INSERT INTO students (name, age) VALUES
('유 태영', 50),
('이 재필', 30),
('김 창휘', 20),
('오 창희', 25),
('공 형규', 33),
('권 태형', 18),
('유 창준', 45),
('하 준서', 10),
('이 제웅', 88),
('박 용호', 67);

SELECT * FROM students;

SELECT * FROM students WHERE name='유 창준';
SELECT * FROM students WHERE age >= 20;  -- 이상
SELECT * FROM students WHERE age > 20;  -- 초과
SELECT * FROM students WHERE id <> 1;  -- 해당 조건이 아닌
SELECT * FROM students WHERE id != 1;  -- 해당 조건이 아닌

SELECT * FROM students WHERE age BETWEEN 20 AND 40;  -- 20 이상, 40 이하

SELECT * FROM students WHERE id IN (1, 3, 5, 7);

-- 문자열 패턴 LIKE (% -> 있을수도, 없을수도 있다. _ -> 정확히 개수만큼 글자가 있다.)
-- 이 씨만 찾기
SELECT * FROM students WHERE name LIKE '이%';
-- '창' 글자가 들어가는 사람
SELECT * FROM students WHERE name LIKE '%창%';
-- '창' 으로 시작만 하면 됨
SELECT * FROM students WHERE name LIKE '창%';
-- '창' 으로 끝나기만 하면 됨
SELECT * FROM students WHERE name LIKE '%창';

-- 이름이 정확히 3글자인 유씨
SELECT * FROM students WHERE name LIKE '유 __';
