-- p03.sql

-- practice db 사용
USE practice;

-- 스키마 확인 & 데이터 확인 (주기적으로)
DESC userinfo;
SELECT * FROM userinfo;

-- userinfo 에 email 컬럼 추가 40글자 제한, 기본값은 ex@gmail.com
ALTER TABLE userinfo ADD COLUMN email VARCHAR(40) DEFAULT 'ex@gmail.com';
-- nickname 길이제한 100자로 늘리기
ALTER TABLE userinfo MODIFY COLUMN nickname VARCHAR(100);
-- reg_date 컬럼 삭제
ALTER TABLE userinfo DROP COLUMN reg_date;
-- 실제 한명의 email 을 수정하기
UPDATE userinfo SET email='good@good.com' WHERE id=1;