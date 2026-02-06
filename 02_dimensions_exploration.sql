
/*
--------------------------------------------------------------------------------------------------------------------------------------------------
DIMENSIONS EXPLORATION
--------------------------------------------------------------------------------------------------------------------------------------------------
*/
-- Explore the gold view tables used for analysis and reporting. Dimension columns are usually NVARCHAR 
-- e.g. country, marital_status, gender

SELECT DISTINCT country
FROM   gold.dim_customers;


-- Explore all categories in dimensions tables, category, subcategory, maintenance, product_line

SELECT DISTINCT category, subcategory,product_name
FROM   gold.dim_products;

SELECT DISTINCT product_line
FROM   gold.dim_products;
/*