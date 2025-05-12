#!/bin/bash

# requires sqlcmd to run
# download - https://learn.microsoft.com/en-us/sql/linux/sql-server-linux-setup-tools?view=sql-server-ver16&tabs=ubuntu-install#install-tools-on-linux

# Check if sqlcmd is installed
if ! command -v sqlcmd &> /dev/null
then
    echo "sqlcmd is not installed on this machine."
    read -p "Would you like to install sqlcmd? (yes/no): " INSTALL_CHOICE
    if [ "$INSTALL_CHOICE" = "yes" ]; then
        echo "Installing sqlcmd..."
        # Add installation commands for sqlcmd (example for Ubuntu)
        curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
        curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list | sudo tee /etc/apt/sources.list.d/mssql-release.list
        sudo apt-get update
        sudo ACCEPT_EULA=Y apt-get install -y mssql-tools unixodbc-dev
        echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
        source ~/.bashrc
        echo "sqlcmd installed successfully."
    else
        echo "sqlcmd is required to run this script. Exiting."
        exit 1
    fi
fi

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