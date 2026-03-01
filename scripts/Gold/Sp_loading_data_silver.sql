/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '------------------------------------------------';
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.crm_cust_info';
		truncate table silver.crm_cust_info;
		PRINT '>> Inserting Data Into: silver.crm_cust_info';
		insert into silver.crm_cust_info(
		cst_id,	
		cst_key,	
		cst_firstname,	
		cst_lastname,	
		cst_marital_status,	
		cst_gndr,
		cst_create_date	
		)

		select 
		cst_id,	
		cst_key,
		trim(cst_firstname) as cst_firstname,
		trim(cst_lastname) as cst_lastname,
		Case	
			when Upper(trim(cst_marital_status)) = 'M' then 'Married'
			when Upper(trim(cst_marital_status)) = 'S' then 'Single'
			else 'n/a'
		End As cst_marital_status,
		Case	
			when Upper(trim(cst_gndr)) = 'M' then 'Male'
			when Upper(trim(cst_gndr)) = 'F' then 'Female'
			else 'n/a'
		End As cst_gndr,
		cst_create_date
			FROM (
					SELECT
						*,
						ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
					FROM bronze.crm_cust_info
					WHERE cst_id IS NOT NULL
				) t
				WHERE flag_last = 1;
				SET @end_time = GETDATE();
			PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
			PRINT '>> -------------';

		-- Loading silver.crm_prd_info
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.crm_prd_info';
		TRUNCATE TABLE silver.crm_prd_info;
		PRINT '>> Inserting Data Into: silver.crm_prd_info';
		INSERT INTO silver.crm_prd_info (
		prd_id,
		Cat_id,
		prd_key,	
		prd_nm,
		prd_cost,
		prd_line,
		prd_start_dt,
		prd_end_dt
		)
		select 
		prd_id,	
		Replace(Substring(prd_key,1,5), '-', '_') as cat_id,
		trim(upper(SUBSTRING(prd_key,7,LEN(prd_key)))) as prd_key,
		trim(prd_nm) as prd_nm,
		ISNULL(prd_cost,0) as prd_cost,
		CASE Upper(Trim(prd_line))
			when 'R' THEN 'Road'
			when 'S' THEN 'Other Sales'
			when 'M' THEN 'Mountain'
			when 'T' THEN 'Touring'
			else 'N/a'
		End as prd_line,
		--Coalesce(Format(prd_start_dt, 'dd-MMM-yyyy') ,'n/a') as prd_start_dt,
		----Coalesce(Format(prd_end_dt, 'dd-MMM-yyyy') ,'n/a') as prd_end_dt
		cast(prd_start_dt as date) as prd_start_dt,
		--cast(prd_end_dt as date)as prd_end_dt,
		CAST(
				LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) -1
						AS DATE
					) AS prd_end_dt
		from Bronze.crm_prd_info
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        -- Loading crm_sales_info
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.crm_sales_info';
		TRUNCATE TABLE silver.crm_sales_info;
		PRINT '>> Inserting Data Into: silver.crm_sales_info';
		INSERT INTO silver.crm_sales_info (
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		sls_order_dt,
		sls_ship_dt,
		sls_due_dt,
		sls_sales,
		sls_quantity,
		sls_price
		)
		select 
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		Case
			when sls_order_dt = 0 or LEN(sls_order_dt) != 8 Then Null
			Else CAST(CAST(sls_order_dt as VARCHAR) as date) 
		End as sls_order_dt,
		Case
			when sls_ship_dt = 0 or LEN(sls_ship_dt) != 8 Then Null
			Else CAST(CAST(sls_ship_dt as VARCHAR) as date) 
		End as sls_ship_dt,
		Case
			when sls_due_dt = 0 or LEN(sls_due_dt) != 8 Then Null
			Else CAST(CAST(sls_due_dt as VARCHAR) as date) 
		End as sls_order_dt,
		Case
			when sls_sales IS NULL OR sls_sales <=0 or sls_quantity * ABS(sls_price)!= sls_sales
			Then sls_quantity * ABS(sls_price)
			Else sls_sales
		End as sls_sales,
		sls_quantity,
		Case
			when sls_price IS null OR sls_price <=0
			then sls_sales/NULLIF(sls_quantity,0)
			else sls_price
		end as sls_price
		from Bronze.crm_sales_info
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        -- Loading erp_cust_az12
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.erp_cust_az12';
		TRUNCATE TABLE silver.erp_cust_az12;
		PRINT '>> Inserting Data Into: silver.erp_cust_az12';
		INSERT INTO silver.erp_cust_az12 (
		CID,
		BDATE,
		GEN
		)
		select 
			Case
				when cid like 'NAS%'
				then trim(SUBSTRING(cid,4,len(cid)))
				else cid
			end as cid,
			Case
				when bdate >getdate()
				then NULL
				else bdate
			end as bdate,
			Case
				when upper(trim(gen)) in ('M','Male') THEN 'Male'
				when upper(trim(gen)) in ('F','Female') THEN 'Female'
				else 'n/a'
			end as gen
		from bronze.erp_cust_az12
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		PRINT '------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '------------------------------------------------';

        -- Loading erp_loc_a101
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.erp_loc_a101';
		TRUNCATE TABLE silver.erp_loc_a101;
		PRINT '>> Inserting Data Into: silver.erp_loc_a101';
		INSERT INTO silver.erp_loc_a101 (
		cid,
		cntry
		)
		select 
		REPLACE(cid,'-','') as cid,
		case 
			when (trim(cntry)) = 'DE' then 'Germany'
			when (trim(cntry)) IN ('USA', 'US','United States') then 'United States'
			when (trim(cntry)) = '' or cntry IS null then 'N/A'
			else TRIM(cntry)
		end as cntry
		from bronze.erp_loc_a101
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
		
		-- Loading erp_px_cat_g1v2
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.erp_px_cat_g1v2';
		TRUNCATE TABLE silver.erp_px_cat_g1v2;
		PRINT '>> Inserting Data Into: silver.erp_px_cat_g1v2';
		INSERT INTO silver.erp_px_cat_g1v2 (
		id,
		cat,
		subcat,
		maintenance
		)
		select
		id,
		cat,
		subcat,
		maintenance
		from Bronze.erp_px_cat_g1v2
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Silver Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
		
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END



