-- 10-str-func.sql
USE lecture;

-- 길이
SELECT CHAR_LENGTH('hello sql');
SELECT name, CHAR_LENGTH(name) AS '이름 길이' FROM dt_demo;

-- 연결
SELECT CONCAT('hello', 'sql', '!!');
SELECT CONCAT(name, '(', score, ')') AS info FROM dt_demo;

-- 대소문자 변환
SELECT 
	nickname,
    UPPER(nickname) AS UN,
    LOWER(nickname) AS LN
FROM dt_demo;

-- 부분 문자열 추출 (문자열, 시작점, 길이)
SELECT SUBSTRING('hello sql!', 2, 4);
SELECT LEFT('hello sql!', 5);
SELECT RIGHT('hello sql!', 5);

SELECT
	description,
    CONCAT(
		SUBSTRING(description, 1, 5), '...'			
	) AS intro,
    CONCAT(
		LEFT(description, 3),
        '...',
        RIGHT(description, 3)
    ) AS summary
    
FROM dt_demo;

-- 문자열 치환
SELECT REPLACE('a@test.com', 'a', 'A');
SELECT 
	description,
    REPLACE(description, '학생', '**') AS secret
FROM dt_demo;

-- 동적 추출 (원하는 글자의 위치를 확인 후 그 이전/이후를 추출하기
SELECT LOCATE('@', 'username@gmail.com');  -- username@gmail.com 에서 @이 등장하는 순서(숫자)

SELECT
  description,
  SUBSTRING(description, 1, LOCATE('학생', description) - 1) AS '학생설명'
FROM dt_demo;

-- 공백 없애기
SELECT TRIM('    what??     ');


