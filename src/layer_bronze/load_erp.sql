/*
=============================================================
Purpose :- 
    
    This script loads all erp data from the csv files to  
    the tables in datawarehouse_bronze using 
    LOAD DATA INFILE

Note :- 
    
    The actual data loading happens outside the stored 
    procedure because MariaDB / MySQL doesnt allow
    load data infile inside a stored procedure 

=============================================================
*/

use datawarehouse_bronze ;

/*=============================================================
    Load erp_cust_az12 table 
/*=============================================================*/

delimiter $$

create or replace procedure load_bronze_cust_az12()
begin

    declare start_time datetime;
    declare end_time datetime;

    set start_time = now();
    select '>>>Truncating table datawarehouse_bronze.erp_cust_az12' as '';
    truncate table erp_cust_az12;
    set end_time = now();
    select concat('>>>Time taken(secnds):', timestampdiff(second, start_time, end_time)) as '';

    select '>>>Manually loading cust_az12' as '';

end$$

delimiter ;

call load_bronze_cust_az12();

load data infile '/var/lib/mysql/source_erp/cust_az12.csv'
into table datawarehouse_bronze.erp_cust_az12
fields terminated by ','
ignore 1 lines
(@cid, @bdate, @gen) 
set 
    cid = nullif(@cid, ''),
    bdate = str_to_date(nullif(@bdate, ''), '%Y-%m-%d'),
    gen = nullif(@gen, '');


/*=============================================================
    Load erp_loc_a101 table 
/*=============================================================*/

delimiter $$

create or replace procedure load_bronze_loc_a101()
begin

    declare start_time datetime;
    declare end_time datetime;

    set start_time = now();
    select '>>>Truncating datawarehouse_bronze.erp_loc_a101' as '';
    truncate table erp_loc_a101;
    set end_time = now();
    select concat('>>>Time taken(seconds):', timestampdiff(second, start_time, end_time)) as '';

    select '>>>Manually loading loc_a101' as '';

end$$

delimiter ;

call load_bronze_loc_a101();

load data infile '/var/lib/mysql/source_erp/loc_a101.csv'
into table datawarehouse_bronze.erp_loc_a101 
fields terminated by ','
ignore 1 lines
(@cid, @cntry)
set 
    cid = nullif(@cid, ''),
    cntry = nullif(@cntry, '');


/*=============================================================
    Load erp_px_cat_g1v2 table 
/*=============================================================*/

delimiter $$

create or replace procedure load_bronze_px_cat_g1v2()
begin

    declare start_time datetime;
    declare end_time datetime;

    set start_time = now();
    select '>>>Truncating datawarehouse_bronze.erp_px_cat_g1v2' as '';
    truncate table erp_px_cat_g1v2 ;
    set end_time = now();
    select concat('>>>Time taken(seconds):', timestampdiff(second, start_time, end_time)) as '';

    select '>>>Manually loading px_cat_g1v2' as '' ;

end$$

delimiter ;

call load_bronze_px_cat_g1v2();

load data infile '/var/lib/mysql/source_erp/px_cat_g1v2.csv'
into table datawarehouse_bronze.erp_px_cat_g1v2 
fields terminated by ','
ignore 1 lines
(@id, @cat, @subcat, @maintenance)
set
    id = nullif(@id, ''),
    cat = nullif(@cat, ''),
    subcat = nullif(@subcat, ''),
    maintenance = nullif(@maintenance, '');
