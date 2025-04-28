/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/



CREATE OR ALTER PROCEDURE bronze.load_bronze as 
BEGIN
	DECLARE @BATCH_START_TIME DATETIME , @BATCH_END_TIME DATETIME;
BEGIN TRY
	SET @BATCH_START_TIME = GETDATE();
	PRINT '---------------------------------';
	PRINT 'lOADING BRONZE LAYER';
	PRINT '---------------------------------';


	PRINT '`````````````````````````````````';
	PRINT'LOADING CRM TABLES';
	PRINT '`````````````````````````````````';


	PRINT'TRUNCATING AND INSERTING : crm_cust_info ';
	TRUNCATE TABLE bronze.crm_cust_info
	BULK INSERT [bronze].[crm_cust_info]
	from 'C:\Users\patel\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	with (
		FIRSTROW=2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	PRINT'TRUNCATING AND INSERTING : crm_sales_details ';
	TRUNCATE TABLE bronze.crm_sales_details
	BULK INSERT [bronze].[crm_sales_details]
	from 'C:\Users\patel\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
	with (
		FIRSTROW=2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	PRINT'TRUNCATING AND INSERTING : crm_prd_info ';
	TRUNCATE TABLE bronze.crm_prd_info
	BULK INSERT [bronze].[crm_prd_info]
	from 'C:\Users\patel\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	with (
		FIRSTROW=2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	PRINT '`````````````````````````````````';
	PRINT'LOADING ERP TABLES';
	PRINT '`````````````````````````````````';


	PRINT'TRUNCATING AND INSERTING : erp_cust_az12 ';
	TRUNCATE TABLE bronze.erp_cust_az12
	BULK INSERT [bronze].[erp_cust_az12]
	from 'C:\Users\patel\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
	with (
		FIRSTROW=2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	PRINT'TRUNCATING AND INSERTING : erp_loc_a101 ';
	TRUNCATE TABLE [bronze].[erp_loc_a101]
	BULK INSERT [bronze].[erp_loc_a101]
	from 'C:\Users\patel\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
	with (
		FIRSTROW=2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	PRINT'TRUNCATING AND INSERTING : erp_px_cat_g1v2 ';
	TRUNCATE TABLE [bronze].[erp_px_cat_g1v2]
	BULK INSERT [bronze].[erp_px_cat_g1v2]
	from 'C:\Users\patel\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
	with (
		FIRSTROW=2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	SET @BATCH_END_TIME = GETDATE();
	PRINT'-TOTAL LOAD DURATION ' + CAST(DATEDIFF(SECOND,@BATCH_START_TIME,@BATCH_END_TIME) AS NVARCHAR) + 'SECONDS';

	END TRY
	BEGIN CATCH 
		PRINT'===============================================';
		PRINT'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT'ERROR MESSAGE'+ ERROR_MESSAGE();
		PRINT'ERROR MESSAGE'+ CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT'===============================================';
	END CATCH
END 
