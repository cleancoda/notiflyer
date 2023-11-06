/*
    @author     cleancoda
    @date       10172023
    @detail     drops base sql stored procedures executed by app
    @log
                cc  10112023 - generated basic script file
*/

-- TODO: normalization (3NF - every non-key attribute must provide a fact about the key attribute, the whole key, and nothing but the key. - so help me codd.)

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
        ,name varchar(max) default null
        ,value varchar(max) default null
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
        ,job_id int default null
        ,job_status bit default 0
        ,log_datetime smalldatetime default getdate()
        ,log_description varchar(max) default null
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
        ,name varchar(max) default null
        ,type char(1) default 'q'
        ,query_select varchar(max) default null
        ,query_from_where varchar(max) default null
        ,column_legend varchar(max) default null
        ,column_x varchar(max) default null
        ,column_y varchar(max) default null
        ,graphtype varchar(max) default null
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
        ,name varchar(max) default null
        ,email_subject varchar(max) default null
        ,email_recepient varchar(max) default null
        ,email_cc varchar(max) default null
        ,email_bcc varchar(max) default null
        ,email_body_header varchar(max) default null
        ,frequency char(1) default null
        ,run_time varchar(5) default null
        ,monday bit default 0
        ,tuesday bit default 0
        ,wednesday bit default 0
        ,thursday bit default 0
        ,friday bit default 0
        ,saturday bit default 0
        ,sunday bit default 0
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
        ,name varchar(255) default null
        ,job_id int foreign key references notiflyer_tbJobManager(id)
        ,query_id int default null foreign key references notiflyer_tbQuery(id)
        ,pos_id int default null
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
        ,name varchar(255) default null
        ,value varchar(255) default null
    );
end
go