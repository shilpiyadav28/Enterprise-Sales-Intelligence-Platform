/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

-- Analyse sales performance over time
-- Quick Date Functions

--Analyses sales performance over time  and no. of customers and quantity
select 
YEAR(Order_Date) as Years,
sum(Sales_amount) as total_sales,
count(quantity) as total_quantity_sold,
COUNT(distinct(customer_key)) as total_customers
from Gold.fact_sales
where Order_Date IS NOT NULL
Group by YEAR(Order_Date)
order by YEAR(Order_Date)

---year and month both
select 
YEAR(Order_Date) as Years,
MONTH(Order_Date) as Months,
sum(Sales_amount) as total_sales,
count(quantity) as total_quantity_sold,
COUNT(distinct(customer_key)) as total_customers
from Gold.fact_sales
where Order_Date IS NOT NULL
Group by YEAR(Order_Date),MONTH(Order_Date)
order by YEAR(Order_Date),MONTH(Order_Date)

select 
DATETRUNC(YEAR,order_date) as order_date,
DATETRUNC(MONTH,order_date) as order_date,
sum(Sales_amount) as total_sales,
count(quantity) as total_quantity_sold,
COUNT(distinct(customer_key)) as total_customers
from Gold.fact_sales
where Order_Date IS NOT NULL
Group by DATETRUNC(YEAR,order_date),DATETRUNC(MONTH,order_date)
order by DATETRUNC(YEAR,order_date),DATETRUNC(MONTH,order_date)
