--  LAB 2 ACCESSING DATA PART 1
--  Put your answers on the lines after each letter. E.g. your query for question 1A should go on line 6; your query for question 1B should go on line 8...

--  1 
-- A 
SELECT * FROM employee;
-- B 
SELECT * FROM stock_item;

--  2
-- A 
SELECT item, price FROM stock_item;
-- B
SELECT first_name, last_name, role, phone FROM employee;

--  3
-- A
SELECT item AS 'Product', category AS 'Animal' FROM stock_item;
-- B
SELECT last_name AS 'Pet Store Staff', employee_id AS 'Emp. ID', sin AS 'SIN' FROM employee;

--  4
-- A
SELECT first_name, phone FROM employee WHERE role = 'Sales';
-- B
SELECT item, stock_item_id, inventory FROM stock_item WHERE inventory <= 12;

--  5
-- A
SELECT item AS 'Kitty Cat', price FROM stock_item WHERE category = 'Feline';
-- B
SELECT CONCAT(first_name, ' ', last_name) AS 'Staff Member' FROM employee WHERE employee_id = 115;