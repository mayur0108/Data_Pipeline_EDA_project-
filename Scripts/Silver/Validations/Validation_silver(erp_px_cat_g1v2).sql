-- unwanted space 
select * from 
bronze.erp_px_cat_g1v2
where cat != trim(cat) 
or subcat != trim(subcat)
or maintenance != trim(maintenance)


-- data standarization and consistency 
select distinct 
cat
from bronze.erp_px_cat_g1v2

select distinct 
subcat
from bronze.erp_px_cat_g1v2
