/*
    @author     cleancoda
    @date       10172023
    @detail     creates new sql tables
    @log
                cc  10112023 - generated basic script file
*/

-- TODO: normalization (3NF - every non-key attribute must provide a fact about the key attribute, the whole key, and nothing but the key. - so help me codd.)

-- notiflyer_tbAppLog
-- track every activity of the application - from create to configuration to job execution
print 'creating table notiflyer_tbAppLog'
if object_id('notiflyer_tbAppLog') is not null
begin
    print 'table exists skipping create attempt..'
end
else
begin
    create table notiflyer_tbLogApp
    (
        id int identity(1,1) primary key
        ,
    );
end

-- notiflyer_tbAppConfig
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

-- notiflyer_tbQuery
print 'creating table notiflyer_tbQuery'
if object_id('notiflyer_tbQuery') is not null
begin
    print 'table exists skipping create attempt..'
end
else
begin
    create table notiflyer_tbQuery
    (
        id int identity(1,1) primary key
        ,name varchar(max) default ''
        ,type char(1) default 'q'
        ,query_select varchar(max) default ''
        ,query_from varchar(max) default ''
        ,query_where varchar(max) default ''
        ,query_group_by varchar(max) default ''
        ,query_order_by varchar(max) default ''
        ,chart_column_legend varchar(max) default ''
        ,chart_column_axes_x varchar(max) default ''
        ,chart_column_axes_y varchar(max) default ''
        ,chart_graphtype varchar(max) default ''
    );
end
go

-- notiflyer_tbJobManager
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
        ,active_yn char(1) default 'n'
        ,email_subject varchar(max) default ''
        ,email_recepient varchar(max) default ''
        ,email_cc varchar(max) default ''
        ,email_bcc varchar(max) default ''
        ,email_body_header varchar(max) default ''
        ,frequency char(1) default 'd'  -- (h)ourly, (d)aily, (w)eekly, (m)onthly
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

-- notiflyer_tbJobQueryGrid
print 'creating table notiflyer_tbJobQueryGrid'
if object_id('notiflyer_tbJobQueryGrid') is not null
begin
    print 'table exists skipping create attempt..'
end
else
begin
    create table notiflyer_tbJobQueryGrid
    (
        id int identity(1,1) primary key
        ,name varchar(255) default ''
        ,job_id int foreign key references notiflyer_tbJobManager(id)
        ,query_id int default null foreign key references notiflyer_tbQuery(id)
        ,grid_row int default 0
        ,grid_column int default 0
        ,label_header varchar(max) default ''
    );
end
go

-- notiflyer_tbJobQueryGridParameters
print 'creating table notiflyer_tbJobQueryGridParameters'
if object_id('notiflyer_tbJobQueryGridParameters') is not null
begin
    print 'table exists skipping create attempt..'
end
else
begin
    create table notiflyer_tbJobQueryGridParameters
    (
        id int identity(1,1) primary key
        ,job_query_grid_id int foreign key references notiflyer_tbJobQueryGrid(id)
        ,parameter_name varchar(255) default ''
        ,parameter_value varchar(255) default ''
    );
end
go

-- notiflyer_tbAppLog
print 'creating table notiflyer_tbAppLog'
if object_id('notiflyer_tbAppLog') is not null
begin
    print 'table exists skipping create attempt..'
end
else
    begin
    create table notiflyer_tbAppLog
    (
        id int identity(1,1) primary key
        ,job_id int foreign key references notiflyer_tbJobManager(id)
        ,job_status bit default 0
        ,log_datetime smalldatetime default getdate()
        ,log_description varchar(max) default ''
    );
end
go