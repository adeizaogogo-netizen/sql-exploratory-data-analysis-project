

--------------------------------------------------------------------------------------------------------------------------------
--  PERFORMANCE ANALYSIS
-----------------------------------------------------------------------------------------------------------------------------------------
--Analyze the yearly performance of products by comparing their sales to both average sales performance of the product and \
--the previous year sales
SELECT   YEAR(f.order_date) AS order_year,
         p.product_name,
         SUM(f.sales_amount) AS current_sales
INTO     yearly_sales
FROM     gold.fact_sales AS f
         LEFT OUTER JOIN
         gold.dim_products AS p
         ON f.product_key = p.product_key
WHERE    f.order_date IS NOT NULL
GROUP BY YEAR(f.order_date), p.product_name;

--------------------------------------------------------------------------------------------------------------------------------
SELECT   product_name,
         order_year,
         current_sales,
         AVG(current_sales) OVER (PARTITION BY product_name ) AS  avg_sales,
         current_sales - AVG(current_sales) OVER (PARTITION BY product_name ) AS diff_avg_sales,
         CASE 
         WHEN AVG(current_sales) OVER (PARTITION BY product_name ) > 0 THEN 'Above Average'
         WHEN AVG(current_sales) OVER (PARTITION BY product_name ) < 0 THEN 'Below Average'
         ELSE 'Average'
         END avg_change,
         LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year),
         current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_yr,
         CASE 
         WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increasing'
         WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decreasing'
         ELSE 'No Change'
         END py_change
FROM     yearly_sales
ORDER BY product_name,order_year
