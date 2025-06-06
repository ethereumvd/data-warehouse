/*
=============================================================

Purpose :-
    To create Databases representing each layer of the Data 
    Warehouse in MariaDB / MySQL 

WARNING :- 
    the following DROP DATABASE statements below will
    delete everything inside those databases

=============================================================
*/

drop database if exists datawarehouse_bronze ;
create database datawarehouse_bronze ;

drop database if exists datawarehouse_silver ;
create database datawarehouse_silver ;

drop database if exists datawarehouse_gold ;
create database datawarehouse_gold ;
