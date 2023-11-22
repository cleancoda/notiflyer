/*
    @author     cleancoda
    @date       11052023
    @detail     generates a backup object of the one about to be droped
    @log
                cc  11052023 - generated basic script file
*/

-- variables
declare
    @backup_name as nvarchar(max)
    ,@sqlcmd as nvarchar(max);

-- get current timestamp
select
    @backup_name += '_backup' + try_cast(format(getdate(), '_MMddyyyy_hhmmss') as nvarchar(15));

-- drop temp table
if object_id('tempdb..#tmpNotiflyer_tbBackupObjects') is not null
    drop table #tmpNotiflyer_tbBackupObjects;

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

-- 
select * from #tmpNotiflyer_tbBackupObjects