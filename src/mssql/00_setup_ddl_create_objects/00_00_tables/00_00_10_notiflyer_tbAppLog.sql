/*
    @author     cleancoda
    @date       07072024
    @detail     creates new sql table notiflyer_tbAppLog
    @log
                cc  07072024 - generated basic script file
*/

-- notiflyer_tbAppLog
-- track every activity of the application - from create to configuration to job execution
print 'creating table notiflyer_tbLogApp'
if object_id('notiflyer_tbLogApp') is not null
begin
    print 'table exists skipping create attempt..'
end
else
begin
    create table notiflyer_tbLogApp
    (
        id int identity(1,1) primary key
        ,log_datetime smalldatetime default getdate()
        ,log_description varchar(max) default ''
        ,log_type char(1) default 'i' -- (i)nfo, (w)arning, (e)rror
        ,log_source varchar(max) default ''
        ,log_user varchar(max) default ''
    );
end