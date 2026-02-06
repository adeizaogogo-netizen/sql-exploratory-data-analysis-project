


/*
--------------------------------------------------------------------------------------------------------------------------------------------------
RANKING ANALYSIS
--------------------------------------------------------------------------------------------------------------------------------------------------
*/

-- Which 5 products generate the highest revenue?

SELECT   TOP 5 p.product_name,
               SUM(sales_amount) AS total_revenue
FROM     gold.fact_sales AS f
         LEFT OUTER JOIN
         gold.dim_products AS p
         ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;



-- Which 5 worst-performing products in terms of sales? Reverse Order by omitting DESC

SELECT   TOP 5 p.product_name,
               SUM(sales_amount) AS total_revenue
FROM     gold.fact_sales AS f
         LEFT OUTER JOIN
         gold.dim_products AS p
         ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue ;

--USING WINDOW FUNCTION 'ROW_NUMBER'

SELECT *
FROM   (SELECT   p.product_name,
                 SUM(sales_amount) AS total_revenue,
                 ROW_NUMBER() OVER (ORDER BY SUM(sales_amount) DESC) AS rank_product
        FROM     gold.fact_sales AS f
                 LEFT OUTER JOIN
                 gold.dim_products AS p
                 ON f.product_key = p.product_key
        GROUP BY p.product_name) AS t
WHERE  rank_product <= 5;

-- Find Top 10 customers that generated the highest revenue
 
SELECT   TOP 10 c.customer_key,c.first_name, c.last_name,
         SUM(f.sales_amount) AS total_revenue
FROM     gold.fact_sales AS f
         LEFT JOIN
         gold.dim_customers AS c
         ON f.customer_key = c.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY total_revenue DESC;

 
 -- Find the 3 customers with the fewest orders placed

SELECT   TOP 3 c.customer_key,
               c.first_name,
               c.last_name,
               COUNT(DISTINCT f.order_number) AS total_orders
FROM     gold.fact_sales AS f
         LEFT OUTER JOIN
         gold.dim_customers AS c
         ON f.customer_key = c.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY total_orders;
