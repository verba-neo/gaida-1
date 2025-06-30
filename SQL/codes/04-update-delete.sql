-- 04-update-delete.sql

SELECT * FROM membersmembers;
INSERT INTO members(name) VALUES ('익명');

-- Update(데이터 수정)
UPDATE members SET name='홍길동', email='hong@a.com' WHERE id=6;
-- 원치 않는 케이스 (name이 같으면 동시 수정)
UPDATE members SET name='No name' WHERE name='유태영';

-- DELETE(데이터 삭제)
DELETE FROM members WHERE id=7;
-- 테이블 모든 데이터 삭제(위험)
DELETE FROM members;

