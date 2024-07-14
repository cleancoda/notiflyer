/*
    @author     cleancoda
    @date       07072024
    @detail     creates new sql table notiflyer_tbJobQueryGrid
    @log
                cc  07072024 - generated basic script file
*/

-- notiflyer_tbJobQueryGrid
-- holds job query grid configuration properties
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