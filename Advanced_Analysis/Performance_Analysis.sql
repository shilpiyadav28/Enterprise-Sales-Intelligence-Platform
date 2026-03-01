/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/
 --Analyse the yearly performance of products by comparing each product's sales to  
 --both its average sales performance and the previous year sales
       
with current_product_sales as (
    select 
        YEAR(fs.Order_Date) as order_year,
        dp.Product_Name,
        sum(fs.sales_amount) as current_sales,
        avg(fs.sales_amount) as avg_sales
    from Gold.fact_sales fs
    left join Gold.dim_products dp
    on fs.Product_Key = dp.Product_key
    where Order_Date is not null
    group by 
        YEAR(fs.Order_Date),
        dp.Product_Name
    )

    select
    order_year,
    product_name,
    current_sales,
    AVG(current_sales) over(partition by product_name  ) as avg_sales,
    current_sales - AVG(current_sales) over(partition by product_name) as diff_avg,
    CASE 
        when current_sales - AVG(current_sales) over(partition by product_name) < 0 Then 'Below Average'
        WHEN current_sales - AVG(current_sales) over(partition by product_name) > 0 Then 'Above Average'
        ELSE 'No Change'
    end as Avg_Change,
    lag(current_sales) over (partition by product_name order by order_year) as py_sales,
    current_sales - lag(current_sales) over (partition by product_name order by order_year) as py_diff,
       CASE 
        when current_sales - lag(current_sales) over (partition by product_name order by order_year) < 0 Then 'Decrease'
        WHEN current_sales - lag(current_sales) over (partition by product_name order by order_year) > 0 Then 'Increase'
        ELSE 'No Change'
    end as py_Change
    from current_product_sales
    order by 
    Product_Name,order_year
