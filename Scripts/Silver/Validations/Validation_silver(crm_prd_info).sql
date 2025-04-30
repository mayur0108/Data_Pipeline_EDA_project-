-- check for nulls 
select prd_key,
count(*)
from bronze.crm_prd_info
group by prd_id
having count(*) > 1 or prd_id is null ;


-- check for unwanted spaces
select prd_nm
from bronze.crm_prd_info
where prd_nm != TRIM(prd_nm);


-- check for nulls and -ve

select prd_cost
from bronze.crm_prd_info
where prd_cost < 0 or prd_cost is null ;

-- data standarizationa and consistencies 
Select DISTINCT prd_line 
from bronze.crm_prd_info


-- check for Invalid Date orders
select * from bronze.crm_prd_info
where  prd_start_dt > prd_end_dt

select prd_id,
prd_key,
prd_nm,
prd_start_dt,
prd_end_dt,
 DATEADD(DAY, -1, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)) AS test
from bronze.crm_prd_info
where prd_key in ('AC-HE-HL-U509-R','AC-HE-HL-U509')