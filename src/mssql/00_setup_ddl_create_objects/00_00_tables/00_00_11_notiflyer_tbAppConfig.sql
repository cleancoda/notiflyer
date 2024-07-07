/*
    @author     cleancoda
    @date       07072024
    @detail     creates new sql table notiflyer_tbAppConfig
    @log
                cc  07072024 - generated basic script file
*/

-- notiflyer_tbAppConfig
-- holds configuration properties
print 'creating table notiflyer_tbAppConfig'
if object_id('notiflyer_tbAppConfig') is not null
begin
    print 'table exists skipping create attempt..'
end
else
begin
    create table notiflyer_tbAppConfig
    (
        id int identity(1,1) primary key
        ,name varchar(max) default ''
        ,value varchar(max) default ''
    );
end
go