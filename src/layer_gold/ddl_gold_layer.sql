/*
===============================================================
Purpose:
    This script creates views for the gold layer under the
    datawarehouse_gold database . Each view combines data 
    from the tables present in datawarehouse_silver by 
    and performs appropriate transformations / aggregations
    to present a consumer ready data .

Usage:
    These views can be queried directly for analytics and 
    reporting purposes .
================================================================
*/



/*==============================================================
    Dimension : datawarehouse_gold.dimension_customers
=================================================================*/

create or replace view datawarehouse_gold.dimension_customers as
select 
    row_number() over(order by cci.cst_id)  as customer_key,
    cci.cst_id                              as customer_id, 
    cci.cst_firstname                       as first_name,
    cci.cst_lastname                        as last_name,
    eca.bdate                               as birthdate,
    cci.cst_marital_status                  as marital_status,
    case 
        when cci.cst_gndr != 'N/A' then cci.cst_gndr
        else coalesce(eca.gen, 'N/A')
    end                                     as gender,
    ela.cntry                               as country,
    cci.cst_create_date                     as create_date
from datawarehouse_silver.crm_cust_info as cci
left join datawarehouse_silver.erp_cust_az12 eca
    on cci.cst_id = eca.cid
left join datawarehouse_silver.erp_loc_a101 as ela
    on cci.cst_id = ela.cid ;




/*==============================================================
    Dimension : datawarehouse_gold.dimension_products
=================================================================*/

create or replace view datawarehouse_gold.dimension_products as
select
    row_number() over(order by cpi.prd_start_dt, cpi.prd_key) as product_key,
    cpi.prd_id                              as product_id,
    cpi.prd_nm                              as product_name,
    cpi.prd_cost                            as product_cost,
    cpi.prd_line                            as product_line,
    cpi.prd_start_dt                        as start_date,
    epc.cat                                 as category,
    epc.subcat                              as subcategory,
    epc.maintenance 
from datawarehouse_silver.crm_prd_info as cpi
left join datawarehouse_silver.erp_px_cat_g1v2 as epc
    on cpi.prd_key = epc.id 
where cpi.prd_end_dt is null;
--only current data




/*==============================================================
    Facts : datawarehouse_gold.facts_sales_details
=================================================================*/

create or replace view datawarehouse_gold.facts_sales_details as
select
    dp.product_key,
    dc.customer_id,
    csd.sls_ord_num                         as order_number,
    csd.sls_order_dt                        as order_date,
    csd.sls_ship_dt                         as shipping_date,
    csd.sls_due_dt                          as due_date,
    csd.sls_sales                           as sales,
    csd.sls_quantity                        as quantity,
    csd.sls_price                           as price
from datawarehouse_silver.crm_sales_details as csd
left join datawarehouse_gold.dimension_products as dp
    on csd.sls_prd_key = dp.product_key
left join datawarehouse_gold.dimension_customers as dc
    on csd.sls_cust_id = dc.customer_id;
