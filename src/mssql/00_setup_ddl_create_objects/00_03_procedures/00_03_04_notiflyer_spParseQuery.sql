if object_id('notiflyer_spParseQuery') is not null
    print 'notiflyer_spParseQuery stored procedure exists, skipping create attempt..'
    print 'ignore error below, cannot create exception handling on ddl statements'
    return;
go

-- drop procedure notiflyer_spParseQuery
create procedure notiflyer_spParseQuery
/*
    @author     cleancoda
    @date       11192023
    @detail     procedure processes and validates the query to be executed to ensure
                no syntax errors occur at run-time
    @sample
                declare @queryparsed as int = 0,  @queryoutput nvarchar(max) = '';
                
                exec notiflyer_spParseQuery
                    @query_select = 'select *'
                    ,@query_from = 'from Sales.Customerss'
                    ,@query_parsed = @queryparsed output
                    ,@query_output = @queryoutput output ;

                select @queryparsed, @queryoutput;
    @log
                cc  11192023 - generated basic script file
*/
(
    @query_select as nvarchar(max) = ''
    ,@query_from as nvarchar(max) = ''
    ,@query_where as nvarchar(max) = ''
    ,@query_group_by as nvarchar(max) = ''
    ,@query_order_by as nvarchar(max) = ''
    ,@query_parsed as int = 0 output
    ,@query_output as nvarchar(max) output
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
        @query as nvarchar(max);
    
     -- build local query
    select
        @query = @query_select + ' ' + @query_from + ' ' + @query_where + ' ' + @query_group_by + ' ' + @query_order_by;

    -- parse query and validate
    -- enable sandbox to execute query 
    -- ref: https://github.com/cleancoda/notiflyer/issues/45#issuecomment-1806892559
    -- alternative: using 'set' - parseonly, noexec, fmtonly - however capturing error messages in dynamic sql is challenging
    
        begin try
            -- execute query in sandbox (ignore results, except error or success message)
            exec sp_executesql
                @query
                ,@queryoutput = @query_output output;
            
            -- mark parse results as success
            select 
                @query_parsed = 0
                ,@query_output = 'query successfully parsed.';
        end try
        begin catch
            select
                -- mark parse results as error
                @query_parsed = 1
                ,@query_output = 'error occured: ['
                                +  ' error_line: ' + try_cast(error_line() as nvarchar(max))
                                +  ' error_number: ' + try_cast(error_number() as nvarchar(max))
                                +  ' error_message: ' + try_cast(error_message() as nvarchar(max))
                                +  ' ]'
        end catch  
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
    return;
end
go