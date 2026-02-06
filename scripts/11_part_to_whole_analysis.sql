

-----------------------------------------------------------------------------------------------------------------------------------------
--  PART-TO-WHOLE ANALYSIS
-----------------------------------------------------------------------------------------------------------------------------------------

-- Which categories contribute the most to the overall sales?

 
SELECT   category,
         current_sales,
         SUM(current_sales) OVER () AS overall_sales,
         CONCAT (ROUND(CAST(current_sales AS FLOAT) / CAST(SUM(current_sales) OVER () AS FLOAT)* 100, 2) ,'%') AS percent_of_total
FROM     (SELECT   p.category,
                   SUM(f.sales_amount) AS current_sales
                             FROM     gold.fact_sales AS f
                   LEFT OUTER JOIN
                   gold.dim_products AS p
                   ON f.product_key = p.product_key
          --WHERE    f.order_date IS NOT NULL >> note that total parts may not add up to 100% if 'NULL' is significant
          GROUP BY p.category) AS t
ORDER BY current_sales DESC;

