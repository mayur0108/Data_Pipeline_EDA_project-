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