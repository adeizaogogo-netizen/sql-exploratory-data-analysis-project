

/*
==============================================================================================================================================
PRODUCT REPORT
==============================================================================================================================================

Purpose:
	- This report consolidates key product metrics and behaviors

Highlights:
	1. Gathers essential fields such as product, name, category, subcategory,  and cost.
	2. Segments products by revenue to identify High-Prformers, Mid-Range, or Low-Performers 
	3. Aggregate product-level metrics:
		- total orders
		- total sales
		- total quantity purchased
		- total customers (unique)
		- lifespan (in months)
	4. Calculate valuable KPIs: 
		- recency (months since last sales)
		- average order revenue (AOR)
		- average monthly revenue
*/
CREATE VIEW gold.report_products AS
WITH   base_query
AS     (SELECT f.order_number, --Retrieve the core columns from the relevant tables  fact_sales & dim_products
               f.order_date,
               f.sales_amount,
               f.quantity,
               f.customer_key,
               p.product_key,
               p.product_number,
               p.product_name,
               p.category,
               p.subcategory,
               p.cost
        FROM   gold.fact_sales AS f
               LEFT OUTER JOIN
               gold.dim_products AS p
               ON f.product_key = p.product_key
        WHERE  f.order_date IS NOT NULL), -- only consider valid dates
       product_aggregation
AS     (SELECT   product_key,
                 product_number,
                 product_name,
                 category,
                 subcategory,
                 COUNT(DISTINCT order_number) AS total_orders,
                 SUM(sales_amount) AS total_sales,
                 SUM(quantity) AS total_quantity,
                 COUNT(DISTINCT customer_key) AS total_customers,
                 MAX(order_date) AS last_sales_order_date,
                 DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
                 CAST (sales_amount AS FLOAT) / NULLIF(quantity,0)  AS average_selling_price
        FROM     base_query
        GROUP BY product_key, product_number, product_name, category, subcategory,sales_amount,quantity)
SELECT           product_key,
                 product_number,
                 product_name,
                 category,
                 subcategory,
                 total_orders,
                 total_sales,
                 CASE 
                     WHEN total_sales > 50000 THEN 'High Performer'
                     WHEN total_sales >= 10000 THEN 'Mid-Range '
                     ELSE 'Low-Performer'
                 END AS product_segment,
                 total_quantity,
                 total_customers,
                 last_sales_order_date,
                 DATEDIFF(month, last_sales_order_date, GETDATE()) AS recency,
                 lifespan,
                 average_selling_price,
                 total_sales / total_orders AS average_order_value,
                CASE 
                    WHEN lifespan = 0 THEN total_sales
                    ELSE total_sales / lifespan 
                END AS average_monthly_spend
FROM   product_aggregation;


--------------------------------------------------------------------------------------------------------------------------------------------------


select * from gold.report_products