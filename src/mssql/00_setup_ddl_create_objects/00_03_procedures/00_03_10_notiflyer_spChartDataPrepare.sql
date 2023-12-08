if object_id('notiflyer_spChartDataPrepare') is not null
    print 'notiflyer_spChartDataPrepare stored procedure exists, skipping create attempt..'
    print 'ignore error below, cannot create exception handling on ddl statements'
    return;
go

-- drop procedure notiflyer_spChartDataPrepare
create procedure notiflyer_spChartDataPrepare
/*
    @author     cleancoda
    @date       11212023
    @detail     
    @sample
                declare
                    @returnvalue as int = 0
                    ,@returnmessage as nvarchar(255) = '';

                exec notiflyer_spChartDataPrepare
                    @query_select = 'SELECT
                                            C.CustomerName
                                            ,COUNT( DISTINCT A.OrderId) TotalNBOrders' 
                                            
                    ,@query_from = 'FROM 
                                    (
                                        SELECT O.CustomerID, O.OrderId, NULL AS InvoiceID, OL.UnitPrice, OL.Quantity, 0 AS UnitPriceI, 0 AS QuantityI, OL.OrderLineID, NULL AS InvoiceLineID 
                                        FROM Sales.Orders As O, Sales.OrderLines AS OL
                                        WHERE O.OrderId = OL.OrderID AND EXISTS
                                        (	SELECT II.OrderId
                                            FROM Sales.Invoices AS II
                                            WHERE II.OrderID = O.OrderID
                                        )
                                        UNION
                                        SELECT I.CustomerID, NULL AS OrderId, I.InvoiceID, 0 AS UnitPriceO, 0 AS QuantityO, IL.UnitPrice, IL.Quantity, NULL AS OrderLineID, InvoiceLineID
                                        FROM Sales.Invoices AS I, Sales.InvoiceLines AS IL
                                        WHERE I.InvoiceID = IL.InvoiceID
                                    ) AS A, Sales.Customers As C'
                    ,@query_where = 'WHERE A.CustomerID = C.CustomerID'
                    ,@query_groupby = 'GROUP BY C.CustomerName'
                    ,@query_orderby = 'ORDER BY TotalNBOrders DESC, CustomerName'
                    ,@column_axes_x = 'CustomerName'
                    ,@column_axes_y = 'TotalNBOrders'
                    ,@returnvalue = @returnvalue output
                    ,@returnmessage = @returnmessage output;                    

                select  
                    @returnvalue
                    ,@returnmessage;
                
    @log
                cc  11212023 - generated basic script file
*/
(
    @query_select as nvarchar(max) = ''
    ,@query_from as nvarchar(max) = ''
    ,@query_where as nvarchar(max) = ''
    ,@query_groupby as nvarchar(max) = ''
    ,@query_orderby as nvarchar(max) = ''
    ,@column_axes_x as nvarchar(max) = ''
    ,@column_axes_y as nvarchar(max) = ''
    ,@returnvalue as int = 0 output
    ,@returnmessage as nvarchar(255) = '' output
)
as
begin
    begin try

        -- clear up temp tables
        if object_id('tempdb..##tmpNotiflyer_tbMetaDataColumns') is not null 
            drop table ##tmpNotiflyer_tbMetaDataColumns

        if object_id('tempdb..##tmpNotiflyer_tbMetaDataColumns') is not null 
            drop table ##tmpNotiflyer_tbMetaDataColumns

        if object_id('tempdb..##tmpnotiflyer_tbChartData') is not null 
            drop table ##tmpnotiflyer_tbChartData

        -- global variables
        declare 
            @column_axes_x_datatype as nvarchar(max)
            ,@column_axes_y_datatype as nvarchar(max)
            ,@sqlvar as nvarchar(max) -- temporary variable
            ,@sqlcmd as nvarchar(max); -- temporary commands

        -- parse query to ensure no errors occur past this point      
        exec notiflyer_spParseQuery
            @query_select = @query_select
            ,@query_from = @query_from
            ,@query_where = @query_where
            ,@query_groupby = @query_groupby
            ,@query_orderby = @query_orderby
            ,@query_parsed = @returnvalue output
            ,@query_output = @returnmessage output;

        -- if query does not parse, return an error
        if(@returnvalue <> 0)
        begin
            return;
        end;

        -- generate and store metadata into global temp table ##tmpNotiflyer_tbMetaDataColumns
        exec notiflyer_spGetMetaData
            @query_select = @query_select
            ,@query_from = @query_from
            ,@query_where = @query_where
            ,@query_groupby = @query_groupby
            ,@query_orderby = @query_orderby
            ,@returnvalue = @returnvalue output
            ,@returnmessage = @returnmessage output;

        -- results stored in ##tmpNotiflyer_tbMetaDataColumns
        -- select * from ##tmpNotiflyer_tbMetaDataColumns;                    

        -- capture data types for cartesian axes columns
        -- x axes
        select
            @column_axes_x_datatype = system_type_name
        from
            ##tmpNotiflyer_tbMetaDataColumns
        where
            name = @column_axes_x;

        -- y axes
        select
            @column_axes_y_datatype = system_type_name
        from
            ##tmpNotiflyer_tbMetaDataColumns
        where
            name = @column_axes_y;

        -- execute query and store results into global temp table ##tmpNotiflyer_tbQueryExecuteResults
        exec notiflyer_spExecuteQuery
            @query_select = @query_select
            ,@query_from = @query_from
            ,@query_where = @query_where
            ,@query_groupby = @query_groupby
            ,@query_orderby = @query_orderby
            ,@query_executed = @returnvalue output
            ,@query_output = @returnmessage output;

        -- build convert command for results
        select  
            @sqlcmd = 
                        'select '
                        + case 
                            when @column_axes_x_datatype like '%char%' then
                                '''' + @column_axes_x + ''''
                            else
                                @column_axes_x
                        end + 'as [' + @column_axes_x + ']'
                        + ', '
                        + case 
                            when @column_axes_y_datatype like '%char%' then
                                '''' + @column_axes_y + ''''
                            else
                                @column_axes_y
                        end + 'as [' + @column_axes_y + ']'
                        + 'from '
                        + '##tmpNotiflyer_tbQueryExecuteResults';


        -- prep create table statement for chart data
		select
			@sqlcmd = 'create table ##tmpnotiflyer_tbChartData ( datacolumn_x ' + @column_axes_x_datatype + ' , datacolumn_y ' + case when isnull(@column_axes_y_datatype,'') <> '' then  + @column_axes_y_datatype else 'varchar(10)' end  + ' );';

        -- execute create statement
        exec(@sqlcmd);

        -- TODO:
        -- issue #64 - https://github.com/cleancoda/notiflyer/issues/64
        -- replace with cursor to loop through multiple series of data;
        -- prep insert select statement for copying data plot points from ##tmpNotiflyer_tbQueryExecuteResults into ##tmpnotiflyer_tbChartData -- order by query
		select @sqlcmd = 'select ' + @column_axes_x + ' ,' + case when isnull(@column_axes_y,'') <> '' then + @column_axes_y else '''''' end +  ' from ##tmpNotiflyer_tbQueryExecuteResults ' + @query_orderby;

		-- insert data for X/Y values into new temp table
		insert into ##tmpnotiflyer_tbChartData
		exec(@sqlcmd);

        -- append ' on string values for axes labels
        -- x axes
        select
            @sqlvar = case when @column_axes_x_datatype like '%char%' then '''' else '' end;

        update ##tmpnotiflyer_tbChartData
        set
            datacolumn_x = @sqlvar + datacolumn_x + @sqlvar;

        -- append ' on string values for axes labels
        -- y axes
        select
            @sqlvar = case when @column_axes_y_datatype like '%char%' then '''' else '' end;

        update ##tmpnotiflyer_tbChartData
        set
            datacolumn_y = @sqlvar + datacolumn_y + @sqlvar;

        select * from ##tmpnotiflyer_tbChartData

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