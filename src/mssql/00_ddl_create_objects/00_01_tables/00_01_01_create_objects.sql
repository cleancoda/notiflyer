/*
    @author     cleancoda
    @date       10172023
    @detail     drops base sql stored procedures executed by app
    @log
                cc  10112023 - generated basic script file
*/

-- notiflyer_tbAppConfig
create table notiflyer_tbAppConfig
(
    id int identity(1,1)
    ,name varchar(max) null
    ,value varchar(max) null
)

-- notiflyer_tbAppLog