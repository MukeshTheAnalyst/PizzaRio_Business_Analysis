
-- PizzaRio Business Analysis - Part 1
-- Design Database 

----------------------------------------------------------
----------------------------------------------------------

-- 1. Create Database

CREATE DATABASE PizzaRio;
GO

USE PizzaRio;
GO

----------------------------------------------------------
----------------------------------------------------------

-- 2. Create Tables (Assign Primary Key, UNIQUE, NULL)

-- Table: orders
CREATE TABLE orders (
    row_id smallint NOT NULL PRIMARY KEY,
    order_id tinyint NOT NULL,
    created_at datetime2 NOT NULL,
    item_id nvarchar(50) NOT NULL,
    quantity tinyint NOT NULL,
    cust_id tinyint NOT NULL,
    delivery bit NOT NULL,
    add_id tinyint NOT NULL
);
-- Table: ingredient
CREATE TABLE ingredient (
    ing_id nvarchar(50) NOT NULL PRIMARY KEY,
    ing_name nvarchar(50) NOT NULL,
    ing_weight smallint NOT NULL,
    ing_meas nvarchar(50) NOT NULL,
    ing_price float NOT NULL
);

-- Table: inventory
CREATE TABLE inventory (
    inv_id tinyint NOT NULL PRIMARY KEY,
    item_id nvarchar(50) NOT NULL UNIQUE,  -- UNIQUE entry
    quantity tinyint NOT NULL
);

-- Table: item
CREATE TABLE item (
    item_id nvarchar(50) NOT NULL PRIMARY KEY,
    sku nvarchar(50) NOT NULL UNIQUE,  -- UNIQUE entry
    item_name nvarchar(50) NOT NULL,
    item_cat nvarchar(50) NOT NULL,
    item_size nvarchar(50) NOT NULL,
    item_price tinyint NOT NULL
);

-- Table: recipe
CREATE TABLE recipe (
    row_id tinyint NOT NULL PRIMARY KEY,
    recipe_id nvarchar(50) NOT NULL,
    ing_id nvarchar(50) NOT NULL,
    quantity smallint NOT NULL
);

-- Table: customers
CREATE TABLE customers (
    cust_id tinyint NOT NULL PRIMARY KEY,
    cust_firstname nvarchar(50) NOT NULL,
    cust_lastname nvarchar(50) NOT NULL
);

-- Table: address
CREATE TABLE address (
    add_id tinyint NOT NULL PRIMARY KEY,
    delivery_address1 nvarchar(50) NOT NULL,
    delivery_address2 nvarchar(50) NULL,  -- ONLY NULLABLE COLUMN
    delivery_city nvarchar(50) NOT NULL,
    delivery_zipcode smallint NOT NULL
);

-- Table: orders
CREATE TABLE orders (
    row_id smallint NOT NULL PRIMARY KEY,
    order_id tinyint NOT NULL,
    created_at datetime2 NOT NULL,
    item_id nvarchar(50) NOT NULL,
    quantity tinyint NOT NULL,
    cust_id tinyint NOT NULL,
    delivery bit NOT NULL,
    add_id tinyint NOT NULL
);

-- Table: shifts
CREATE TABLE shifts (
    shift_id nvarchar(50) NOT NULL PRIMARY KEY,
    day_of_week nvarchar(50) NOT NULL,
    start_time time NOT NULL,
    end_time time NOT NULL
);

-- Table: rota
CREATE TABLE rota (
    row_id tinyint NOT NULL PRIMARY KEY,
    rota_id nvarchar(50) NOT NULL,
    date date NOT NULL,
    shift_id nvarchar(50) NOT NULL,
    staff_id nvarchar(50) NOT NULL
);

-- Table: staff
CREATE TABLE staff (
    staff_id nvarchar(50) NOT NULL PRIMARY KEY,
    first_name nvarchar(50) NOT NULL,
    last_name nvarchar(50) NOT NULL,
    position nvarchar(50) NOT NULL,
    hourly_rate float NOT NULL
);


----------------------------------------------------------
----------------------------------------------------------

-- 3. Define Relationships Among Tables (Assign Foreign Key)

-- orders.item_id → item.item_id
ALTER TABLE orders
ADD CONSTRAINT FK_orders_item FOREIGN KEY (item_id) REFERENCES item(item_id);

-- orders.cust_id → customers.cust_id
ALTER TABLE orders
ADD CONSTRAINT FK_orders_customers FOREIGN KEY (cust_id) REFERENCES customers(cust_id);

-- orders.add_id → address.add_id
ALTER TABLE orders
ADD CONSTRAINT FK_orders_address FOREIGN KEY (add_id) REFERENCES address(add_id);

-- recipe.recipe_id → item.sku
ALTER TABLE recipe
ADD CONSTRAINT FK_recipe_itemSku FOREIGN KEY (recipe_id) REFERENCES item(sku);

-- recipe.ing_id → inventory.item_id
ALTER TABLE recipe
ADD CONSTRAINT FK_recipe_inventory FOREIGN KEY (ing_id) REFERENCES inventory(item_id);

-- recipe.ing_id → ingredient.ing_id
ALTER TABLE recipe
ADD CONSTRAINT FK_recipe_ingredient FOREIGN KEY (ing_id) REFERENCES ingredient(ing_id);

-- rota.shift_id → shifts.shift_id
ALTER TABLE rota
ADD CONSTRAINT FK_rota_shift FOREIGN KEY (shift_id) REFERENCES shifts(shift_id);

-- rota.staff_id → staff.staff_id
ALTER TABLE rota
ADD CONSTRAINT FK_rota_staff FOREIGN KEY (staff_id) REFERENCES staff(staff_id);

----------------------------------------------------------
----------------------------------------------------------

-- 4. Insert Data Into Tables from CSV Files

-- ingredient
BULK INSERT ingredient
FROM 'D:\DATA_ANALYSIS\Projects _ In progress\PizzaRio\Files\ingredient.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- staff 
BULK INSERT staff
FROM 'D:\DATA_ANALYSIS\Projects _ In progress\PizzaRio\Files\staff.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- shifts 
BULK INSERT shifts
FROM 'D:\DATA_ANALYSIS\Projects _ In progress\PizzaRio\Files\shifts.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- customers 
BULK INSERT customers
FROM 'D:\DATA_ANALYSIS\Projects _ In progress\PizzaRio\Files\customers.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- address
BULK INSERT address
FROM 'D:\DATA_ANALYSIS\Projects _ In progress\PizzaRio\Files\address.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- item 
BULK INSERT item
FROM 'D:\DATA_ANALYSIS\Projects _ In progress\PizzaRio\Files\item.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- inventory 
BULK INSERT inventory
FROM 'D:\DATA_ANALYSIS\Projects _ In progress\PizzaRio\Files\inventory.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- recipe 
BULK INSERT recipe
FROM 'D:\DATA_ANALYSIS\Projects _ In progress\PizzaRio\Files\recipe.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- rota 
BULK INSERT rota
FROM 'D:\DATA_ANALYSIS\Projects _ In progress\PizzaRio\Files\rota.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- orders 
BULK INSERT orders
FROM 'D:\DATA_ANALYSIS\Projects _ In progress\PizzaRio\Files\orders.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);



----------------------------------------------------------
----------------------------------------------------------

-- 5. Create Calendar Table & Connect Date Fields

-- Change rota.date to rota.rota_date

EXEC sp_rename 'rota.date', 'rota_date', 'COLUMN';

-- Create calender table and import data from .csv file

CREATE TABLE calendar (
    cal_date DATE PRIMARY KEY
);

BULK INSERT calendar
FROM 'D:\DATA_ANALYSIS\Projects _ In progress\PizzaRio\Files\calendar.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);


-- Create seperate date column in orders table

ALTER TABLE orders
ADD order_date AS CONVERT(DATE, created_at) PERSISTED;

-- Create forign keys

ALTER TABLE orders
ADD CONSTRAINT FK_orders_calendar FOREIGN KEY (order_date) REFERENCES calendar(cal_date);

ALTER TABLE rota
ADD CONSTRAINT FK_rota_calendar FOREIGN KEY (rota_date) REFERENCES calendar(cal_date);

----------------------------------------------------------
----------------------------------------------------------


-- Changing datatype for columns which are gong to use in arithmatic calculation
-- as smallint, tinyint are limited. change them to INT

ALTER TABLE orders
ALTER COLUMN quantity INT;

ALTER TABLE item
ALTER COLUMN item_price INT;

ALTER TABLE recipe
ALTER COLUMN quantity INT;

ALTER TABLE ingredient
ALTER COLUMN ing_weight INT;

ALTER TABLE inventory
ALTER COLUMN quantity INT;

----------------------------------------------------------
----------------------------------------------------------

-- 