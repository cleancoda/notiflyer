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

                this procedure should receive a pre-compiled "where" clause with the parameters and their
                corresponding values from notiflyer_tbJobQueryGridParameters table from the main procedure that 
                is calling this in turn to receive a table containing output of the query execution results  
    @sample
                declare @queryexecuted as int = 0,  @queryoutput nvarchar(max) = '';

                exec notiflyer_spExecuteQuery
                    @query_select = 'select *'
                    ,@query_from = 'from Sales.Customers'
                    ,@query_executed = @queryexecuted output
                    ,@query_output = @queryoutput output ;

                select @queryexecuted, @queryoutput;
    @log
                cc  11202023 - generated basic script file
*/
(
    @query_select as nvarchar(max) = ''
    ,@query_from as nvarchar(max) = ''
    ,@query_where as nvarchar(max) = ''
    ,@query_groupby as nvarchar(max) = ''
    ,@display_results as int = 0
    ,@query_executed as int = 0 output
    ,@query_output as nvarchar(255) = '' output
) 
as
begin
    begin try
    -- if no query passed end routine
    if(@query_select = '' or @query_from = '')
        begin
            return;
        end
    
     -- variables
    declare
        @query_prefix as nvarchar(max)
        ,@query as nvarchar(max)
        ,@query_suffix as nvarchar(max);

    -- clear tempdb
    if object_id('tempdb..##tmpNotiflyer_tbQueryResults') is not null 
    drop table ##tmpNotiflyer_tbQueryResults;

    -- drop if temp physical table 
    if object_id('notiflyer_tmpQueryResults') is not null
        drop table notiflyer_tmpQueryResults;

    -- prepare backup statement
    select  
        @query_prefix = 'select * into ##tmpNotiflyer_tbQueryResults from ( '
        ,@query_suffix = ' ) a;';

    -- prepare query to store results in new physical table    
    -- build local query
    select
        @query = @query_prefix + @query_select + ' ' + @query_from + ' ' + @query_where + ' ' + @query_groupby + @query_suffix;

    -- handle exceptions for sp_executesql
    begin try
        -- execute query
        exec sp_executesql
            @query
            ,@queryoutput = @query_output output;
        
        -- mark parse results as success
        select 
            @query_executed = 0
            ,@query_output = 'query successfully executed and stored to table ##tmpNotiflyer_tbQueryResults.';
    end try
    begin catch
        select
            -- mark parse results as error
            @query_executed = 1
            ,@query_output = 'error occured: ['
                            +  ' error_line: ' + try_cast(error_line() as nvarchar(max))
                            +  ' error_number: ' + try_cast(error_number() as nvarchar(max))
                            +  ' error_message: ' + try_cast(error_message() as nvarchar(max))
                            +  ' ]'
    end catch    
    end try
    begin catch
         -- mark parse results as error
         select
            @query_executed = 1
            ,@query_output = 'error occured: ['
                            +  ' error_line: ' + try_cast(error_line() as nvarchar(max))
                            +  ' error_number: ' + try_cast(error_number() as nvarchar(max))
                            +  ' error_message: ' + try_cast(error_message() as nvarchar(max))
                            +  ' ]'
    end catch
end