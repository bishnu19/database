-- CS3810: Principles of Database Systems
-- Instructor: Thyago Mota
-- Description: The orders database

CREATE DATABASE orders;

\c orders

CREATE TABLE Products (
    id SERIAL PRIMARY KEY, 
    descr VARCHAR(25) NOT NULL, 
    price DECIMAL(10, 2) NOT NULL, 
    CHECK (price >= 0)
);

INSERT INTO Products (descr, price) VALUES 
    ('Ninja Sword', 250.00),
    ('Dummy', 50.00), 
    ('Fake Blood', 5.00),
    ('Rubber Ducky', 1.00), 
    ('Bathtub Soap', 3.00), 
    ('Brazilian Coffee', 5.00), 
    ('Running Shoes', 50.00);

INSERT INTO Products (descr, price) VALUES 
    ('MacBookPro', -2000);

CREATE TABLE Orders (
    number INT PRIMARY KEY, 
    date DATE NOT NULL
);

INSERT INTO Orders VALUES 
    (101, '2020-09-12'),
    (202, '2021-09-27'),
    (303, '2021-09-30'), 
    (404, '2021-10-12');

CREATE TABLE Items (
    order_number INT NOT NULL, 
    product_id INT NOT NULL, 
    qtt INT NOT NULL, 
    PRIMARY KEY (order_number, product_id), 
    FOREIGN KEY (order_number) REFERENCES Orders(number), 
    FOREIGN KEY (product_id) REFERENCES Products(id)
);

CREATE FUNCTION check_qtt_before_insert() RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
        BEGIN
            IF NEW.qtt <=0 THEN
                NEW.qtt = 1;
            END IF;
            RETURN NEW;
        END;
    $$;


CREATE TRIGGER items_qtt_at_least_1
    BEFORE INSERT ON Items
    FOR EACH ROW
    EXECUTE PROCEDURE check_qtt_before_insert();

