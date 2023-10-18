/*
    @author     cleancoda
    @date       10172023
    @detail     drops base sql stored procedures executed by app
    @log
                cc  10112023 - generated basic script file
*/

-- TODO: normalization (3NF - every non-key attribute must provide a fact about the key attribute, the whole key, and nothing but the key. - so help me codd.) and 

-- notiflyer_tbAppConfig
create table notiflyer_tbAppConfig
(
    id int identity(1,1)
    ,name varchar(max) null
    ,value varchar(max) null
)

-- notiflyer_tbAppLog
create table notiflyer_tbAppLog
(
    id int identity(1,1)
    ,job_id int
    ,job_status boolean default false
    ,log_datetime smalldatetime default getdate()
    ,log_description varchar(max)
)