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

-- 3. 제품 테이블 생성
DROP TABLE IF EXISTS products;
CREATE TABLE products (
    product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    cost_price DECIMAL(10, 2) NOT NULL,
    selling_price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL,
    supplier VARCHAR(50) NOT NULL
);

-- 제품 데이터 삽입
INSERT INTO products VALUES
('P1001', '스마트폰', '전자제품', 600000, 900000, 50, 'Samsung'),
('P1002', '노트북', '전자제품', 800000, 1500000, 30, 'LG'),
('P1003', '태블릿', '전자제품', 300000, 500000, 25, 'Apple'),
('P1004', '티셔츠', '의류', 15000, 35000, 100, '유니클로'),
('P1005', '청바지', '의류', 40000, 80000, 60, 'Levis'),
('P1006', '운동화', '의류', 60000, 120000, 40, 'Nike'),
('P1007', '세제', '생활용품', 3000, 8000, 200, 'P&G'),
('P1008', '샴푸', '생활용품', 5000, 15000, 150, 'LOreal'),
('P1009', '청소기', '생활용품', 120000, 250000, 20, 'Dyson'),
('P1010', '쌀', '식품', 25000, 45000, 80, '농협'),
('P1011', '라면', '식품', 2000, 4000, 300, '농심'),
('P1012', '과자', '식품', 1500, 3500, 250, '오리온');

-- 데이터 확인


DESC customers;
DESC sales;

-- 4. 데이터 확인
SELECT * FROM customers;
SELECT * FROM sales;
SELECT * FROM products;

