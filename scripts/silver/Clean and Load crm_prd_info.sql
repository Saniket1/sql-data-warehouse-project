--Update DDL script as per silver table data modification 
IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_prd_info;

Create Table silver.crm_prd_info(
	prd_id Int,
	cat_id nvarchar(50),
	prd_key nvarchar(50),
	prd_nm nvarchar(50),
	prd_cost int,
	prd_line nvarchar(50),
	prd_start_dt date,
	prd_end_dt date,
	dwh_create_date Datetime2 default getdate()
);
--Insert Data in silver table
INSERT INTO silver.crm_prd_info(
	prd_id,
	cat_id,
	prd_key,
	prd_nm ,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
)
select
prd_id,
REPLACE(SUBSTRING(prd_key, 1, 5), '-' , '_')AS cat_id, --Derived new column: Extract category ID
SUBSTRING(prd_key, 7 , LEN(prd_key)) AS prd_key, --Derived new column : Extract product key
prd_nm,
ISNULL(prd_cost,0) as prd_cost,--Handelling null values
CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
	 WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
	 WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
	 WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
	 ELSE 'n/a'
END as prd_line,-- Map product line codes to descriptive values
CAST(prd_start_dt AS DATE) AS prd_start_dt,
CAST(
	LEAD (prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1
	AS DATE
	) AS prd_end_dt -- Data Enrichment : Calculate end date as one day before the next start date
from bronze.crm_prd_info
