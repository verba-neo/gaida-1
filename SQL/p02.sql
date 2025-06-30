-- p02.sql

-- practice db 이동
USE practice;
-- userinfo 테이블에 진행 (p01 실습에서 진행했던 테이블)
DESC userinfo;
-- 데이터 5건 넣기 (별명, 핸드폰) -> 별명 bob 을 포함하세요 C
INSERT INTO userinfo (nickname, phone) VALUES
('alice', '0104567890'),
('bob', '0104561234'),
('charlie', '01112345678'),
('david', '01874562131'),
('eric', '01054687913');

-- 전체 조회 (중간중간 계속 실행하면서 모니터링) R
SELECT * FROM userinfo;
-- id 가 3인 사람 조회 R
SELECT * FROM userinfo WHERE id=3;
-- 별명이 bob 인 사람을 조회 R
SELECT * FROM userinfo WHERE nickname='bob';
-- 별명이 bob 인 사람의 핸드폰 번호를 01099998888 로 수정 (id로 수정) U
UPDATE userinfo SET phone='01099998888' WHERE id=2;
-- 별명이 bob 인 사람 삭제 (id로 수정) D
DELETE FROM userinfo WHERE id=2;