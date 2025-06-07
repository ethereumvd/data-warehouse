/*
================================================================
Purpose:
    This script performs various quality checks for data 
    consistency, accuracy, standardization for the silver layer
    this script checks for
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Note:
    These checks must be run after loading data into the 
    silver layer and any discrepancies must be resolved
================================================================
*/

use datawarehouse_silver;

--check for duplicate or null primary keys 
--should not display anything in output


/*=============================================================
    Check crm_cust_info table 
=============================================================*/
--check for duplicate or null primary keys 
--should not display anything in output
select 
    cst_id,
    count(*)
from datawarehouse_silver.crm_cust_info
group by cst_id
having count(*) > 1 or cst_id is null;

--data standardization and consistency check 

select distinct cst_gndr
from datawarehouse_silver.crm_cust_info;

select distinct cst_marital_status
from datawarehouse_silver.crm_cust_info;

--replace abbreviations to readable values


/*=============================================================
    Check crm_prd_info table 
=============================================================*/

--check for null or duplicate keys
--should not display anything in output

select 
    prd_id, 
    count(*) 
from datawarehouse_silver.crm_prd_info 
group by prd_id
having count(*) > 1 or prd_id is null;

--check for unwanted spaces

select 
    prd_nm
from datawarehouse_silver.crm_prd_info
where trim(prd_nm) != prd_nm;

--check for invalid costs

select 
    prd_cost
from datawarehouse_silver.crm_prd_info
where prd_cost < 0 or prd_cost is null;

--data standardization and consistency

select distinct
    prd_line
from datawarehouse_silver.crm_prd_info;

--invalid dates check

select 
    *
from datawarehouse_silver.crm_prd_info
where prd_start_dt < prd_end_dt ;



/*=============================================================
    Check crm_sales_details table 
=============================================================*/

--check for invalid dates 
select 
    sls_order_dt
from datawarehouse_silver.crm_sales_details 
where
    sls_order_dt <= 0
    or length(sls_order_dt) != 8
    or sls_order_dt > 20300101
    or sls_order_dt > sls_ship_dt
    or sls_order_dt > sls_due_dt
;

--data consistency check
--sales = quantity * price
--also sales != 0 or null

select
    sls_sales,
    sls_quantity,
    sls_price
from datawarehouse_silver.crm_sales_details
where 
    sls_price * sls_quantity != sls_sales
    or sls_sales is null or sls_sales <= 0
    or sls_quantity is null or sls_quantity <= 0
    or sls_price is null or sls_price <= 0
;

--rules :-
--if sales <=0 or null or wrong derieve it using quantity and price
--if price is zero or null calculate using sales and quantity
--if price is negative convert to positive




/*=============================================================
    Check erp_cust_az12 table 
=============================================================*/

--data cleansing

select 
    cid ,
    case 
        when trim(cid) like 'NAS%' then substring(cid, 4, length(trim(cid)))
        else trim(cid)
    end as cid_new
from datawarehouse_silver.erp_cust_az12 
limit 20;

--check for invalid dates
select 
    bdate 
from datawarehouse_silver.erp_cust_az12
where bdate < '1925-01-01' or bdate > now();

--check for data consistency and standardization

select 
    gen,
    case 
        when lower(trim(gen)) in ('f', 'female') then 'Female'
        when lower(trim(gen)) in ('m', 'male') then 'Male'
        else 'N/A'
    end as gen_new
from datawarehouse_silver.erp_cust_az12 limit 20;



/*=============================================================
    Check erp_loc_a101 table 
=============================================================*/

select 
    *
from datawarehouse_silver.erp_loc_a101 limit 20;

select 
    cid 
from datawarehouse_silver.erp_loc_a101 
where trim(cid) not like 'AW%';

-- data standardization and consistency check

select 
    replace(cntry,' ', '') as cntry 
from datawarehouse_silver.erp_loc_a101;



/*=============================================================
    Check erp_px_cat_g1v2 table 
=============================================================*/


--check for unwanted spaces
select 
    * 
from datawarehouse_silver.erp_px_cat_g1v2
where 
    cat != trim(cat)
    or subcat != trim(subcat)
    or maintenance != trim(maintenance)
;

--check for data standardization 
select distinct
    cat
from datawarehouse_silver.erp_px_cat_g1v2;

select distinct
    subcat
from datawarehouse_silver.erp_px_cat_g1v2;

select distinct 
    maintenance
from datawarehouse_silver.erp_px_cat_g1v2;

--check because id wasnt looking as expected
select distinct 
    id
from datawarehouse_silver.erp_px_cat_g1v2;



