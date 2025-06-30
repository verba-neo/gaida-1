-- 05-select.sql
USE lecture;

-- 모든 컬럼, 모든 레코드
SELECT * FROM members;

-- 모든 컬럼, id 3
SELECT * FROM members WHERE id=3;

-- 컬럼 이름 | 이메일, 모든 레코드
SELECT name, email FROM members;

-- 컬럼 이름, 이름=홍길동
SELECT name FROM members WHERE name='홍길동';