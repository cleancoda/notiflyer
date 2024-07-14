/*
    @author     cleancoda
    @date       07072024
    @detail     creates new sql table notiflyer_tbJobQueryGridParameters
    @log
                cc  07072024 - generated basic script file
*/

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