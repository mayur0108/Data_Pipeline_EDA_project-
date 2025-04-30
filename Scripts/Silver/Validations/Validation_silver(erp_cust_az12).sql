-- identity birthdates out of range 

select distinct
bdate
from bronze.erp_cust_az12
where bdate <'1924-01-01' or bdate > getdate()

select distinct
gen 
from bronze.erp_cust_az12