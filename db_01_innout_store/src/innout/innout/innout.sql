-- CS3810: Principles of Database Systems
-- Instructor: Thyago Mota
-- Student(s): Bishnu Bhusal & Gaulochan Pradhan
-- Description: SQL for the In-N-Out Store

DROP DATABASE innout;

CREATE DATABASE innout;

\c innout

-- TODO: table create statements

-- CREATE TABLE Customers
CREATE TABLE Customers (
    id SERIAL PRIMARY KEY, 
    name VARCHAR(50) NOT NULL, 
    gender CHAR(1) DEFAULT '?'
);

-- Create table Items
CREATE TABLE Items (
    code NUMERIC PRIMARY KEY, 
    description VARCHAR(100),
    current_price DECIMAL(6,2),
    cate_code CHAR(3),
    cat_description VARCHAR(100)
);

--create table Transactions 
CREATE TABLE Transactions (
    customer_id INT, 
    item_code NUMERIC, 
    quantity INT NOT NULL, 
    sale_price DECIMAL(6,2) NOT NULL, 
    date DATE NOT NULL,
    time TIME NOT NULL,
    PRIMARY KEY(customer_id,item_code,time),
    FOREIGN KEY (customer_id) REFERENCES Customers(id),
    FOREIGN KEY(item_code) REFERENCES Items(code)
);
-- TODO: table insert statements
-- Insert into Customers 
INSERT INTO Customers(name,gender) VALUES 
('David Baccam','M'),
('Jennifer Flores','F'),
('Shayam Risal','M');

INSERT INTO Customers(name) VALUES 
('Trisala Shrestha');

INSERT INTO Customers(name,gender) VALUES 
('Milan Pandey','M'),
('Sunil Gurung','M');

-- Insert into Items 
INSERT INTO Items VALUES 
(12345,'Whole milk',4.99,'DRY','dairy'),
(12346,'Chocolate donut',2.39,'BKY','bakery'),
(12347,'Chicken meat',2.99,'MEA','Meat');

INSERT INTO Items VALUES 
(12348,'Fresh coffee',3.99,'BVR','beverages'),
(12349,'M & M Candy',2.49,'CAN','Candy'),
(12350,'Fresh Red Apple',1.29,'PRD','produce');

INSERT INTO Items VALUES 
(12351,'Burrito',3.49,'FRZ','frozen'),
(12352,'Glazed donut',1.29,'BKY','bakery');

-- INSERT AN ITEM WITH OUT ITS CATEGORY
INSERT INTO Items(code,description,current_price) VALUES 
(12353,'Chewing gum',1.79),
(12354,'Melting gum',5.99);

-- A catagory without an item
INSERT INTO Items(code,cate_code,cat_description) VALUES 
(12355,'ATP','Auto parts');

INSERT INTO Items(code,cate_code,cat_description) VALUES 
(12356,'ELT','Electronics');




-- Insert into Transactions
INSERT INTO Transactions VALUES 
(1,12345,2,4.29,'2022-10-12','09:10:16');

INSERT INTO Transactions VALUES 
(2,12346,5,2.29,'2023-05-12','14:10:18');

-- Insert more data
INSERT INTO Transactions VALUES 
(3,12347,1,4.29,'2022-10-15','07:10:20'),
(3,12348,5,1.29,'2022-10-15','07:10:20'),
(4,12349,3,5.29,'2023-10-15','10:10:20'),
(4,12350,1,2.59,'2023-10-15','10:10:20'),
(2,12351,10,1.99,'2023-03-14','15:11:05'),
(1,12348,1,1.29,'2023-02-10','09:30:20'),
(3,12347,3,3.29,'2023-02-12','06:19:40');

INSERT INTO Transactions VALUES 
(2,12346,2,2.59,'2023-05-19','08:11:40');

INSERT INTO Transactions VALUES 
(3,12351,5,2.00,'2023-02-15','10:43:11');

INSERT INTO Transactions VALUES 
(4,12351,3,2.29,'2023-02-15','11:36:22'),
(1,12351,1,2.29,'2023-02-16','14:30:02');

INSERT INTO Transactions VALUES 
(3,12347,4,3.29,'2023-02-14','07:10:50');


-- TODO: SQL queries

-- a) all customer names in alphabetical order
SELECT name FROM Customers ORDER BY 1;

-- b) number of items (labeled as total_items) in the database 
SELECT COUNT(*) AS total_items FROM Items;

-- c) number of customers (labeled as number_customers) by gender
SELECT gender, COUNT(gender) AS number_customers FROM Customers GROUP BY gender;

-- d) a list of all item codes (labeled as code) and descriptions (labeled as description) followed by their category descriptions (labeled as category) in numerical order of their codes (items that do not have a category should not be displayed)
SELECT A.code, A.description, A.cat_description AS category FROM Items A
LEFT JOIN Transactions B
ON A.code = B.item_code WHERE A.cate_code IS NOT NULL ORDER BY 1;

-- Below are the distinct items
SELECT DISTINCT A.code, A.description, A.cat_description AS category FROM Items A
LEFT JOIN Transactions B
ON A.code = B.item_code WHERE A.cate_code IS NOT NULL ORDER BY 1;

-- e) a list of all item codes (labeled as code) and descriptions (labeled as description) in numerical order of their codes for the items that do not have a category
SELECT code, description FROM Items WHERE cate_code IS NULL ORDER BY 1;

-- f) a list of the category descriptions (labeled as category) that do not have an item in alphabetical order
SELECT cat_description AS catagory FROM Items WHERE description IS NULL ORDER BY 1;

-- g) set a variable named "ID" and assign a valid customer id to it; then show the content of the variable using a select statement
\set ID 1
SELECT id FROM Customers WHERE id=:ID;

-- h) a list describing all items purchased by the customer identified by the variable "ID" (you must used the variable), showing, the date of the purchase (labeled as date), the time of the purchase (labeled as time and in hh:mm:ss format), the item's description (labeled as item), the quantity purchased (labeled as qtt), the item price (labeled as price), and the total amount paid (labeled as total_paid).
\set ID 1
SELECT date, time, description AS item, quantity AS qtt, sale_price AS price, (sale_price * quantity) AS total_paid FROM Items 
INNER JOIN Transactions 
ON Items.code = Transactions.item_code AND Transactions.customer_id=:ID;

-- i) the total amount of sales per day showing the date and the total amount paid in chronological order
SELECT date, SUM(sale_price*quantity) AS Total  FROM Transactions GROUP BY date ORDER BY date;

-- j) the description of the top item (labeled as item) in sales with the total sales amount (labeled as total_paid)
-- Items with highest price paid.
SELECT Items.description AS item, SUM(sale_price * quantity) AS total_paid FROM Items 
INNER JOIN Transactions
ON Items.code = Transactions.item_code  GROUP BY Items.code ORDER BY total_paid DESC LIMIT 1;

-- k) the descriptions of the top 3 items (labeled as item) in number of times they were purchased, showing that quantity as well (labeled as total)
SELECT Items.description AS item, SUM(Transactions.quantity) AS total FROM Items 
INNER JOIN Transactions
ON Items.code = Transactions.item_code  GROUP BY Items.code ORDER BY COUNT(Items.code) DESC LIMIT 3;

-- another way
SELECT A.description AS item, SUM(B.quantity) AS total
FROM Items A 
INNER JOIN Transactions B 
ON A.code = B.item_code GROUP BY A.Description 
ORDER BY SUM(B.quantity) DESC  
LIMIT 3;


-- l) the name of the customers who never made a purchase 
SELECT A.name FROM Customers A 
LEFT JOIN Transactions B 
ON A.id = B.customer_id WHERE B.customer_id IS NULL;