#!/bin/bash

# requires sqlcmd to run
# download - https://learn.microsoft.com/en-us/sql/linux/sql-server-linux-setup-tools?view=sql-server-ver16&tabs=ubuntu-install#install-tools-on-linux

DATABASE='WideWorldImporters'
USER='SA'
PASSWORD='<YourNewStrong@Passw0rd>'
HOST='192.168.50.150'
PORT='2342'

# create tables
for SQL_FILE in $(find 00_setup_ddl_create_objects/00_00_tables -name "*.sql" | sort -n)
do
    sqlcmd -S $HOST,$PORT -U $USER -P $PASSWORD -d $DATABASE -i $SQL_FILE
done

# create views
for SQL_FILE in $(find 00_setup_ddl_create_objects/00_01_views -name "*.sql" | sort -n)
do
    sqlcmd -S $HOST,$PORT -U $USER -P $PASSWORD -d $DATABASE -i $SQL_FILE
done

# create functions
for SQL_FILE in $(find 00_setup_ddl_create_objects/00_02_functions -name "*.sql" | sort -n)
do
    sqlcmd -S $HOST,$PORT -U $USER -P $PASSWORD -d $DATABASE -i $SQL_FILE
done

# create stored procedures
for SQL_FILE in $(find 00_setup_ddl_create_objects/00_03_procedures -name "*.sql" | sort -n)
do
    sqlcmd -S $HOST,$PORT -U $USER -P $PASSWORD -d $DATABASE -i $SQL_FILE
done

# create triggers
for SQL_FILE in $(find 00_setup_ddl_create_objects/00_04_triggers -name "*.sql" | sort -n)
do
    sqlcmd -S $HOST,$PORT -U $USER -P $PASSWORD -d $DATABASE -i $SQL_FILE
done