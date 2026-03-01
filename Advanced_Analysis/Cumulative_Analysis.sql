/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/

--calculate the total sales per month and the running total of sales overtime

select 
	YEAR(order_date) as year_dt,
	SUM(sales_amount) as total_sales,
	AVG(price) as avg_price
from Gold.fact_sales
where Order_Date is not null
group by YEAR(order_date)
order by YEAR(order_date)
------------------------------------------------------------

select
	order_date,
	sum(total_sales) over (order by order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) as Running_Total,
	avg(avg_price) over (order by order_date ) as Moving_Average_price
from (
	select 
	YEAR(order_date) as order_date,
	SUM(sales_amount) as total_sales,
	AVG(price) as avg_price
	from Gold.fact_sales
	where Order_Date is not null
	group by YEAR(order_date)
)t
