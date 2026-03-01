/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/


--which category contribute the most overall sales?
with CTE2 as(
	select
	Category,
	SUM(sales_amount) as total_sales
	from Gold.fact_sales f
	left join Gold.dim_products dp
	on f.Product_Key = dp.Product_key
	group by Category
	)
	
SELECT 
    Category,
    total_sales,
    SUM(total_sales) OVER()  AS whole_sale,
   Cast((total_sales / CAST(SUM(total_sales) OVER() AS DECIMAL(18,2))) * 100 as decimal(18,2)) AS total_per
FROM CTE2
order by total_sales desc
