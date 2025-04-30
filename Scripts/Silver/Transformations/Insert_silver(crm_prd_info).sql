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
from bronze.crm_prd_info


