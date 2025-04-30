print 'Truncating silver.erp_cust_az12';
Truncate Table silver.erp_cust_az12;
print'Inserting silver.erp_cust_az12';


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
from bronze.erp_loc_a101