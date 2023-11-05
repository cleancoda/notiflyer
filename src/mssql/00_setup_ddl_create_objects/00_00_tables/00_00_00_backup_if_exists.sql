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
    @backup_name = format(getdate(), 'MMddyyyy_hhmmss');

if object_id('notiflyer_tbAppConfig') is not null
    begin
        -- prep sql cmd
        select
            @sqlcmd = 'select * into notiflyer_tbAppConfig_' + @backup_name + ' from notiflyer_tbAppConfig'
        
        -- exec sql cmd
        exec(@sqlcmd);
    end

if object_id('notiflyer_tbAppLog') is not null
    begin
        -- prep sql cmd
        select
            @sqlcmd = 'select * into notiflyer_tbAppLog' + @backup_name + ' from notiflyer_tbAppLog'
        
        -- exec sql cmd
        exec(@sqlcmd);
    end

if object_id('notiflyer_tbQuery') is not null
    begin
        -- prep sql cmd
        select
            @sqlcmd = 'select * into notiflyer_tbQuery' + @backup_name + ' from notiflyer_tbQuery'
        
        -- exec sql cmd
        exec(@sqlcmd);
    end

if object_id('notiflyer_tbJobManager') is not null
    begin
        -- prep sql cmd
        select
            @sqlcmd = 'select * into notiflyer_tbJobManager' + @backup_name + ' from notiflyer_tbJobManager'
        
        -- exec sql cmd
        exec(@sqlcmd);
    end

if object_id('notiflyer_tbJobQueryGrid') is not null
    begin
        -- prep sql cmd
        select
            @sqlcmd = 'select * into notiflyer_tbJobQueryGrid' + @backup_name + ' from notiflyer_tbJobQueryGrid'
        
        -- exec sql cmd
        exec(@sqlcmd);
    end

if object_id('notiflyer_tbJobQueryGridParameters') is not null
    begin
        -- prep sql cmd
        select
            @sqlcmd = 'select * into notiflyer_tbJobQueryGridParameters' + @backup_name + ' from notiflyer_tbJobQueryGridParameters'
        
        -- exec sql cmd
        exec(@sqlcmd);
    end