
/*
--------------------------------------------------------------------------------------------------------------------------------------------------
DATE RANGE EXPLORATION
--------------------------------------------------------------------------------------------------------------------------------------------------
*/

-- Understand boundaries (Earliest/ Latest dates in the data) and the Span (Datediff)
-- Order date
SELECT 'Order (Month)' AS Data_DMY,MIN(order_date) AS Earliest,                                  -- ealiest date
       MAX(order_date) AS Latest,                                  -- latest date
       DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS DateRange-- span in months
FROM   GOLD.FACT_SALES
 
UNION ALL
-- customer birthday/ age span
SELECT 'Customer_bday (Year)' AS Data_DMY,MIN(birth_date)  AS Earliest,                                  -- ealiest date
       MAX(birth_date)  AS Latest,                                  -- latest date
       DATEDIFF(YEAR, MIN(birth_date), MAX(birth_date)) AS DateRange-- span in years
FROM   gold.dim_customers
 
-- customer birthday/ age span
SELECT 'Customer_Age (Year)' AS Data_DMY,
        DATEDIFF(YEAR, MIN(birth_date), GETDATE()) AS Oldest,
        DATEDIFF(YEAR, MAX(birth_date), GETDATE()) AS Youngest,
       DATEDIFF(YEAR, MIN(birth_date), GETDATE()) -DATEDIFF(YEAR, MAX(birth_date), GETDATE()) AS Lifespan
FROM   gold.dim_customers;
 