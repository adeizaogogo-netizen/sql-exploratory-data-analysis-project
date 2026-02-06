/*

---------------------------------------------------------------------------------------------------------------------------------------------------
DATABASE STRUCTURE EXPLORATION
---------------------------------------------------------------------------------------------------------------------------------------------------
*/

-- Explore all objects in the database
SELECT   *
FROM     INFORMATION_SCHEMA.TABLES
ORDER BY TABLE_SCHEMA, TABLE_NAME;

-- Explore all columns in the database
SELECT * FROM   INFORMATION_SCHEMA.COLUMNS
;

-- Explore the columns in the each table in the database
-- 1. Get the distinct table names 
SELECT distinct TABLE_NAME FROM   INFORMATION_SCHEMA.COLUMNS
/*
TABLE_NAME
crm_cust_info
crm_prd_info
crm_sales_details
dim_customers
dim_products
erp_cust_az12
erp_loc_a101
erp_px_cat_g1v2
fact_sales
*/

--2. Explore all the columns in each table
SELECT *
FROM   INFORMATION_SCHEMA.COLUMNS
WHERE  TABLE_NAME = 'fact_sales';
