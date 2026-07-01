--check for nulls or duplicates in primary key
--Expectation : No Result
select 
prd_id,
count(*)
from silver.crm_prd_info
group by prd_id
having count(*) > 1 or prd_id is null

--Check for unwanted spaces
--Expectation : No results
select prd_nm
from silver.crm_prd_info
where prd_nm != trim (prd_nm)

--Check for NULLs or Negative Numbers
--Expectation : No results
select prd_cost
from silver.crm_prd_info
where prd_cost < 0 or prd_cost is null

--Data Standardization and Consistency
select distinct prd_line
from silver.crm_prd_info

--check for invalid date orders
select*
from silver.crm_prd_info
where prd_end_dt< prd_start_dt

--Data standardizatioon & consistency gender
select Distinct gen
from bronze.erp_cust_az12

--Data standardizatioon & consistency fro country
select distinct cntry as old_cntry
from bronze.erp_loc_a101
order by cntry
