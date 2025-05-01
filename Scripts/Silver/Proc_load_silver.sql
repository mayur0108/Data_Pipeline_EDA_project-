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



create or alter procedure silver.prac as 
BEGIN	
	Declare @start_time datetime , @end_time datetime, @batch_start_time datetime, @batch_end_time datetime;
	Begin Try 
		SET @batch_start_time = GETDATE();
		print'================================';
		print'Inserting data into silver layer';
		print'================================';
		print'Inserting ERP Tables';
		print'---------------------------------';

		set @start_time =getdate ();
		-- Insertion to silver.crm_cust_info
		-- data transformation
		print 'Truncating silver.crm_cust_info';
		Truncate Table silver.crm_cust_info;
		print'Insering silver.crm_cust_info';

		INSERT INTO silver.crm_cust_info(
					cst_id,
					cst_key,
					cst_firstname,
					cst_lastname,
					cst_marital_status,
					cst_gndr,
					cst_create_date)


		select 
		cst_id,
		cst_key,
		trim(cst_firstname) as cst_firstname,
		trim(cst_lastname) as cst_lastname,
		case when upper(trim(cst_material_status)) = 'S' then 'Single'
			 when upper(trim(cst_material_status)) = 'M' then 'Married'
			 else 'n/a'
		end cst_material_status,
		case when upper(trim(cst_gndr)) = 'F' then 'Female'
			 when upper(trim(cst_gndr)) = 'M' then 'Male'
			 else 'n/a'
		end cst_gndr,
		cst_create_date
		from (
				select *,
				ROW_NUMBER() OVER ( PARTITION BY cst_id order by cst_create_date desc) as flag_last

				from bronze.crm_cust_info)t

		where flag_last = 1 and cst_id is not null;
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';



		-- Insering silver.crm_prd_info
		set @start_time= GETDATE();
		print 'Truncating silver.crm_prd_info';
		Truncate Table silver.crm_prd_info;
		print'Inserting silver.crm_prd_info';

		INSERT INTO silver.crm_prd_info(
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)
		select 
			prd_id,
			REPLACE(SUBSTRING(prd_key,1,5),'-','_') as cat_id,
			SUBSTRING(prd_key,7,LEN(PRD_KEY)) AS prd_key, 
			prd_nm,
			ISNULL(prd_cost,0) AS prd_cost, 
			case 
					when upper(trim(prd_line)) = 'M' then 'Mountain'
					when upper(trim(prd_line)) = 'R' then 'Road'
					when upper(trim(prd_line)) = 'S' then 'Other sales'
					when upper(trim(prd_line)) = 'T' then 'Touring'
					else 'n/a'
			end as prd_line,
			cast(prd_start_dt as Date) as prd_start_dt ,
			cast(DATEADD(DAY, -1, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt))as date) AS prd_end_dt
		from bronze.crm_prd_info;
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';



		-- Inserting in silver.crm_sales_details
		set @start_time = GETDATE();
		print 'Truncating silver.crm_sales_details';
		Truncate Table silver.crm_sales_details;
		print'Inserting silver.crm_sales_details';


		insert into silver.crm_sales_details(
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
				case 
					when sls_order_dt =0 OR LEN(sls_order_dt) != 8 then null 
					else cast(cast(sls_order_dt as varchar) as date) 
				end as sls_order_dt,
				case 
					when sls_ship_dt =0 OR LEN(sls_ship_dt) != 8 then null 
					else cast(cast(sls_ship_dt as varchar) as date) 
				end as sls_ship_dt,
				case 
					when sls_due_dt =0 OR LEN(sls_due_dt) != 8 then null 
					else cast(cast(sls_due_dt as varchar) as date) 
				end as sls_due_dt,
				case 
					when sls_sales is null or sls_sales <=0 or sls_sales != sls_quantity * abs(sls_price)
					then sls_quantity *abs(sls_price)
					else sls_sales
				end as sls_sales,

				sls_quantity,
				case 
					when sls_price is null or sls_price <=0
					then sls_sales/nullif(sls_quantity,0)
					else sls_price
				end as sls_price

		from bronze.crm_sales_details;
		SET @end_time = GetDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';




		PRINT '------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '------------------------------------------------';






		--Inserting silver.erp_cust_az12
		Set @start_time = GETDATE();
		print 'Truncating silver.erp_cust_az12';
		Truncate Table silver.erp_cust_az12;
		print'Inserting silver.erp_cust_az12';



		Insert into silver.erp_cust_az12 (
			cid,
			bdate,
			gen
		)

		select 
		case 
				when cid like 'NAS%' then SUBSTRING ( cid, 4, len(cid))
				else cid 
		end cid,
		case 
			when bdate > GETDATE() then null 
			else bdate
		end bdate,
		case 
			when upper(trim(gen)) in ('F', 'FEMALE') THEN 'Female'
			when upper(trim(gen)) in ('M','MALE') then 'Male'
			Else 'n/a'
		END as gen
		from bronze.erp_cust_az12;
		SET @end_time = GETDATE();
		PRINT'>> TOTAL DURATION' + CAST(DATEDIFF(SECOND,@start_time,@end_time)AS NVARCHAR) + ' Seconds';
		PRINT'------------------------';

		--INSERING silver.erp_cust_az12
		SET @start_time = GETDATE();
		print 'Truncating silver.erp_loc_a101';
		Truncate Table silver.erp_loc_a101;
		print'Inserting silver.erp_loc_a101';


		Insert into silver.erp_loc_a101(
			cid, 
			cntry
		)
		select 
		replace(cid,'-','') cid,
		case 
			when trim(cntry)= 'DE' then 'Germany'
			when trim(cntry) IN ('US','USA') then 'United States'
			when trim(cntry) = '' or cntry is null then 'n/a'
			else cntry
		end as cntry
		from bronze.erp_loc_a101;
		set @end_time= GETDATE();
		PRINT'>> TOTAL DURATION ' + CAST(DATEDIFF(SECOND, @Start_time, @end_time) as nvarchar) + ' Seconds';
		PRINT'----------------------------';




		--INSERTING silver.erp_px_cat_g1v2
		SET @start_time= GETDATE();
		print 'Truncating silver.erp_px_cat_g1v2';
		Truncate Table silver.erp_px_cat_g1v2;
		print'Inserting silver.erp_px_cat_g1v2';



		Insert into silver.erp_px_cat_g1v2(
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
		from bronze.erp_px_cat_g1v2;
		SET @end_time = GETDATE();
		print'>> TOTAL DURATION '+ CAST(DATEDIFF(SECOND,@start_time, @end_time) as nvarchar)+ 'Seconds';

		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Silver Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
	

	End try 
	BEGIN CATCH 
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END

