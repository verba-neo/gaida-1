CREATE USER llm_readonly_user WITH PASSWORD 'qwer1234';

GRANT CONNECT ON DATABASE langgraph-db TO llm_readonly_user;

GRANT USAGE ON SCHEMA public TO llm_readonly_user;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO llm_readonly_user;

-- 새로 생성되는 테이블에도 자동 적용되도록
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT ON TABLES TO llm_readonly_user;
