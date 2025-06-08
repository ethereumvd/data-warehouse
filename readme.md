# Data warehouse in SQL

## Limitations  

- MariaDB / MySQL doesnt support schemas so three separate databases for the bronze, silver and gold layer have been created 
 
- As MariaDB / MySQL doesnt support LOAD DATA INFILE inside stored procedures we have to do it outside the stored procedures manually 

- l
