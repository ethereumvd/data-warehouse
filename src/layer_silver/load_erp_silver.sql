/*
================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform,
    Load) process to populate the ERP tables in the 
    datawarehouse_silver database from the datawarehouse_bronze
    database

Warning:
    Runnig this stored procedure will truncate all the erp
    tables present in the datawarehouse_silver database

Usage Example:
    call load_erp_silver();
================================================================
*/

use datawarehouse_silver ;

delimiter $$

create or replace procedure load_erp_silver()
begin

    declare start_time datetime;
    declare end_time datetime;

    declare exit handler for sqlexception
    begin
        select '!!! An Error Occured !!!' as '';
    end;

    select '>>>Loading ERP tables into Silver Layer' as '';

    set start_time = now();
    select '>>>Loading erp_cust_az12' as '';
    select '>>>Truncating datawarehouse_silver.erp_cust_az12' as '';
    truncate datawarehouse_silver.erp_cust_az12;
    select '>>>Inserting into datawarehouse_silver.erp_cust_az12' as '';
    insert into datawarehouse_silver.erp_cust_az12(
        cid, 
        bdate,
        gen
    )
    select
        case 
            when trim(cid) like 'NAS%' then substring(trim(cid), 4, length(trim(cid)))
            else cid
        end as cid,
        case 
            when bdate > now() then null
            else bdate
        end as bdate,
        case 
            when lower(trim(gen)) in ('f', 'female') then 'Female'
            when lower(trim(gen)) in ('m', 'male') then 'Male'
            else 'N/A'
        end as gen
    from datawarehouse_bronze.erp_cust_az12;
    set end_time = now();
    select concat('>>>Time taken(seconds):', timestampdiff(second, start_time, end_time)) as '';


    set start_time = now();
    select '>>>Loading erp_loc_a101' as '';
    select '>>>Truncating datawarehouse_silver.erp_loc_a101' as '';
    truncate datawarehouse_silver.erp_loc_a101;
    select '>>>Inserting into datawarehouse_bronze.erp_loc_a101' as '';
    insert into datawarehouse_silver.erp_loc_a101(
        cid, 
        cntry
    )
    select
        replace(cid, '-', '') as cid,
        case 
            when trim(cntry) = 'DE' then 'Germany'
            when trim(cntry) in ('US', 'USA') then 'United States'
            when trim(cntry) = '' or cntry is null then 'N/A'
            else trim(cntry)
        end as cntry
    from datawarehouse_bronze.erp_loc_a101;
    set end_time = now();
    select concat('>>>Time taken(seconds):', timestampdiff(second, start_time, end_time)) as '';

    
    set start_time = now();
    select '>>>Loading erp_px_cat_g1v2' as '';
    select '>>>Truncating datawarehouse_silver.erp_px_cat_g1v2' as '';
    truncate datawarehouse_silver.erp_px_cat_g1v2;
    select '>>>Inserting into datawarehouse_silver.erp_px_cat_g1v2' as '';
    insert into datawarehouse_silver.erp_px_cat_g1v2(
        id, 
        cat,
        subcat,
        maintenance
    ) 
    select 
        id, 
        trim(cat) as cat,
        trim(subcat) as subcat,
        maintenance
    from datawarehouse_bronze.erp_px_cat_g1v2;
    set end_time = now();
    select concat('>>>Time taken(seconds): ', timestampdiff(second, start_time, end_time)) as '';

end$$

delimiter ;
