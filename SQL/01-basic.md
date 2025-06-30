# MySQL 1일차 요약본

## 📊 데이터베이스 핵심 개념

### 스키마(Schema)
- **정의**: 데이터베이스의 구조와 제약조건을 정의한 것
- **포함 요소**: 테이블 구조, 데이터 타입, 제약조건, 관계 등
- **역할**: 데이터가 어떻게 저장되고 관리될지 설계도 역할

### DDL vs DML

| 구분 | DDL (Data Definition Language) | DML (Data Manipulation Language) |
|------|-------------------------------|-----------------------------------|
| **목적** | 데이터베이스 구조 정의/변경 | 데이터 조작 |
| **대상** | 테이블, 데이터베이스, 스키마 | 데이터 (행) |
| **주요 명령어** | CREATE, ALTER, DROP | INSERT, SELECT, UPDATE, DELETE |
| **실행 결과** | 구조 변경 | 데이터 변경 |

---

## 🗄️ 데이터베이스 관리 (DDL)

```sql
-- 데이터베이스 생성
CREATE DATABASE database_name;

-- 데이터베이스 선택
USE database_name;

-- 데이터베이스 목록 조회
SHOW DATABASES;

-- 데이터베이스 삭제
DROP DATABASE IF EXISTS database_name;
```

---

## 📋 테이블 관리 (DDL)

### 테이블 생성
```sql
CREATE TABLE table_name (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(30) NOT NULL,
  email VARCHAR(50) UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### 테이블 구조 확인
```sql
-- 테이블 목록
SHOW TABLES;

-- 테이블 구조
DESC table_name;
```

### 테이블 구조 변경
```sql
-- 컬럼 추가
ALTER TABLE table_name ADD COLUMN column_name datatype;

-- 컬럼 수정
ALTER TABLE table_name MODIFY COLUMN column_name new_datatype;

-- 컬럼 삭제
ALTER TABLE table_name DROP COLUMN column_name;
```

### 테이블 삭제
```sql
DROP TABLE IF EXISTS table_name;
```

---

## 📝 데이터 조작 (DML)

### INSERT - 데이터 입력
```sql
-- 단일 행 입력
INSERT INTO table_name (column1, column2) VALUES (value1, value2);

-- 다중 행 입력
INSERT INTO table_name (column1, column2) VALUES 
(value1, value2),
(value3, value4);
```

### SELECT - 데이터 조회
```sql
-- 전체 조회
SELECT * FROM table_name;

-- 특정 컬럼 조회
SELECT column1, column2 FROM table_name;

-- 조건부 조회
SELECT * FROM table_name WHERE condition;
```

### UPDATE - 데이터 수정
```sql
UPDATE table_name SET column1 = value1 WHERE condition;
```

### DELETE - 데이터 삭제
```sql
DELETE FROM table_name WHERE condition;
```

---

## 🔐 주요 제약조건

### PRIMARY KEY
- **목적**: 각 행의 고유 식별자
- **특징**: 중복 불가, NULL 불가, 테이블당 1개
```sql
id INT AUTO_INCREMENT PRIMARY KEY
```

### NOT NULL
- **목적**: 필수 입력 강제
- **특징**: 빈 값 입력 불가
```sql
name VARCHAR(30) NOT NULL
```

### UNIQUE
- **목적**: 중복 값 방지
- **특징**: 중복 불가, NULL 허용, 여러 개 가능
```sql
email VARCHAR(50) UNIQUE
```

### DEFAULT
- **목적**: 기본값 자동 입력
- **특징**: 값 미입력 시 기본값 사용
```sql
status VARCHAR(10) DEFAULT 'active'
created_at DATETIME DEFAULT CURRENT_TIMESTAMP
```

### AUTO_INCREMENT
- **목적**: 숫자 자동 증가
- **특징**: 주로 PRIMARY KEY와 함께 사용
```sql
id INT AUTO_INCREMENT PRIMARY KEY
```

---

## 📊 주요 데이터 타입

| 타입 | 설명 | 예시 |
|------|------|------|
| `INT` | 정수 | `age INT` |
| `VARCHAR(n)` | 가변 문자열 | `name VARCHAR(50)` |
| `TEXT` | 긴 문자열 | `content TEXT` |
| `DATE` | 날짜 | `birth_date DATE` |
| `DATETIME` | 날짜+시간 | `created_at DATETIME` |

---

## ⚠️ 주의사항

### 안전한 쿼리 작성
```sql
-- ❌ 위험 (모든 데이터 영향)
UPDATE users SET status = 'inactive';
DELETE FROM users;

-- ✅ 안전 (조건 지정)
UPDATE users SET status = 'inactive' WHERE id = 1;
DELETE FROM users WHERE status = 'deleted';
```

### WHERE 절 필수 상황
- UPDATE: 특정 데이터만 수정
- DELETE: 특정 데이터만 삭제
- SELECT: 조건에 맞는 데이터만 조회

### IF EXISTS 사용
```sql
-- 에러 방지
DROP TABLE IF EXISTS table_name;
DROP DATABASE IF EXISTS database_name;
```

---

## 🎯 핵심 포인트

1. **DDL**로 구조를 만들고, **DML**로 데이터를 다룬다
2. **스키마**는 데이터베이스의 설계도
3. **제약조건**은 데이터 무결성 보장
4. **WHERE 절**은 안전한 데이터 조작의 핵심
5. **PRIMARY KEY + AUTO_INCREMENT**는 기본 패턴
6. **DEFAULT + CURRENT_TIMESTAMP**로 자동 시간 입력