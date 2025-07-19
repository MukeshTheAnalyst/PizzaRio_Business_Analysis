
-- PizzaRio Business Analysis - Part 2
-- Write SQL Queries for Each Dashboard &
-- Save Queries as SQL Views

----------------------------------------------------------
----------------------------------------------------------

USE PizzaRio
GO
----------------------------------------------------------
----------------------------------------------------------

-- Query 1 -- Order activity

CREATE VIEW vw_order_activity AS
SELECT
	o.order_id,
	i.item_price,
	o.quantity,
	i.item_cat,
	i.item_name,
	o.created_at,
	a.delivery_address1,
	a.delivery_address2,
	a.delivery_city,
	a.delivery_zipcode,
	o.delivery,
	o.order_date
FROM orders AS o
	JOIN item AS i ON o.item_id = i.item_id
	JOIN address AS a ON o.add_id = a.add_id;
GO

----------------------------------------------------------
----------------------------------------------------------

-- Query 2 -- Inventory management

-- 1 -- Total quantity by ingredients
-- 2 -- total cost of ingredients
-- 3 -- Calculated cost of pizza

CREATE VIEW vw_stock1 AS 
SELECT 
	SQ1.item_name,
	SQ1.ing_id,
	SQ1.ing_name,
	SQ1.ing_weight,
	SQ1.ing_price,
	SQ1.order_quantity,
	SQ1.recipe_quantity,
	SQ1.order_quantity * SQ1.recipe_quantity AS ordered_weight,
	SQ1.ing_price / SQ1.ing_weight AS unit_cost,
	(SQ1.order_quantity * SQ1.recipe_quantity)*(SQ1.ing_price / SQ1.ing_weight) AS ingredient_cost
FROM
(
SELECT
	o.item_id,
	i.sku,
	i.item_name,
	r.ing_id,
	ing.ing_name,
	r.quantity AS recipe_quantity,
	sum(o.quantity) AS order_quantity,
	ing.ing_weight,
	ing.ing_price
FROM orders AS o
	JOIN item AS i ON o.item_id = i.item_id
	JOIN recipe AS r ON i.sku = r.recipe_id
	JOIN ingredient ing ON ing.ing_id = r.ing_id
GROUP BY 
	o.item_id,
	i.sku, 
	i.item_name, 
	r.ing_id, 
	ing.ing_name,
	r.quantity,
	ing.ing_weight, 
	ing.ing_price
) AS SQ1;

GO

-- Query 3 -- Inventory management
-- 4 -- Percentage stock remaining by ingredient
-- 5 -- List of ingredients to reorder based on remaining inventory

-- a -- Total weight ordered
-- b -- Inventory amount
-- c -- Inventory remaining per ingredient

CREATE VIEW vw_inventory AS
SELECT
	SQ2.ing_name,
	SQ2.ordered_weight,
	ing.ing_weight * inv.quantity AS total_inv_weight,
	(ing.ing_weight * inv.quantity) - SQ2.ordered_weight AS remaining_weight
FROM
(
SELECT
	ing_id,
	ing_name,
	sum(ordered_weight) as ordered_weight
FROM vw_stock1
GROUP BY
	ing_id, ing_name
) AS SQ2

JOIN inventory AS inv ON inv.item_id = SQ2.ing_id
JOIN ingredient AS ing ON ing.ing_id = SQ2.ing_id;

GO

----------------------------------------------------------
----------------------------------------------------------

-- Query 4 -- Staff management
-- 1 -- which staff members are working when
-- 2 -- Based on the staff salary information, how much each pizza costs (ingredients + chefs + delivery)

CREATE VIEW vw_staff AS
SELECT
	r.rota_date,
	s.first_name,
	s.last_name,
	s.hourly_rate,
	CONVERT(varchar(8), start_time, 108) AS start_time,
	CONVERT(varchar(8), end_time, 108) AS end_time,
	(DATEDIFF(MINUTE, start_time, end_time) / 60.0) AS shift_hours,
	((DATEDIFF(MINUTE, start_time, end_time) / 60.0) * s.hourly_rate) AS staff_cost
FROM rota AS r
JOIN staff AS s ON r.staff_id = s.staff_id
JOIN shifts AS sh ON r.shift_id = sh.shift_id; 

GO

----------------------------------------------------------
----------------------------------------------------------