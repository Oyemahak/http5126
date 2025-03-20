--  LAB 9 Views & Triggers
--  Put your answers on the lines after each letter. E.g. your query for question 1A should go on line 5; your query for question 1B should go on line 7...
--  1 
-- A 
CREATE VIEW stock_item_under_twenty AS
SELECT category, name, inventory
FROM stock_item
WHERE inventory <= 20;
-- B 
SELECT * FROM stock_item_under_twenty;
-- C 
SELECT * FROM stock_item_under_twenty WHERE inventory = 0;


--  2 
-- A 
CREATE VIEW sale_total_by_employee AS
SELECT CONCAT(e.first_name, ' ', e.last_name) AS employee_name, SUM(si.price) AS `Total Sales ($)`
FROM employee e
JOIN sale s ON e.employee_id = s.employee_id 
JOIN stock_item si ON s.stock_item_id = si.stock_item_id
GROUP BY e.employee_id
ORDER BY `Total Sales ($)` DESC;
-- B 
SELECT * FROM sale_total_by_employee;
-- C 
SELECT * FROM sale_total_by_employee 
WHERE `Total Sales ($)` > 1000;

--  3 
-- A 
DELIMITER //
CREATE TRIGGER deduct_inventory_on_sale AFTER INSERT ON sale FOR EACH ROW
BEGIN
    UPDATE stock_item
    SET inventory = inventory - 1
    WHERE stock_item_id = NEW.stock_item_id;
END//
DELIMITER ;

-- B 
INSERT INTO sale (sale_id, stock_item_id, employee_id, date) VALUES (22000, 1501, 150, NOW());

-- C 
INSERT INTO sale (sale_id, stock_item_id, employee_id, date) VALUES (22001, (SELECT stock_item_id FROM stock_item WHERE name = 'Luxury cat bed'),151, NOW());

-- Explaination: -- The error occurs because the 'Luxury cat bed' (stock_item_id = 1005) has an inventory of 0 in the stock_item table.
                -- When the trigger deducts 1 from the inventory, it results in -1, violating the constraint that inventory cannot be negative.

--  4 
-- A 
CREATE TRIGGER log_insert_stock_item
AFTER INSERT ON stock_item
FOR EACH ROW
INSERT INTO stock_item_log (action, stock_item_id, timestamp)
VALUES ('Insert', NEW.stock_item_id, NOW());
-- B 
CREATE TRIGGER log_update_stock_item
BEFORE UPDATE ON stock_item
FOR EACH ROW
INSERT INTO stock_item_log (action, stock_item_id, old_name, old_price, old_inventory, old_category, timestamp)
VALUES ('Update', OLD.stock_item_id, OLD.name, OLD.price, OLD.inventory, OLD.category, NOW());

-- C 
CREATE TRIGGER log_delete_stock_item
BEFORE DELETE ON stock_item
FOR EACH ROW
INSERT INTO stock_item_log (action, stock_item_id, old_name, old_price, old_inventory, old_category, timestamp)
VALUES ('Delete', OLD.stock_item_id, OLD.name, OLD.price, OLD.inventory, OLD.category, NOW());

--  5
-- Run the queries in part A below before completing part 5B. 
-- Place your part 5 query below these queries where part B is indicated. 
-- Ensure these queries are included in your submission.
--
-- A
INSERT INTO stock_item (name, price, inventory, category) 
  VALUES ('Bad dog bed', '95', 2, 'Canine');
DELETE FROM stock_item 
  WHERE name = 'Bad dog bed';
INSERT INTO stock_item (name, price, inventory, category) 
  VALUES('Tiny size chew toy', 5, 5, 'Canine'),
  ('Huge water dish', 99, 18, 'Feline'),
  ('Fish bowl expert kit', 88, 11, 'Piscine'),
  ('Luxury cat collar', 150, 10, 'Feline');
UPDATE stock_item
  SET inventory = 0
  WHERE name = 'Luxury cat collar';
DELETE FROM stock_item
  WHERE inventory = 0;
UPDATE stock_item
  SET category = 'Cat'
  WHERE category = 'Feline';
INSERT INTO sale (`date`, stock_item_id, employee_id)
  VALUES (NOW(), 1008, 114);
INSERT INTO sale (`date`, stock_item_id, employee_id)
  VALUES (NOW(), 1005, 111);
-- B
SELECT * FROM stock_item_log WHERE stock_item_id = 1025;