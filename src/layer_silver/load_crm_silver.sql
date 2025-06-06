truncate datawarehouse_silver.crm_cust_info;
insert into datawarehouse_silver.crm_cust_info (
    cst_id, 
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)
select
    cst_id,
    cst_key,
    trim(cst_firstname) as cst_firstname,
    trim(cst_lastname) as cst_lastname,
    case 
        when trim(cst_marital_status) = 'S' then 'Single'
        when trim(cst_marital_status) = 'M' then 'Married'
        else 'N/A'
    end as cst_marital_status,
    case 
        when trim(cst_gndr) = 'M' then 'Male'
        when trim(cst_gndr) = 'F' then 'Female'
        else 'N/A'
    end as cst_gndr,
    cst_create_date
from(
    select 
    *,
    row_number() over (partition by cst_id order by cst_create_date desc) as flag
    from datawarehouse_bronze.crm_cust_info
    where cst_id is not null
) l where flag = 1 ;



truncate table datawarehouse_silver.crm_prd_info;
insert into datawarehouse_silver.crm_prd_info (
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)
select 
    prd_id, 
    replace(substring(trim(prd_key), 1, 5), '-', '_') as cat_id,
    substring(trim(prd_key), 7, length(trim(prd_key))) as prd_key,
    prd_nm, 
    case 
        when prd_cost is null then 0
        else prd_cost
    end as prd_cost,  
    case trim(prd_line)
        when 'M' then 'Mountain'
        when 'R' then 'Road'
        when 'T' then 'Touring'
        when 'S' then 'Skiing'
        else 'N/A'
    end as prd_line,
    cast(prd_start_dt as date) AS prd_start_dt,
    cast(
        lead(prd_start_dt) over (partition by prd_key order by prd_start_dt) - 1 
        as date 
    ) as prd_end_dt 
from datawarehouse_bronze.crm_prd_info ;



truncate table datawarehouse_silver.crm_sales_details;
insert into datawarehouse_silver.crm_sales_details (
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
)
select 
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    case 
        when sls_order_dt = 0 or length(sls_order_dt) != 8 then null
        else cast(sls_order_dt as date)
    end as sls_order_dt,
    case 
        when sls_ship_dt = 0 or length(sls_ship_dt) != 8 then null
        else cast(sls_ship_dt as date) 
    end as sls_ship_dt,
    case
        when sls_due_dt = 0 or length(sls_due_dt) != 8 then null
        else cast(sls_ship_dt as date)
    end as sls_due_dt,
    case 
        when sls_sales is null or sls_sales <= 0 or sls_sales != abs(sls_price) * sls_quantity 
            then sls_quantity * abs(sls_price)
        else sls_sales
    end as sls_sales,
    sls_quantity,
    case 
        when sls_price is null or sls_price <= 0 
            then cast(abs(sls_sales) / nullif(sls_quantity, 0) as int)
        else sls_price
    end as sls_price
from datawarehouse_bronze.crm_sales_details;
