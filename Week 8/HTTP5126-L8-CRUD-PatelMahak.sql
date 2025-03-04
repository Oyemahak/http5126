--  LAB 8 CRUD
--  Put your answers on the lines after each letter. E.g. your query for question 1A should go on line 6; your query for question 1B should go on line 7...

-- 1 
--  A 
CREATE TABLE customer (
    email VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

--  B 
CREATE TABLE supplier (
    supplier_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL
);

--  C 
CREATE TABLE `order` (
    order_id INT PRIMARY KEY,
    email VARCHAR(255),
    FOREIGN KEY (email) REFERENCES customer(email)
);

--  D
CREATE TABLE product (
    product_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price INT NOT NULL,
    brand VARCHAR(255) NOT NULL,
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id)
);

--  E 
CREATE TABLE order_product (
    order_id INT,
    product_id INT,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES `order`(order_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

-- 2 
--  A 
INSERT INTO customer (email, name) VALUES
('john@gmail.com', 'John'),
('jane@gmail.com', 'Jane'),
('alice@gmail.com', 'Alice');

--  B 
INSERT INTO supplier (supplier_id, name, location) VALUES
(1, 'XYZ Electronics', 'Toronto'),
(2, 'ABC Gadgets', 'Montreal'),
(3, 'XYZ Furniture', 'Vancouver');

--  C 
INSERT INTO `order` (order_id, email) VALUES
(1, 'john@gmail.com'),
(2, 'jane@gmail.com'),
(3, 'john@gmail.com'),
(4, 'alice@gmail.com');

--  D
INSERT INTO product (product_id, name, price, brand, supplier_id) VALUES
(1, 'Laptop', 800, 'Dell', 1),
(2, 'Smartphone', 600, 'Apple', 2),
(3, 'Smartphone', 600, 'Samsung', 2),
(4, 'Camera', 300, 'Canon', 1),
(5, 'Chair', 100, 'Herman Miller', 3);

--  E 
INSERT INTO order_product (order_id, product_id) VALUES
(1, 1),
(2, 2),
(2, 3),
(3, 4),
(4, 5);

-- 3 
--  A 
ALTER TABLE product ADD CONSTRAINT chk_price CHECK (price >= 0);

--  B 
UPDATE order_product
SET product_id = 4
WHERE order_id = 2 AND product_id = 2;

-- 4 
--  A 
DELETE FROM order_product
WHERE order_id IN (SELECT order_id FROM `order` WHERE email = 'john@gmail.com');

--  B 
DELETE FROM `order`
WHERE email = 'john@gmail.com';