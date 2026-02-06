

-----------------------------------------------------------------------------------------------------------------------------------------
--  DATA SEGMENTATION
-----------------------------------------------------------------------------------------------------------------------------------------
-- Segment products into cost ranges and count how many fall into each segment

SELECT product_key,
       product_name,
       category,
       cost,
       CASE 
         WHEN cost <= 100 THEN 'Below 100'
         WHEN cost <=500 THEN '>100 - 500'
         WHEN cost <=1000 THEN '>500 - 1000'
         ELSE 'Above 1000'
       END AS segment
FROM   gold.dim_products;


-----------------------------------------------------------------------------------------------------------------------------------------
-- Group customers into 3 segments based on their spending behaviour
-- VIP: at least 12 months of history and spending more than Euros 5000
-- Regular: at least 12 months of history but spending less than Euros 5000
-- New: less than 12 months of history irrespective of spend
-- find the total no of customers by each group

SELECT   segment,
         COUNT(customer_key) AS no_of_customers   -- get total no of customers  per group

FROM     (SELECT customer_key,
                 first_order,
                 last_order,
                 total_spend,
                 lifespan,
                 CASE WHEN lifespan >= 12
                           AND total_spend > 5000 THEN 'VIP' WHEN lifespan >= 12
                                                                  AND total_spend <= 5000 THEN 'Regular' ELSE 'New' END AS segment
          FROM   (SELECT   c.customer_key,
                           MIN(f.order_date) AS first_order,
                           MAX(f.order_date) AS last_order,
                           SUM(f.sales_amount) AS total_spend,
                           DATEDIFF(MONTH, MIN(f.order_date), MAX(f.order_date)) AS lifespan
                  FROM     gold.fact_sales AS f
                           LEFT OUTER JOIN
                           gold.dim_customers AS c
                           ON f.customer_key = c.customer_key
                  GROUP BY c.customer_key) AS t) AS x
GROUP BY segment;
