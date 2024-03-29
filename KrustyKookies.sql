-- Delete the tables if they exist.
-- Disable foreign key checks, so the tables can
-- be dropped in arbitrary order.
PRAGMA foreign_keys=OFF;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS RawMaterials;
DROP TABLE IF EXISTS RawDeliveries;
DROP TABLE IF EXISTS Recipes;
DROP TABLE IF EXISTS Ingredients;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Pallets;
DROP TABLE IF EXISTS Shipments;
DROP TABLE IF EXISTS AmountOrdered;

PRAGMA foreign_keys=ON;

-- Create the tables.
CREATE TABLE Customers (
  customer_name      TEXT,
  address            TEXT NOT NULL,
  PRIMARY KEY (customer_name)
);

CREATE TABLE RawMaterials (
  material_name      TEXT,
  material_amount    REAL CHECK (material_amount >= 0),
  unit               VARCHAR(10) NOT NULL,
  PRIMARY KEY (material_name)
);

CREATE TABLE RawDeliveries (
  delivery_date         DATE,
  material_name         TEXT,
  delivery_amount       INTEGER CHECK (delivery_amount >= 0),
  PRIMARY KEY (delivery_date, material_name),
  FOREIGN KEY (material_name) REFERENCES RawMaterials(material_name)
);

CREATE TABLE Recipes (
  recipe_name    TEXT,
  PRIMARY KEY (recipe_name)
);

CREATE TABLE Ingredients (
  material_name    TEXT,
  recipe_name      TEXT,
  quantity         REAL CHECK (quantity > 0),
  PRIMARY KEY (material_name, recipe_name),
  FOREIGN KEY (material_name) REFERENCES RawMaterials(material_name),
  FOREIGN KEY (recipe_name) REFERENCES Recipes(recipe_name)
);

CREATE TABLE Orders (
  order_id          INTEGER PRIMARY KEY,
  customer_name     TEXT,
  delivery_by_date  DATE NOT NULL,
  FOREIGN KEY (customer_name) REFERENCES Customers(customer_name)
);

CREATE TABLE AmountOrdered (
  order_id          INTEGER,
  recipe_name       TEXT,
  amount            INTEGER CHECK (amount > 0),
  PRIMARY KEY (order_id, recipe_name),
  FOREIGN KEY (order_id) REFERENCES Orders(order_id),
  FOREIGN KEY (recipe_name) REFERENCES Recipes(recipe_name)
);

CREATE TABLE Pallets (
  pallet_id       INTEGER PRIMARY KEY,
  location        TEXT NOT NULL,
  production_date DATE NOT NULL,
  blocked         BOOLEAN,
  recipe_name     TEXT,
  FOREIGN KEY (recipe_name) REFERENCES Recipes(recipe_name)
);

CREATE TABLE Shipments (
  order_id          INTEGER,
  pallet_id         INTEGER,
  date_of_delivery  DATE,
  PRIMARY KEY (order_id, pallet_id),
  FOREIGN KEY (pallet_id) REFERENCES Pallets(pallet_id),
  FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Insert data into the tables.
INSERT INTO Customers (customer_name, address) VALUES
('Finkakor AB', 'Helsingborg'),
('Småbröd AB', 'Malmö'),
('Kaffebröd AB', 'Landskrona'),
('Bjudkakor AB', 'Ystad'),
('Klaskakor AB', 'Trelleborg'),
('Partykakor AB', 'Kristianstad'),
('Gästkakor AB', 'Hässleholm'),
('Skånekakor AB', 'Perstorp');

INSERT INTO RawMaterials (material_name, material_amount, unit) VALUES
('Flour', 450000, 'g'),
('Butter', 450000, 'g'),
('Icing sugar', 190000, 'g'),
('Roasted, chopped nuts', 225000, 'g'),
('Fine-ground nuts', 0, 'g'),
('Ground, roasted nuts', 0, 'g'),
('Bread crumbs', 0, 'g'),
('Sugar', 0, 'g'),
('Egg whites', 0, 'dl'),
('Chocolate', 0, 'g'),
('Marzipan', 0, 'g'),
('Eggs', 0, 'g'),
('Potato starch', 0, 'g'),
('Wheat flour', 0, 'g'),
('Sodium bicarbonate', 0, 'g'),
('Vanilla', 0, 'g'),
('Chopped almonds', 0, 'g'),
('Cinnamon', 0, 'g'),
('Vanilla sugar', 0, 'g');

INSERT INTO Recipes (recipe_name) VALUES
('Nut ring'),
('Nut cookie'),
('Amneris'),
('Tango'),
('Almond delight'),
('Berliner');

INSERT INTO Ingredients (recipe_name, material_name, quantity) VALUES
('Nut ring', 'Flour', 450),
('Nut ring', 'Butter', 450),
('Nut ring', 'Icing sugar', 190),
('Nut ring', 'Roasted, chopped nuts', 225),
('Nut cookie', 'Fine-ground nuts', 750),
('Nut cookie', 'Ground, roasted nuts', 625),
('Nut cookie', 'Bread crumbs', 125),
('Nut cookie', 'Sugar', 375),
('Nut cookie', 'Egg whites', 3.5),
('Nut cookie', 'Chocolate', 50),
('Amneris', 'Marzipan', 750),
('Amneris', 'Butter', 250),
('Amneris', 'Eggs', 250),
('Amneris', 'Potato starch', 25),
('Amneris', 'Wheat flour', 25),
('Tango', 'Butter', 200),
('Tango', 'Sugar', 250),
('Tango', 'Flour', 300),
('Tango', 'Sodium bicarbonate', 4),
('Tango', 'Vanilla', 2),
('Almond delight', 'Butter', 400),
('Almond delight', 'Sugar', 270),
('Almond delight', 'Chopped almonds', 279),
('Almond delight', 'Flour', 400),
('Almond delight', 'Cinnamon', 10),
('Berliner', 'Flour', 350),
('Berliner', 'Butter', 250),
('Berliner', 'Icing sugar', 100),
('Berliner', 'Eggs', 50),
('Berliner', 'Vanilla sugar', 5),
('Berliner', 'Chocolate', 50);

INSERT INTO RawDeliveries (delivery_date, material_name, delivery_amount) VALUES
('2017-03-20 07:00:00', 'Flour', 450000),
('2017-03-20 07:00:00', 'Butter', 450000),
('2017-03-20 07:00:00', 'Icing sugar', 190000),
('2017-03-21 07:00:00', 'Roasted, chopped nuts', 500000);

INSERT INTO Pallets (location, production_date, blocked, recipe_name) VALUES
('Deep-freeze storage', '2017-03-20 08:25:30', 0, 'Nut ring'),
('Deep-freeze storage', '2017-03-20 08:25:30', 0, 'Nut ring'),
('Deep-freeze storage', '2017-03-21 13:55:04', 0, 'Tango'),
('Deep-freeze storage', '2017-03-19 15:50:50', 1, 'Tango'),
('Deep-freeze storage', '2017-03-19 01:01:01', 1, 'Tango');

INSERT INTO Orders (customer_name, delivery_by_date) VALUES
('Finkakor AB', '2017-04-23 15:00:00'),
('Småbröd AB', '2017-04-24 15:00:00');

INSERT INTO AmountOrdered (order_id, recipe_name, amount) VALUES
(1, 'Tango', 10),
(1, 'Berliner', 6),
(2, 'Nut ring', 2);
-- And re-enable foreign key checks.

PRAGMA foreign_key = on;
