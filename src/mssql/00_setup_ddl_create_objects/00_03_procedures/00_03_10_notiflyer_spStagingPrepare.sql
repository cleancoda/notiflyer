if object_id('notiflyer_spStagingPrepare') is not null
    print 'notiflyer_spStagingPrepare stored procedure exists, skipping create attempt..'
    print 'ignore error below, cannot create exception handling on ddl statements'
    return;
go

-- drop procedure notiflyer_spStagingPrepare
create procedure notiflyer_spStagingPrepare
/*
    @author     cleancoda
    @date       11212023
    @detail     
    @sample
                declare
                    @returnvalue as int = 0
                    ,@returnmessage as nvarchar(255) = '';

                exec notiflyer_spStagingPrepare
                    @query_select = 'SELECT A.CustomerId, C.CustomerName,  COUNT( DISTINCT A.OrderId) TotalNBOrders, COUNT( DISTINCT A.InvoiceId) TotalNBInvoices,
                                        SUM(A.UnitPrice*A.Quantity)AS OrdersTotalValue,  SUM(A.UnitPriceI * A.QuantityI) AS InvoicesTotalValue,
                                        ABS(SUM(A.UnitPrice * A.Quantity) -  SUM(A.UnitPriceI*A.QuantityI)) AS AbsoluteValueDifference'
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
                    ,@query_groupby = 'GROUP BY A.CustomerID, C.CustomerName'
                    ,@query_orderby = 'ORDER BY AbsoluteValueDifference DESC, TotalNBOrders, CustomerName'
                    ,@column_axes_x = 'AbsoluteValueDifference'
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

        -- global variables
        declare 
            @column_axes_x_datatype as nvarchar(max)
            ,@column_axes_y_datatype as nvarchar(max)
            ,@output_table as nvarchar(max) -- output of executing query stored in new temp table
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
        select * from ##tmpNotiflyer_tbMetaDataColumns;                    

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

        -- generate output table name for current instance
        select
            @output_table = concat('notiflyer_tbOutputTable_',format(getdate(),'MMddyyyyhhmmss'));

        -- execute query and store results into global temp table ##tmpNotiflyer_tbQueryResults
        exec notiflyer_spExecuteQuery
            @query_select = @query_select
            ,@query_from = @query_from
            ,@query_where = @query_where
            ,@query_groupby = @query_groupby
            ,@query_orderby = @query_orderby
            ,@output_table = @output_table output
            ,@query_executed = @returnvalue output
            ,@query_output = @returnmessage output;

        -- select
        --     @sqlcmd = 'select * from ' + @output_table;

        -- exec(@sqlcmd);      

        select @output_table;  

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