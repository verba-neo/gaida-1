-- p07.sql
USE practice;

CREATE TABLE dt_demo2 AS SELECT * FROM lecture.dt_demo;

SELECT * FROM dt_demo2;

-- FROM dt_demo; -> Error. FROM dt_demo2;

-- 종합 정보 표시
SELECT
-- id
-- name
-- 닉네임 (NULL -> '미설정')
-- 출생년도 (19xx년생)
-- 나이 (TIMESTAMPDIFF 로 나이만 표시)
-- 점수 (소수 1자리 반올림, Null -> 0)
-- 등급 (A >= 90 / B >= 80 / C >= 70 / D)
-- 상태 (is_active 가 1 이면 '활성' / 0 '비활성')
-- 연령대 (청년 < 30 < 청장년 < 50 < 장년)

FROM dt_demo2;




