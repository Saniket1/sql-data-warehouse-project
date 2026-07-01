PRINT '>> Truncating Table: silver.crm_cust_info';
TRUNCATE Table silver.crm_cust_info;
PRINT '>> Inserting Data Into: silver.crm_cust_info'

Insert INTO silver.crm_cust_info(
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
--Remove unwanted spaces
TRIM(cst_firstname) as cst_firstname,
TRIM(cst_lastname) as cst_lastname,
 
CASE When Upper(trim(cst_marital_status)) = 'M' then 'Married'
	When Upper(trim(cst_marital_status)) = 'S' then 'Single'
	Else 'n/a' -- Handling Missing data
END cst_marital_status, --Normalize marital status values to readable format aka Data Normalization & standardization

CASE When Upper(trim(cst_gndr)) = 'F' then 'Female'
	When Upper(trim(cst_gndr)) = 'M' then 'Male'
	Else 'n/a'--Hanling missing data
END cst_gndr,  -- Normalize gender values to readable format

cst_create_date
from(
	select 
	*,
	ROW_NUMBER() over (partition by cst_id order by cst_create_date DESC) as flag_last
	from bronze.crm_cust_info
	where cst_id is not null
)t where flag_last = 1 ---Removing Duplicates
