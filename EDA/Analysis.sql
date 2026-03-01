/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.

Table Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/

-- Retrieve a list of all tables in the database
select * from INFORMATION_SCHEMA.TABLES

-- Retrieve all columns for a specific table (dim_customers)
select * from INFORMATION_SCHEMA.COLUMNS
where TABLE_SCHEMA = 'gold' and TABLE_NAME ='fact_sales'

/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

--------------------------------------------------
       --how many generds are there?
---------------------------------------------------
select distinct Gender from Gold.dim_customers

--------------------------------------------------
      --how many countries are there?
--------------------------------------------------
select distinct Country from Gold.dim_customers

----------------------------------------------------
        ---how many categories are there?
----------------------------------------------------
select distinct category, Sub_Category ,Product_Name from Gold.dim_products

  -------------------------------------------------
      --how many product lines are there
----------------------------------------------------
select distinct product_line from Gold.dim_products

---------------------------------------------------------------------------------
                        --Date Exploration
---------------------------------------------------------------------------------

------------------------------------------------------------
--find date of first and last order date and order range
------------------------------------------------------------
select 
  MIN(order_date) as min_date,
  Max(order_date) as max_date,
  DATEDIFF(Year,MIN(order_date),Max(order_date)) as order_range 
from Gold.fact_sales

------------------------------------------------------------
--find  youngest and oldest customer
------------------------------------------------------------
select 
  MIN(DOB) as min_date,
  Max(DOB) as max_date,
  DATEDIFF(Year,MIN(DOB),GETDATE()) as yougest_customer,
  DATEDIFF(Year,MAX(DOB),GETDATE()) as yougest_customer
from Gold.dim_customers

---------------------------------------------------------------------------------
                        --Measure Exploration
---------------------------------------------------------------------------------

------------------------------------------------------------
---find the total sales
------------------------------------------------------------
select 
SUM(sales_amount) as Total_Sales from gold.fact_sales

------------------------------------------------------------
---how many items are sold
------------------------------------------------------------
select 
SUM(Quantity) as Total_Items_Sold from gold.fact_sales

------------------------------------------------------------
--total number of products
------------------------------------------------------------
select 
count(product_key) as Total_No_of_Customers from gold.dim_products

  ------------------------------------------------------------
--Find average price
------------------------------------------------------------
select 
Avg(Price) as Average_Price from gold.fact_sales

------------------------------------------------------------
--Find total number of orders
------------------------------------------------------------
select 
count(distinct order_number) as Total_No_of_Orders from gold.fact_sales

------------------------------------------------------------
--find total number of customers
------------------------------------------------------------
select 
count(distinct Customer_key) as Total_No_of_Customers from gold.dim_customers

------------------------------------------------------------
--Find the total number of customers that placed an order
------------------------------------------------------------
select 
count(distinct Customer_key) as Total_No_of_Customers_ordered from gold.fact_sales

  

------------------------------------------------------------------------------
					        --Genrating report
------------------------------------------------------------------------------


select  'Total_sales' as 'Measure_name'  , sum(Sales_Amount) as 'Measure_Value'
from Gold.fact_sales
Union ALL
select  'Total_Items_Sold' as 'Measure_name'  , sum(Quantity) as 'Measure_Value'
from Gold.fact_sales
Union ALL
select  'Total_No_of_Products' as 'Measure_name'  , COUNT(Distinct Product_key) as 'Measure_Value'
from Gold.dim_products
Union ALL
select  'Avg_Price' as 'Measure_name'  , AVG(Price) as 'Measure_Value'
from Gold.fact_sales
Union ALL
select  'Total_No_of_Orders' as 'Measure_name'  , COUNT(distinct Order_Number) as 'Measure_Value'
from Gold.fact_sales  
Union ALL
select  'Total_No_of_customers' as 'Measure_name'  , COUNT(distinct customer_key) as 'Measure_Value'
from Gold.dim_customers
Union ALL
select  'Total_No_of_customers_Ordered' as 'Measure_name'  , COUNT(distinct customer_key) as 'Measure_Value'
from Gold.fact_sales
