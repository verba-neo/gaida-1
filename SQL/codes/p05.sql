-- p05.sql

USE practice;
SHOW TABLES;
SELECT * FROM userinfo;

ALTER TABLE userinfo ADD COLUMN age INT DEFAULT 20;
UPDATE userinfo SET age=30 WHERE id BETWEEN 1 and 5;

-- 이름 오름차순 상위 3명
SELECT * FROM userinfo ORDER BY nickname LIMIT 3;

-- email gmail 인 사람들 나이순으로 정렬
SELECT * FROM userinfo 
WHERE email LIKE '%gmail.com' 
ORDER BY age DESC;

-- 나이 많은사람들 중에 핸드폰 번호 오름차순 3명의 이름, 폰번, 나이만 확인.
SELECT nickname, phone, age 
FROM userinfo
ORDER BY age DESC, phone
LIMIT 3;

-- 이름 오름차순 인데 가장 이름이 빠른사람 1명은 제외하고 3명만 조회. -> 페이지네이션
SELECT * FROM userinfo ORDER BY nickname 
LIMIT 3
OFFSET 1;