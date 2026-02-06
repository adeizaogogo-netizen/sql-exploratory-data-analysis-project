

-----------------------------------------------------------------------------------------------------------------------------------------
--TRENDS AND CHANGE OVER TIME
-----------------------------------------------------------------------------------------------------------------------------------------

--Sales performance over time

SELECT   YEAR(order_date) AS order_yr,
		 MONTH(order_date) AS order_month,
         SUM(sales_amount) AS total_sales,
		 COUNT(DISTINCT customer_key) AS total_cust,
		 SUM(quantity) AS total_qty
FROM     gold.fact_sales
WHERE    order_date IS NOT NULL
GROUP BY YEAR(order_date),MONTH(order_date)
ORDER BY YEAR(order_date),MONTH(order_date) ;


-- Using DATETRUNC function to combine year and month columns into one column 'order_date'

SELECT   DATETRUNC(month, order_date) AS order_date,
         SUM(sales_amount) AS total_sales,
         COUNT(DISTINCT customer_key) AS total_cust,
         SUM(quantity) AS total_qty
FROM     gold.fact_sales
WHERE    order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date);

