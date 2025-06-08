# Data - Warehouse in SQL

## 📖 Project Overview

This project showcases the end-to-end development of a modern data warehouse solution focused on transforming raw ERP and CRM data into actionable business insights.

###  Key Features & Learning Outcomes

🔹 **SQL Development** – Crafting efficient, optimized SQL queries for analytical use cases.  
🔹 **Data Engineering** – Building resilient ETL workflows for seamless data ingestion and transformation.  
🔹 **ETL Pipeline Development** – Automating data extraction, transformation, and loading across systems.  
🔹 **Data Modeling** – Designing and implementing well-structured fact and dimension tables.  
🔹 **Data Analytics** – Executing advanced queries to support reporting and data-driven decisions.

This repository serves as a practical demonstration of skills required in real-world data engineering and analytics projects, with a focus on clean code, performance, and data quality.This project demonstrates the development of a modern data warehouse leveraging the **Medallion Architecture**, structured into three layers:

1. **Bronze Layer** – Raw data ingestion from source systems (ERP and CRM), stored as-is.
2. **Silver Layer** – Cleansed and integrated datasets, enriched with business logic and relationships.
3. **Gold Layer** – Aggregated and business-ready datasets optimized for analytics and reporting.

- For more details about the Medallion Architecture used, see [architechture.md](https://github.com/ethereumvd/data-warehouse/blob/main/architechture.md) 
- For more details about data model used, see [data_model.md](https://github.com/ethereumvd/data-warehouse/blob/main/data_model.md)


## 📂 File Structure
```
data_warehouse_project
├── architechture.md                --documentation for the medallion architechture 
├── assets
├── checks
│   ├── gold_quality_check.sql      --data quality check for tables in gold layer
│   └── silver_quality_check.sql    --data quality check for tables in silver layer
├── data_model.md                   --documentation for data model across layers
├── datasets                        
│   ├── source_crm                  --crm datasets
│   │   ├── cust_info.csv   
│   │   ├── prd_info.csv
│   │   └── sales_details.csv
│   └── source_erp                  --erp datasets
│       ├── cust_az12.csv
│       ├── loc_a101.csv
│       └── px_cat_g1v2.csv
├── LICENSE
├── readme.md                          
└── src
    ├── ddl_database.sql            --data definition for datawarehouse
    ├── layer_bronze
    │   ├── ddl_bronze_layer.sql    --data definition for bronze layer
    │   ├── load_crm_bronze.sql     --loading crm datasets into bronze layer
    │   └── load_erp_bronze.sql     --loading erp datasets into bronze layer
    ├── layer_gold
    │   └── ddl_gold_layer.sql      --data definition for gold layer
    └── layer_silver
        ├── ddl_silver_layer.sql    --data definition for silver layer
        ├── load_crm_silver.sql     --loading cleaned crm datasets into silver layer
        └── load_erp_silver.sql     --loading cleaned erp datasets into silver layer

```
## ⚠️  Limitations  

- MariaDB / MySQL doesn't support schemas so three separate databases for the bronze, silver and gold layer have been created 
 
- As MariaDB / MySQL doesn't support `LOAD DATA INFILE` inside stored procedures we have to do it outside the stored procedures manually 

Datasets have been taken from [DataWithBaraa](https://www.datawithbaraa.com/wp-content/uploads/2025/01/sql-data-warehouse-project.zip)
