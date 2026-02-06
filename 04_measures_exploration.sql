
/*
--------------------------------------------------------------------------------------------------------------------------------------------------
MEASURES EXPLORATION
--------------------------------------------------------------------------------------------------------------------------------------------------
*/
--Basically Measures will be available in the facts table gold.fact_sales
--Measures >> SUM/AVERAGE/COUNT 
SELECT * FROM gold.fact_sales;

-- Find Total Sales
-- Find how many items are sold
-- Find the average selling price
-- Find Total no. of orders
-- Find Total no. of customers

SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM   gold.fact_sales
UNION ALL
SELECT 'Total Quantity' AS measure_name, SUM(quantity) AS measure_value FROM   gold.fact_sales
UNION ALL
SELECT 'Average Selling Price' AS measure_name, AVG(price) AS measure_value FROM   gold.fact_sales
UNION ALL
SELECT 'Total no. line items in all Orders' AS measure_name, COUNT(order_number) AS measure_value FROM   gold.fact_sales
UNION ALL
SELECT 'Total no. of Orders' AS measure_name, COUNT(DISTINCT order_number) AS measure_value FROM   gold.fact_sales
UNION ALL
SELECT 'Total no. of Products' AS measure_name, COUNT(DISTINCT product_id) AS measure_value FROM   gold.dim_products
UNION ALL
SELECT 'Total no. of Customers' AS measure_name, COUNT( DISTINCT customer_key) AS measure_value FROM   gold.fact_sales
UNION ALL
SELECT 'Total no. of Customers with Orders' AS measure_name, COUNT( DISTINCT customer_key) AS measure_value FROM   gold.fact_sales WHERE  order_number IS NOT NULL;

