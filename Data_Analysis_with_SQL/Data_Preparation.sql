-- Profiling Data
-- 1. Distributions
-- 1.1. Histograms // Frequencies 
-- (GROUP BY)

-- 1.2. Binning 
-- Arbitrary-sized Bin (CASE WHEN)
WITH total AS (
	SELECT	order_id,
			SUM(quantity) AS total_demand,
			CASE
				WHEN SUM(list_price) <= 2000 THEN '0 - 2000'
				WHEN SUM(list_price) <= 4000 THEN '2000 - 4000'
				WHEN SUM(list_price) <= 6000 THEN '4000 - 6000'
				WHEN SUM(list_price) <= 8000 THEN '6000 - 8000'
				WHEN SUM(list_price) <= 10000 THEN '8000 - 10000'	
				ELSE 'More than 10000' END AS payment_range
	FROM	sales.order_items
	GROUP BY order_id
	)
SELECT	payment_range,
		COUNT(order_id) AS num_of_orders 
FROM	total
GROUP BY payment_range
ORDER BY payment_range ASC;

-- Fixed Size
-- ROUND()

-- LOG()

-- NTILE(num_of_bins) OVER (PARTITION BY field_name  ORDER BY  field_name)
SELECT	bins,
		MIN(order_amount) AS lower_bound,
		MAX(order_amount) AS upper_bound,
		COUNT(order_id)	AS num_of_orders
FROM	(
		SELECT	ord.customer_id, ord.order_id,
			SUM(ite.list_price) AS order_amount,
			NTILE(10) OVER (ORDER BY SUM(ite.list_price)) AS bins
		FROM	sales.orders ord
			INNER JOIN	sales.order_items ite ON ord.order_id = ite.order_id
		GROUP BY ord.customer_id, ord.order_id
	) bin_range
GROUP BY bins 
ORDER BY 1;

-- PERCENT_TANK() OVER (PARTITION BY field_name ORDER BY field_name) 
SELECT	order_id,
		PERCENT_RANK() OVER (ORDER BY list_price) AS percentile
FROM	sales.order_items;

SELECT * FROM sales.order_items;

--------------------------------------------------
-- 2. Detecting Duplication
-- 2.1. GROUP BY // HAVING

SELECT	records, COUNT(*)
FROM	(
		SELECT	product_id, product_name, brand_id, category_id, model_year, list_price,
				COUNT(*) AS records
		FROM	production.products
		GROUP BY product_id, product_name, brand_id, category_id, model_year, list_price
		) a
GROUP BY	records;


-- 2.2. JOIN and DISTINCT

--------------------------------------------------
-- 3. Data Cleaning
-- 3.1. CASE WHEN 
-- Label
-- Order status: 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed

SELECT	order_status,
		COUNT(order_id) AS orders
FROM	(
		SELECT	order_id,
				CASE
					WHEN order_status = 1 THEN 'Pending'
					WHEN order_status = 2 THEN 'Processing'
					WHEN order_status = 3 THEN 'Rejected'
					ELSE 'Completed'
				END AS order_status
		FROM	sales.orders
		) a
GROUP BY order_status 
ORDER BY 1 ASC;

-- Categorization (string // int -> string // nested) 

-- Dummy Variables

-- 3.2. Type Conversion and Casting
-- 3.2.1. TO_VARCHAR // TO_NUMBER // TO_DATE // TO_TIMESTAMP


-- 3.2.2. REPLACE()	-- REPLACE(column_name, 'search_string', 'replacement_string')::FLOAT
			-- CONVERT(FLOAT, REPLACE(column_name, 'search_string', 'replacement_string'))
			-- CAST(REPLACE(column_name, 'search_string', 'replacement_string') AS FLOAT)

-- 3.2.3. CAST()
SELECT 	CAST(column_name AS FLOAT) AS modified_column
	FROM your_table;

-- 3.2.4. DATE()
SELECT 	CONVERT(DATE,CONCAT(year, '-', month, '-', day)) AS converted_date
FROM 	your_table;

-- 3.3. Dealing with Nulls
-- 3.3.1. CASE WHEN 

-- 3.3.2. COALESCE()

-- 3.3.3. NULLIF()
-- change it back into the null value

-- 3.4. Missing Value
-- 3.4.1 Detecting Missing Value -- LEFT JOIN and WHERE
SELECT	DISTINCT ord.customer_id
FROM	sales.orders ord
	LEFT JOIN sales.customers cus ON ord.customer_id = cus.customer_id;

-- 3.4.2. 






