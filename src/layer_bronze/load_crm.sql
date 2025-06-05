/*
=============================================================

Purpose :- 
    
    This script loads all data from the csv files to the 
    tables in datawarehouse_bronze using load data infile

Note :- 
    
    The actual data loading happens outside the stored 
    procedure because MariaDB / MySQL doesnt allow
    load data infile inside a stored procedure 

=============================================================
*/

use datawarehouse_bronze ;

/*=============================================================
    Load crm_cust_info table 
/*=============================================================*/

delimiter $$

create or replace procedure load_bronze_crm_cust_info() 
begin 

    declare start_time datetime;
    declare end_time datetime;

    set start_time = now();
    select '>>>Truncating table datawarehouse_bronze.crm_cust_info' as '';
    truncate table crm_cust_info;
    set end_time = now();
    select concat('>>>Time taken(seconds):', timestampdiff(second, start_time, end_time)) as '';

    select '>>Manually loading the data' as '';

end$$

delimiter ;

call load_bronze_crm_cust_info();

load data infile '/var/lib/mysql/source_crm/cust_info.csv'
into table datawarehouse_bronze.crm_cust_info 
fields terminated by ','
ignore 1 lines 
(@cst_id, @cst_code, @cst_fname, @cst_lname, @cst_gender, @cst_marital_status, @cst_create_date)
set 
    cst_id = nullif(@cst_id, ''),
    cst_key = nullif(@cst_code, ''),
    cst_firstname = nullif(@cst_fname, ''),
    cst_lastname = nullif(@cst_lname, ''),
    cst_gndr = nullif(@cst_gender, ''),
    cst_marital_status = nullif(@cst_marital_status, ''),
    cst_create_date = str_to_date(nullif(@cst_create_date, ''), '%Y-%m-%d');


/*=============================================================
    Load prd_info table 
/*=============================================================*/

delimiter $$

create or replace procedure load_bronze_prd_info()
begin 

    declare start_time datetime;
    declare end_time datetime;

    set start_time = now();
    select '>>>Truncating table datawarehouse_bronze.crm_prd_info' as '';
    truncate table crm_prd_info;
    set end_time = now();
    select concat('>>>Time taken(seconds):', timestampdiff(second, start_time, end_time)) as '';

    select '>>>Manually loading prd_info' as '';

end$$

delimiter ;

call load_bronze_prd_info();

load data infile '/var/lib/mysql/source_crm/prd_info.csv'
into table datawarehouse_bronze.crm_prd_info
fields terminated by ','
ignore 1 lines
(@prd_id, @prd_key, @prd_nm, @prd_cost, @prd_line, @prd_start_dt, @prd_end_dt)
set 
    prd_id = nullif(@prd_id, ''),
    prd_key = nullif(@prd_key, ''),
    prd_nm = nullif(@prd_nm, ''),
    prd_cost = nullif(@prd_cost, ''),
    prd_line = nullif(@prd_line, ''),
    prd_start_dt = str_to_date(nullif(@prd_start_dt, ''), '%Y-%m-%d'),
    prd_end_dt = str_to_date(nullif(@prd_end_dt, ''), '%Y-%m-%d');


/*=============================================================
    Load sales_details table 
/*=============================================================*/

delimiter $$

create or replace procedure load_bronze_sales_details()
begin

    declare start_time datetime;
    declare end_time datetime;

    set start_time = now();
    select '>>>Truncating table datawarehouse_bronze.crm_sales_details' as '';
    truncate table crm_sales_details;
    set end_time = now();
    select concat('>>Time taken(seconds):', timestampdiff(second, start_time, end_time)) as '';

    select '>>>Manually loading sales_details' as '';

end$$

delimiter ;

call load_bronze_sales_details();

load data infile '/var/lib/mysql/source_crm/sales_details.csv'
into table datawarehouse_bronze.crm_sales_details
fields terminated by ','
ignore 1 lines
(@sls_ord_num, @sls_prd_key, @sls_cust_id, @sls_order_dt, @sls_ship_dt, @sls_due_dt, @sls_sales, @sls_quantity, @sls_price)
set 
    sls_ord_num = nullif(@sls_ord_num, ''),
    sls_prd_key = nullif(@sls_prd_key, ''),
    sls_cust_id = nullif(@sls_cust_id, ''),
    sls_order_dt = str_to_date(nullif(@sls_order_dt, ''), '%Y%m%d'),
    sls_ship_dt = str_to_date(nullif(@sls_ship_dt, ''), '%Y%m%d'),
    sls_due_dt = str_to_date(nullif(@sls_due_dt, ''), '%Y%m%d'),
    sls_sales = nullif(@sls_sales, ''),
    sls_quantity = nullif(@sls_quantity, ''),
    sls_price = nullif(@sls_price, '');

-- data cleaning is HELL
