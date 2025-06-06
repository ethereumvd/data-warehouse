/*
=============================================================

Purpose :- 
    
    This script generates tables in the datawarehouse_silver
    database (schema) and drops them if they already exist

WARNING :- 

    This will replace the existing tables from the database
    datawarehouse_silver

=============================================================
*/

use datawarehouse_silver ;
--creation date timestamp added

--crm dataset tables 

create or replace table crm_cust_info (
    
    cst_id                  int ,
    cst_key                 varchar(20),
    cst_firstname           varchar(50),
    cst_lastname            varchar(50),
    cst_marital_status      varchar(20),
    cst_gndr                varchar(20),
    cst_create_date         date,
    dwh_create_date         datetime default current_timestamp

) ;


create or replace table crm_prd_info (

    prd_id                  int,
    prd_key                 varchar(50),
    prd_nm                  varchar(50),
    prd_cost                int,
    prd_line                varchar(20),
    prd_start_dt            date,
    prd_end_dt              date ,
    dwh_create_date         datetime default current_timestamp

) ;


create or replace table crm_sales_details (

    sls_ord_num             varchar(20),
    sls_prd_key             varchar(20),
    sls_cust_id             int,
    sls_order_dt            int,
    sls_ship_dt             int,
    sls_due_dt              int,
    sls_sales               int,
    sls_quantity            int,
    sls_price               int,
    dwh_create_date         datetime default current_timestamp

) ;


--erp dataset tables

create or replace table erp_cust_az12 (

    cid                     varchar(30),
    bdate                   date,
    gen                     varchar(20),
    dwh_create_date         datetime default current_timestamp

) ;


create or replace table erp_loc_a101 (

    cid                     varchar(30),
    cntry                   varchar(20),
    dwh_create_date         datetime default current_timestamp

) ;


create or replace table erp_px_cat_g1v2 (

    id                      varchar(20),
    cat                     varchar(30),
    subcat                  varchar(30),
    maintenance             varchar(20),
    dwh_create_date         datetime default current_timestamp

) ;
