/*
    @author     cleancoda
    @date       11052023
    @detail     generates a backup object of the one about to be droped
    @log
                cc  11052023 - generated basic script file
*/

declare @year as nvarchar(4) = try_cast(year(getdate()) as nvarchar(4));
print '----------------------------------------'
print '             notiflyer                  '
print '             (c) cleancoda '+@year+'    '
print '----------------------------------------'
print 'running script: 00_00_00_backup_if_exists.sql'
print 'backing up custom notiflyer objects' 

-- variables
declare
    @backup_name as nvarchar(max)
    ,@sqlcmd as nvarchar(max);

-- get current timestamp
select
    @backup_name += '_backup' + try_cast(format(getdate(), '_MMddyyyy_hhmmss') as nvarchar(15));

-- drop temp table
if object_id('tempdb..#tmpNotiflyer_tbBackupObjects') is not null
    begin
        drop table #tmpNotiflyer_tbBackupObjects;
    end
-- generate list of objects
select
    *
into 
    #tmpNotiflyer_tbBackupObjects
from
    information_schema.TABLES
where
    -- filter on notiflyer labeled objects
    TABLE_NAME like 'notiflyer_tb%'
    -- exclude backup objects
    and TABLE_NAME not like '_backup_'

-- list objects
select
    *
from
    #tmpNotiflyer_tbBackupObjects;
