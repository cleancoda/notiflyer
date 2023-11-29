if object_id('notiflyer_spStagingPrepare') is not null
    print 'notiflyer_spStagingPrepare stored procedure exists, skipping create attempt..'
    print 'ignore error below, cannot create exception handling on ddl statements'
    return;
go

create procedure notiflyer_spStagingPrepare
/*
    @author     cleancoda
    @date       11212023
    @detail     
    @sample
                exec notiflyer_spStagingPrepare
                    @query_select = ''
                    ,@query_from = ''
                    ,@query_where = ''
                    ,@query_groupby = ''
                    ,@returnvalue = 0
                    ,@returnmessage = '';
    @log
                cc  11212023 - generated basic script file
*/
(
    @query_select as nvarchar(max) = ''
    ,@query_from as nvarchar(max) = ''
    ,@query_where as nvarchar(max) = ''
    ,@query_groupby as nvarchar(max) = ''
    ,@column_axes_x as nvarchar(max) = ''
    ,@column_axes_y as nvarchar(max) = ''
    ,@returnvalue as int = 0 output
    ,@returnmessage as nvarchar(255) = '' output
)
as
begin
    begin try

        -- parse query to ensure no errors occur past this point        
        exec notiflyer_spParseQuery
            @query_select = @query_select
            ,@query_from = @query_from
            ,@query_parsed = @returnvalue output
            ,@query_output = @returnmessage output ;

        -- if query does not parse, return an error
        if(@returnvalue <> 0)
        begin
            return;
        end;

        -- generate and store metadata into global temp table ##tmpNotiflyer_tbMetaDataColumns
        exec notiflyer_spGetMetaData
                    @query_select = @query_select
                    ,@query_from = @query_from;

        select * from ##tmpNotiflyer_tbMetaDataColumns;

        declare @queryexecuted as int = 0,  @queryoutput nvarchar(max) = '';

        exec notiflyer_spExecuteQuery
            @query_select = 'select *'
            ,@query_from = 'from Sales.Customers'
            ,@query_executed = @queryexecuted output
            ,@query_output = @queryoutput output ;

        select @queryexecuted, @queryoutput;

        select * from ##tmpNotiflyer_tbQueryResults;

        -- mark parse results as success
        select 
            @returnvalue = 0
            ,@returnmessage = 'query staging successfully completed.';
    end try

    begin catch
        select
            -- mark staging process as error
            @returnvalue = 1
            ,@returnmessage = 'error occured: ['
                            +  ' error_line: ' + try_cast(error_line() as nvarchar(max))
                            +  ' error_number: ' + try_cast(error_number() as nvarchar(max))
                            +  ' error_message: ' + try_cast(error_message() as nvarchar(max))
                            +  ' ]'
    end catch 
end