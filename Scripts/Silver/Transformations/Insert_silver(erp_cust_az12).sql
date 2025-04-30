print 'Truncating silver.erp_loc_a101';
Truncate Table silver.erp_loc_a101;
print'Inserting silver.erp_loc_a101';



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
from bronze.erp_cust_az12
