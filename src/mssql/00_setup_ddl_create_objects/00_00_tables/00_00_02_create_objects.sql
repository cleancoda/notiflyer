/*
    @author     cleancoda
    @date       10172023
    @detail     creates new sql tables
    @log
                cc  10112023 - generated basic script file
*/

-- TODO: normalization (3NF - every non-key attribute must provide a fact about the key attribute, the whole key, and nothing but the key. - so help me codd.)


/*
    1. look for all files with .sql extension
    2. filter for files with names > 00_00_xx where xx is a number indicating the order of execution
    3. sort the files in ascending order
    4. execute the files in order > 00_00_02_create_objects.sql
*/

-- Enable xp_cmdshell (if not already enabled)
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'xp_cmdshell', 1;
RECONFIGURE;

-- Execute a SQL file using sqlcmd
DECLARE @sqlFilePath NVARCHAR(MAX) = 'C:\path\to\your\sqlfile.sql';
DECLARE @command NVARCHAR(MAX) = 'sqlcmd -S <ServerName> -d <DatabaseName> -E -i "' + @sqlFilePath + '"';

-- Execute the command
EXEC xp_cmdshell @command;

-- Disable xp_cmdshell (optional, for security purposes)
EXEC sp_configure 'xp_cmdshell', 0;
RECONFIGURE;