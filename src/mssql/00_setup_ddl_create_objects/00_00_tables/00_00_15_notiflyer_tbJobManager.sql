/*
    @author     cleancoda
    @date       07072024
    @detail     creates new sql table notiflyer_tbJobManager
    @log
                cc  07072024 - generated basic script file
*/

-- notiflyer_tbJobManager
-- holds job configuration properties
print 'creating table notiflyer_tbJobManager'
if object_id('notiflyer_tbJobManager') is not null
begin
    print 'table exists skipping create attempt..'
end
else
begin
    create table notiflyer_tbJobManager
    (
        id int identity(1,1) primary key
        ,name varchar(max) default ''
        ,description varchar(max) default ''
        ,active_yn bit default 0
        ,email_subject varchar(max) default ''
        ,email_recepient varchar(max) default ''
        ,email_cc varchar(max) default ''
        ,email_bcc varchar(max) default ''
        ,email_body_header varchar(max) default ''
        ,frequency varchar(max) default 'DAILY'  -- "HOURLY","DAILY", "WEEKLY", "MONTHLY", "YEARLY"
        ,run_time varchar(5) default '02:00' -- job run time hh:mm - follows 24 hours pattern -- hourly jobs will use this as an interval
        ,run_day_monday bit default 0
        ,run_day_tuesday bit default 0
        ,run_day_wednesday bit default 0
        ,run_day_thursday bit default 0
        ,run_day_friday bit default 0
        ,run_day_saturday bit default 0
        ,run_day_sunday bit default 0
    );
end
go  