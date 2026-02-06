/*
==============================================================================================================================================
CUSTOMER REPORT
==============================================================================================================================================

Purpose:
	- This report consolidates key customer metrics and behaviors

Highlights:
	1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
	3. Aggregate customer-level metrics:
		- total orders
		- total sales
		- total quantity purchased
		- total products
		- lifespan (in months)
	4. Calculate valuable KPIs: 
		- recency (months since last order)
		- average order value
		- average monthly spend


-----------------------------------------------------------------------------------------------------------------------------------------------
-- Since this is a customer report, join fact_sales table to dim_customer table to get insights

*/
-- 1. Gathers essential fields such as names, ages, and transaction details.
-- Using Temporary Table
SELECT f.order_number,
       f.product_key,
       f.order_date,
       f.sales_amount,
       f.quantity,
       c.customer_key,
       c.customer_number,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       DATEDIFF(YEAR, c.birth_date, GETDATE()) AS age
INTO   base_query
FROM   gold.fact_sales AS f
       LEFT OUTER JOIN
       gold.dim_customers AS c
       ON f.customer_key = c.customer_key
WHERE  order_date IS NOT NULL;

----------------------------------------------------------------------------------------------------------------------------------------------
-- 1. Gathers essential fields such as names, ages, and transaction details.
-- Using CTE
CREATE VIEW gold.report_customers AS
WITH   base_query1 AS     
(SELECT f.order_number, --Retrieve the core columns from the relevant tables  fact_sales & dim_customers 
               f.product_key,
               f.order_date,
               f.sales_amount,
               f.quantity,
               c.customer_key,
               c.customer_number,
               CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
               DATEDIFF(YEAR, c.birth_date, GETDATE()) AS age
               FROM   gold.fact_sales AS f
               LEFT OUTER JOIN
               gold.dim_customers AS c
               ON f.customer_key = c.customer_key
        WHERE  order_date IS NOT NULL), -- only consider valid dates
       customer_aggregation
AS     (SELECT   customer_key, --Customer aggregations: Summarize Key Metrics at the customer level   
                 customer_number,
                 customer_name,
                 age,
                 COUNT(DISTINCT order_number) AS total_orders,
                 SUM(sales_amount) AS total_sales,
                 SUM(quantity) AS total_quantity,
                 COUNT(DISTINCT product_key) AS total_products,
                 MAX(order_date) AS last_order_date,
                 DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
        FROM     base_query1
        GROUP BY customer_key, customer_number, customer_name, age)
SELECT customer_key, -- Final report  
       customer_number,
       customer_name,
       age,
       CASE 
            WHEN age <= 20 THEN 'Under 20' 
            WHEN age > 20 AND age <= 30 THEN '20 - 30' 
            WHEN age > 30 AND age <= 40 THEN '30 - 40' 
            WHEN age > 40 AND age <= 50 THEN '40 - 50' 
            ELSE 'Above 50' 
       END AS age_group,
       lifespan,
       CASE 
           WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP' 
           WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular' 
           ELSE 'New' 
       END AS customer_segment,
       last_order_date,
       DATEDIFF(month, last_order_date, GETDATE()) AS recency,
       total_orders,
       total_sales,
       total_quantity,
       total_products,
       total_sales / total_orders AS average_order_value,
       CASE 
       WHEN lifespan = 0 THEN total_sales
       ELSE total_sales / lifespan 
       END AS average_monthly_spend
FROM   customer_aggregation;

-------------------------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM gold.report_customers









 