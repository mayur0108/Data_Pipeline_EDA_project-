--check for invalid dates 

select 
nullif(sls_order_dt,0)
from bronze.crm_sales_details
where sls_order_dt <=0 or len(sls_order_dt)!=8 


--invalid date orders
select 
* from 
bronze.crm_sales_details
where sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt


--check data consistency
select distinct 
sls_sales as old_sls_sales,
sls_quantity as old_sls_quantity,
sls_price as old_sls_price,

case 
	when sls_sales is null or sls_sales <=0 or sls_sales != sls_quantity * abs(sls_price)
	then sls_quantity *abs(sls_price)
	else sls_sales
end as sls_sales,

case 
	when sls_price is null or sls_price <=0
	then sls_sales/nullif(sls_quantity,0)
	else sls_price
end as sls_price,

case 

from bronze.crm_sales_details
where sls_sales != sls_quantity * sls_price
or sls_sales is null or sls_quantity is null or sls_price is null 
or sls_sales <=0 or sls_quantity <=0  or sls_price <=0

