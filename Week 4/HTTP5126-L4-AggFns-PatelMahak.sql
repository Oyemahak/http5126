-- LAB 4 AGGREGATE FUNCTIONS

-- 1
-- A
SELECT MIN(price) AS 'Lowest Price' FROM stock_item;

-- B
SELECT MAX(inventory) AS 'Greatest Quantity' FROM stock_item;

-- C
SELECT AVG(price) AS 'Average Price' FROM stock_item;

-- D
SELECT SUM(inventory) AS 'Total Inventory' FROM stock_item;


-- 2
-- A
SELECT role, COUNT(*) AS 'Employee Count' FROM employee GROUP BY role;

-- B
SELECT category AS 'Mammals', COUNT(*) AS 'Item Count' FROM stock_item 
WHERE category <> 'Piscine' GROUP BY category;

-- C
SELECT category, AVG(price) AS 'Average Price ($)' FROM stock_item 
WHERE inventory > 0 GROUP BY category;


-- 3
-- A
SELECT SUM(inventory) AS 'In Stock', category AS 'Species' FROM stock_item 
GROUP BY category ORDER BY SUM(inventory) ASC;

-- B
SELECT category AS 'Species', SUM(inventory) AS 'Total Stock', AVG(price) AS 'Average Price'
FROM stock_item GROUP BY category 
HAVING SUM(inventory) < 100 AND AVG(price) < 100;


-- 4
-- A
SELECT item AS 'Product', 
       CONCAT('$', FORMAT(price, 2)) AS 'Price', 
       inventory AS 'Stock Remaining', 
       category AS 'Species', 
       CONCAT('$', FORMAT(price * inventory, 2)) AS 'Potential Earnings'
FROM stock_item 
ORDER BY (price * inventory) DESC;
