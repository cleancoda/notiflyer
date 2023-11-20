if object_id('notiflyer_spExecuteQuery') is not null
    print 'notiflyer_spExecuteQuery stored procedure exists, skipping create attempt..'
    print 'ignore error below, cannot create exception handling on ddl statements'
    return;
go

create procedure notiflyer_spExecuteQuery
/*
    @author     cleancoda
    @date       11202023
    @detail     procedure processes and generates dataset from the query passed as a parameter to
                returns a dataset table with only the columns required
    @sample
    @log
                cc  11202023 - generated basic script file
*/
(
    @query_select as nvarchar(max) = ''
    ,@query_from as nvarchar(max) = ''
    ,@query_where as nvarchar(max) = ''
    ,@query_groupby as nvarchar(max) = ''
) 
as
begin
    begin try
        
    end try
    begin catch
        select
            error_line() as 'error_line'
            ,error_number() as 'error_number'
            ,error_severity() as 'error_severity'
            ,error_message() as 'error_message'
            ,error_procedure() as 'error_procedure'
            ,error_state() as 'error_state';
    end catch

end