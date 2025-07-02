-- insert-data-01.sql
USE lecture;

-- 1. 고객 테이블 생성
DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
    customer_id VARCHAR(10) PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    customer_type VARCHAR(20) NOT NULL,
    join_date DATE NOT NULL
);

-- 2. 매출 테이블 생성  
DROP TABLE IF EXISTS sales;
CREATE TABLE sales (
    id INT PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id VARCHAR(10) NOT NULL,
    product_id VARCHAR(10) NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    unit_price INT NOT NULL,
    total_amount INT NOT NULL,
    sales_rep VARCHAR(50) NOT NULL,
    region VARCHAR(50) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

DESC customers;
DESC sales;

-- 4. 데이터 확인
SELECT * FROM customers;
SELECT * FROM sales;
