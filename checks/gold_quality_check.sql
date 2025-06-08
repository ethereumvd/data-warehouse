/*
================================================================
Purpose:
    This script performs various quality checks for data 
    consistency, accuracy, standardization for the gold layer
    this script checks for
    - Null or duplicate primary keys.
    - Data standardization and consistency.
    - Invalid date ranges and orders.

Note:
    These checks must be run after loading data into the 
    gold layer and any discrepancies must be resolved
================================================================
*/



/*=============================================================
    Check dimension_customers
=============================================================*/

--checking for duplicates in dimension customers
select 
    customer_key,
    count(*) as duplicate
from datawarehouse_gold.dimension_customers
group by customer_key
having count(*) > 1;



/*=============================================================
    Check dimension_products 
=============================================================*/

--checking for duplicates in dimension products
select 
    product_key,
    count(*) as duplicate
from datawarehouse_gold.dimension_products
group by product_key
having count(*) > 1;



/*=============================================================
    Check facts_sales_details 
=============================================================*/

--checking for integrity of dimension keys
select 
    *
from datawarehouse_gold.facts_sales_details as s
left join datawarehouse_gold.dimension_customers as dc
    on s.customer_key = dc.customer_key
left join datawarehouse_gold.dimension_products as dp
    on s.product_key = dp.product_key

where dp.product_key is null or dc.customer_key is null;
