-- 06-alter.sql

USE lecture;

DESC members;

-- 테이블 스키마(컬럼 구조) 변경

-- 컬럼 추가
ALTER TABLE members ADD COLUMN age INT NOT NULL DEFAULT 20;
ALTER TABLE members ADD COLUMN address VARCHAR(100) DEFAULT '미입력';

-- 컬럼 이름 + 데이터 타입 수정
ALTER TABLE members CHANGE COLUMN address juso VARCHAR(100);
-- 컬럼 데이터 타입 수정
ALTER TABLE members MODIFY COLUMN juso VARCHAR(50);

-- 컬럼 삭제
ALTER TABLE members DROP COLUMN age;

SELECT * FROM members;