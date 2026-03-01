/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

------------------------------------------------------------------------------
			--which 5 products generate highest revenue
------------------------------------------------------------------------------
SELECT *
FROM (
    SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.product_name
) AS ranked_products
WHERE rank_products <= 5;

------------------------------------------------------------------------------
		--what are the 5 worst-performing products in terms of sale?
------------------------------------------------------------------------------
SELECT TOP 5
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue;

------------------------------------------------------------------------------
	--find the top ten customers who have generated the highest revenue 
------------------------------------------------------------------------------
SELECT TOP 10
    c.customer_key,
    c.full_Name,
    SUM(sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY 
    c.customer_key,
    c.Full_Name
ORDER BY total_revenue DESC;
	
------------------------------------------------------------------------------
			-- 3 customers with fewest orders placed
------------------------------------------------------------------------------
select 
top 3
	gf.Customer_key,
	full_name,
	COUNT(distinct Order_Number) as order_count
from Gold.fact_sales gf
left join Gold.dim_customers dc
on gf.Customer_key = dc.Customer_key
group by 
	gf.Customer_key,
	full_name
order by order_count;
