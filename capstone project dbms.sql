DROP DATABASE IF EXISTS OnlineMarketplace;
CREATE DATABASE OnlineMarketplace;
USE OnlineMarketplace;


CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    city VARCHAR(50),
    registration_date DATE
);

CREATE TABLE Sellers (
    seller_id INT PRIMARY KEY AUTO_INCREMENT,
    seller_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    city VARCHAR(50)
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    seller_id INT,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock INT,
    FOREIGN KEY (seller_id) REFERENCES Sellers(seller_id)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    order_status VARCHAR(30),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Order_Items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    product_id INT,
    rating INT,
    comment VARCHAR(255),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
-- ============================================
-- 2. INSERT CUSTOMERS
-- ============================================

INSERT INTO Customers
(name,email,city,registration_date) VALUES
('Aman','aman@gmail.com','Delhi','2026-01-10'),
('Riya','riya@gmail.com','Gurgaon','2026-01-15'),
('Rahul','rahul@gmail.com','Noida','2026-02-10'),
('Priya','priya@gmail.com','Delhi','2026-02-20'),
('Karan','karan@gmail.com','Jaipur','2026-03-05'),
('Neha','neha@gmail.com','Gurgaon','2026-03-12'),
('Simran','simran@gmail.com','Delhi','2026-04-01'),
('Arjun','arjun@gmail.com','Noida','2026-04-10'),
('Anjali','anjali@gmail.com','Jaipur','2026-05-05'),
('Vikas','vikas@gmail.com','Delhi','2026-05-15');

-- ============================================
-- 3. INSERT SELLERS
-- ============================================

INSERT INTO Sellers
(seller_name,email,city) VALUES
('Tech World','tech@gmail.com','Delhi'),
('Fashion Hub','fashion@gmail.com','Gurgaon'),
('Home Store','home@gmail.com','Noida');

-- ============================================
-- 4. INSERT PRODUCTS
-- ============================================

INSERT INTO Products
(seller_id,product_name,category,price,stock) VALUES
(1,'Laptop','Electronics',55000,20),
(1,'Smartphone','Electronics',25000,30),
(1,'Headphones','Electronics',2000,50),
(2,'T-Shirt','Fashion',800,100),
(2,'Jeans','Fashion',1500,60),
(3,'Chair','Furniture',3000,25),
(3,'Table','Furniture',5000,15);

-- ============================================
-- 5. INSERT ORDERS
-- ============================================

INSERT INTO Orders
(customer_id,order_date,order_status) VALUES
(1,'2026-01-12','Delivered'),
(2,'2026-01-20','Delivered'),
(1,'2026-02-15','Delivered'),
(3,'2026-02-18','Delivered'),
(4,'2026-03-10','Delivered'),
(2,'2026-03-15','Delivered'),
(5,'2026-03-20','Delivered'),
(6,'2026-04-05','Delivered'),
(1,'2026-04-15','Delivered'),
(7,'2026-04-20','Delivered'),
(8,'2026-05-05','Delivered'),
(3,'2026-05-12','Delivered'),
(9,'2026-05-18','Delivered'),
(10,'2026-06-02','Delivered'),
(2,'2026-06-10','Delivered');

-- ============================================
-- 6. INSERT ORDER ITEMS
-- ============================================

INSERT INTO Order_Items
(order_id,product_id,quantity,price) VALUES
(1,1,1,55000),
(2,4,2,800),
(3,2,1,25000),
(4,3,2,2000),
(5,5,1,1500),
(6,1,1,55000),
(7,6,2,3000),
(8,4,3,800),
(9,2,2,25000),
(10,7,1,5000),
(11,1,1,55000),
(12,3,1,2000),
(13,5,2,1500),
(14,6,1,3000),
(15,2,1,25000);


INSERT INTO Reviews
(customer_id,product_id,rating,comment) VALUES
(1,1,5,'Excellent product'),
(2,4,4,'Good quality'),
(3,3,3,'Average'),
(4,5,5,'Very good'),
(5,6,4,'Nice product'),
(6,4,5,'Excellent'),
(7,7,3,'Average'),
(8,1,5,'Amazing'),
(9,5,4,'Good'),
(10,6,5,'Great');



SHOW TABLES;

SELECT * FROM Customers;
SELECT * FROM Sellers;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM Order_Items;
SELECT * FROM Reviews;

-- ============================================
-- 9. SALES ANALYSIS
-- ============================================

-- Total sales

SELECT SUM(quantity * price) AS Total_Sales
FROM Order_Items;

-- Monthly sales trends

SELECT
    DATE_FORMAT(o.order_date,'%Y-%m') AS Month,
    SUM(oi.quantity * oi.price) AS Monthly_Sales
FROM Orders o
JOIN Order_Items oi ON o.order_id=oi.order_id
GROUP BY Month
ORDER BY Month;

-- Top selling products

SELECT
    p.product_name,
    SUM(oi.quantity) AS Units_Sold
FROM Products p
JOIN Order_Items oi ON p.product_id=oi.product_id
GROUP BY p.product_id,p.product_name
ORDER BY Units_Sold DESC;

-- Customer satisfaction

SELECT
    p.product_name,
    AVG(r.rating) AS Average_Rating
FROM Products p
JOIN Reviews r ON p.product_id=r.product_id
GROUP BY p.product_id,p.product_name;

-- ============================================
-- 10. COHORT ANALYSIS
-- ============================================

SELECT
    c.customer_id,
    MIN(DATE_FORMAT(o.order_date,'%Y-%m'))
        AS First_Purchase_Cohort,
    COUNT(DISTINCT o.order_id) AS Total_Orders,
    SUM(oi.quantity*oi.price) AS Total_Spending
FROM Customers c
JOIN Orders o ON c.customer_id=o.customer_id
JOIN Order_Items oi ON o.order_id=oi.order_id
GROUP BY c.customer_id;


-- 11. INDEXING


CREATE INDEX idx_orders_customer_date
ON Orders(customer_id,order_date);

CREATE INDEX idx_products_category_price
ON Products(category,price);

CREATE FULLTEXT INDEX idx_product_search
ON Products(product_name,category);

-- Fulltext search

SELECT *
FROM Products
WHERE MATCH(product_name,category)
AGAINST('Laptop' IN NATURAL LANGUAGE MODE);

-- EXPLAIN composite index

EXPLAIN
SELECT *
FROM Orders
WHERE customer_id=1
AND order_date>='2026-01-01';

-- Low selectivity index

CREATE INDEX idx_order_status
ON Orders(order_status);

EXPLAIN
SELECT *
FROM Orders
WHERE order_status='Delivered';

-- ============================================
-- 12. SELLER PERFORMANCE VIEW
-- ============================================

CREATE OR REPLACE VIEW Seller_Performance AS
SELECT
    s.seller_id,
    s.seller_name,
    COALESCE(SUM(DISTINCT NULL),0) AS Dummy_Value
FROM Sellers s
GROUP BY s.seller_id,s.seller_name;

-- Correct seller sales and rating calculation

CREATE OR REPLACE VIEW Seller_Performance AS
SELECT
    s.seller_id,
    s.seller_name,
    COALESCE(sales.Total_Sales,0) AS Total_Sales,
    ratings.Average_Rating
FROM Sellers s
LEFT JOIN (
    SELECT
        p.seller_id,
        SUM(oi.quantity*oi.price) AS Total_Sales
    FROM Products p
    JOIN Order_Items oi ON p.product_id=oi.product_id
    GROUP BY p.seller_id
) sales ON s.seller_id=sales.seller_id
LEFT JOIN (
    SELECT
        p.seller_id,
        AVG(r.rating) AS Average_Rating
    FROM Products p
    JOIN Reviews r ON p.product_id=r.product_id
    GROUP BY p.seller_id
) ratings ON s.seller_id=ratings.seller_id;

SELECT * FROM Seller_Performance;

-- ============================================
-- 13. CUSTOMER LIFETIME VALUE VIEW
-- ============================================

CREATE OR REPLACE VIEW Customer_Lifetime_Value AS
SELECT
    c.customer_id,
    c.name,
    SUM(oi.quantity*oi.price) AS Lifetime_Value
FROM Customers c
JOIN Orders o ON c.customer_id=o.customer_id
JOIN Order_Items oi ON o.order_id=oi.order_id
GROUP BY c.customer_id,c.name;

SELECT * FROM Customer_Lifetime_Value;

-- ============================================
-- 14. MATERIALIZED VIEW SIMULATION
-- ============================================
-- 14. MATERIALIZED VIEW SIMULATION

CREATE TABLE IF NOT EXISTS Seller_Sales_Summary AS
SELECT * FROM Seller_Performance;

DROP PROCEDURE IF EXISTS Refresh_Seller_Summary;

DELIMITER //

CREATE PROCEDURE Refresh_Seller_Summary()
BEGIN
    SET SQL_SAFE_UPDATES = 0;
    
    DELETE FROM Seller_Sales_Summary;
    
    INSERT INTO Seller_Sales_Summary
    SELECT * FROM Seller_Performance;
    
    SET SQL_SAFE_UPDATES = 1;
END //

DELIMITER ;

CALL Refresh_Seller_Summary();

SELECT * FROM Seller_Sales_Summary;


-- ============================================
-- 15. WINDOW FUNCTION: RANK TOP 3 PRODUCTS
-- ============================================

SELECT *
FROM (
    SELECT
        p.product_name,
        p.category,
        SUM(oi.quantity*oi.price) AS Revenue,
        RANK() OVER(
            PARTITION BY p.category
            ORDER BY SUM(oi.quantity*oi.price) DESC
        ) AS Product_Rank
    FROM Products p
    JOIN Order_Items oi ON p.product_id=oi.product_id
    GROUP BY p.product_id,p.product_name,p.category
) AS Ranked
WHERE Product_Rank<=3;

-- ============================================
-- 16. WINDOW FUNCTION: LAG
-- ============================================

WITH MonthlySales AS (
    SELECT
        DATE_FORMAT(o.order_date,'%Y-%m') AS Month,
        SUM(oi.quantity*oi.price) AS Revenue
    FROM Orders o
    JOIN Order_Items oi ON o.order_id=oi.order_id
    GROUP BY Month
)
SELECT
    Month,
    Revenue,
    LAG(Revenue) OVER(ORDER BY Month)
        AS Previous_Month,
    Revenue-LAG(Revenue) OVER(ORDER BY Month)
        AS Sales_Growth
FROM MonthlySales;

-- ============================================
-- 17. THREE MONTH MOVING AVERAGE
-- ============================================

WITH MonthlySales AS (
    SELECT
        DATE_FORMAT(o.order_date,'%Y-%m') AS Month,
        SUM(oi.quantity*oi.price) AS Revenue
    FROM Orders o
    JOIN Order_Items oi ON o.order_id=oi.order_id
    GROUP BY Month
)
SELECT
    Month,
    Revenue,
    AVG(Revenue) OVER(
        ORDER BY Month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS Moving_Average
FROM MonthlySales;

-- ============================================
-- 18. NTILE: CUSTOMER SPENDING QUARTILES
-- ============================================

SELECT
    customer_id,
    name,
    Total_Spending,
    NTILE(4) OVER(
        ORDER BY Total_Spending DESC
    ) AS Spending_Quartile
FROM (
    SELECT
        c.customer_id,
        c.name,
        COALESCE(SUM(oi.quantity*oi.price),0)
            AS Total_Spending
    FROM Customers c
    LEFT JOIN Orders o ON c.customer_id=o.customer_id
    LEFT JOIN Order_Items oi ON o.order_id=oi.order_id
    GROUP BY c.customer_id,c.name
) AS Customer_Spending;

-- ============================================
-- 19. FINAL VERIFICATION
-- ============================================

SELECT DATABASE();
SHOW TABLES;

SELECT * FROM Seller_Sales_Summary;
SELECT * FROM Seller_Performance;
SELECT * FROM Customer_Lifetime_Value;

-- PROJECT COMPLETED
