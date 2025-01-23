--
-- Table structure for table `employee`
--
CREATE TABLE employee (
  employee_id INT(255) AUTO_INCREMENT,
  last_name VARCHAR(30) NOT NULL,
  first_name VARCHAR(30) NOT NULL,
  sin INT(9) UNSIGNED NOT NULL,
  phone INT(10) UNSIGNED NOT NULL,
  `role` VARCHAR(20) NOT NULL, -- ROLE is a SQL keyword so for safety we surround it with backticks explicitly telling our DBMS we are using this as an column identifier instead of a keyword
  PRIMARY KEY (employee_id)
);
ALTER TABLE employee AUTO_INCREMENT=110;

--
-- Dumping data for table `employee`
--
INSERT INTO employee (last_name, first_name, sin, phone, `role`) VALUES
('Maracle', 'James', 123456789, 4165551234, 'Manager'),
('Marquis', 'Henry', 987654321, 4165551235, 'Sales'),
('Kaur', 'Jas', 456123789, 4165551236, 'Sales'),
('Neema', 'Hank', 654987321, 4165551237, 'Assistant'),
('Said', 'Farud', 258741369, 4165551238, 'Sales'),
('Fitzpatrick', 'Henry', 753951842, 4165551239, 'Stock'),
('Chovey', 'Ann', 453911842, 2895551230, 'Sales'),
('Bugg', 'Aida', 953951999, 4169998888, 'Stock'),
('Legge', 'Scout', 75396789, 4168082034, 'Sales'),
('Shin', 'Ray', 753922344, 4165232456, 'Stock');

-- --------------------------------------------------------

--
-- Table structure for table stock_item
--
CREATE TABLE stock_item (
  stock_item_id SMALLINT(5) AUTO_INCREMENT,
  item VARCHAR(30) NOT NULL,
  price DECIMAL(10,0) NOT NULL,
  inventory SMALLINT(4) NOT NULL,
  category VARCHAR(7) NOT NULL,
  PRIMARY KEY (stock_item_id)
);
ALTER TABLE stock_item AUTO_INCREMENT=1001;

--
-- Dumping data for table `stock_item`
--
INSERT INTO stock_item (item, price, inventory, category) VALUES
  ('Luxury dog bed', 95, 2, 'Canine'),
  ('Super size chew toy', 15, 45, 'Canine'),
  ('Water dish', 87, 11, 'Feline'),
  ('Fish bowl starter kit', 46, 22, 'Piscine'),
  ('Luxury cat bed', 89, 0, 'Feline'),
  ('Just as good dog bed', 74, 14, 'Canine'),
  ('Deluxe Aquarium', 12, 10, 'Piscine'),
  ('Terrarium', 231, 24, 'Murine'),
  ('Cat stand', 55, 6, 'Feline'),
  ('Premium Terrarium', 524, 2, 'Murine'),
  ('Water dish', 10, 88, 'Canine'),
  ('Giant clam aerator', 15, 12, 'Piscine'),
  ('Small cage', 20, 26, 'Murine'),
  ('Small chew toy', 6, 123, 'Canine'),
  ('Collar', 12, 65, 'Feline'),
  ('Collar', 15, 87, 'Canine'),
  ('Air pump', 18, 36, 'Piscine'),
  ('Hamster tubes', 65, 12, 'Murine'),
  ('Large cage', 30, 11, 'Murine'),
  ('Leash', 18, 88, 'Canine');
