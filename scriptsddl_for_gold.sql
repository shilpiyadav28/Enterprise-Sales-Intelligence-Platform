/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================
if OBJECT_Id('gold.dim_customers', 'V') IS NOT NULL
 DROP View gold.dim_customers;

GO

Create View gold.dim_customers as 
Select 
Row_Number() over(order by cst_create_date) as Customer_key,
cs.cst_id As Customer_id,
cs.cst_key As Customer_Number,
CONCAT(cs.cst_firstname,  ' ', cs.cst_lastname) AS Full_Name,
case 
	when cs.cst_gndr !='n/a' then cs.cst_gndr
	else Coalesce(ca.gen,'n/a')
End AS Gender,
la.CNTRY as Country,
ca.BDATE as DOB,
cs.cst_marital_status as Marital_Status,
cs.cst_create_date as Create_Date
from Silver.crm_cust_info cs
left outer join Silver.erp_cust_az12 ca
on cs.cst_key = ca.CID
left outer join Silver.erp_loc_a101 la
on cs.cst_key = la.CID
GO

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
If OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
Drop view gold.dim_products;

GO
Create View gold.dim_products as 
select
ROW_NUMBER() over(order by prd_id) AS Product_key,
cp.prd_id as Product_id,
cp.prd_key AS Product_number,
cp.prd_nm as Product_Name,
cp.cat_id as Category_id,
ep.CAT as Category,
ep.SUBCAT as Sub_Category,
ep.Maintenance as Maintenance,
cp.prd_line as Product_Line,
cp.prd_cost AS Cost,
cp.prd_start_dt as Start_Date
from Silver.crm_prd_info cp
left outer join silver.erp_px_cat_g1v2 ep
on cp.cat_id = ep.id
WHERE cp.prd_end_dt IS NULL;
Go


-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================
if OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
Drop view gold.fact_sales;

GO
Create view gold.fact_sales as 
select 
sls_ord_num  as Order_Number,
cd.Customer_key as Customer_key,
pd.Product_key as Product_Key,
sls_order_dt as Order_Date,
sls_ship_dt as Shipped_Date,
sls_due_dt as Due_Date,
sls_sales as Sales_Amount,
sls_quantity as Quantity,
sls_price as Price
from Silver.crm_sales_info sf
left join Gold.dim_customers cd
on sf.sls_cust_id = cd.Customer_id 
left join  Gold.dim_products pd
on sf.sls_prd_key = pd.Product_number 
Go

