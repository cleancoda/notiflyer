/*
    @author     cleancoda
    @date       07072024
    @detail     creates new sql table notiflyer_tbQuery
    @log
                cc  07072024 - generated basic script file
*/

-- notiflyer_tbQuery
-- store queries for use in job creation
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
            ,type varchar(max) default 'q'
            ,query_select varchar(max) default ''
            ,query_from varchar(max) default ''
            ,query_where varchar(max) default ''
            ,query_group_by varchar(max) default ''
            ,query_order_by varchar(max) default ''
            ,chart_column_legend varchar(max) default ''
            ,chart_column_axes_x varchar(max) default ''
            ,chart_column_axes_y varchar(max) default ''
            ,chart_graph_type varchar(max) default ''
        );
end
go