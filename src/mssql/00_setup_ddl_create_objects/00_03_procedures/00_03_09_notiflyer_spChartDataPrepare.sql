if object_id('notiflyer_spChartDataPrepare') is not null
    print 'notiflyer_spChartDataPrepare stored procedure exists, skipping create attempt..'
    print 'ignore error below, cannot create exception handling on ddl statements'
    return;
go

drop procedure notiflyer_spChartDataPrepare
go

create procedure notiflyer_spChartDataPrepare
/*
    @author     cleancoda
    @date       11212023
    @detail     
    @sample
                declare
                    @returnvalue as int = 0
                    ,@returnmessage as nvarchar(255) = ''
                    ,@column_axes_x_axes_label as varchar(max) = ''
                    ,@column_axes_y_axes_label as varchar(max) = '';

                exec notiflyer_spChartDataPrepare
                    @query_select = 'select top 10 CustomerID,dateadd(month, datediff(month, 0, OrderDate), 0) as OrderMonth,count(1) as TotalAmount' 
                    ,@query_from = 'from WideWorldImporters.Sales.Orders'
                    ,@query_where = 'where PickedByPersonID = 2'
                    ,@query_group_by = 'group by CustomerID ,dateadd(month, datediff(month, 0, OrderDate), 0)'
                    ,@query_order_by = 'order by TotalAmount desc'
                    ,@chart_column_axes_x = 'OrderMonth'
                    ,@chart_column_axes_y = 'TotalAmount'
                    ,@chart_column_axes_x_axes_label = @column_axes_x_axes_label output
                    ,@chart_column_axes_y_axes_label = @column_axes_y_axes_label output
                    ,@returnvalue = @returnvalue output
                    ,@returnmessage = @returnmessage output;                    

                select  
                    @column_axes_x_axes_label
                    ,@column_axes_y_axes_label
                    ,@returnvalue
                    ,@returnmessage;

                select * from ##tmpnotiflyer_tbChartData;

                /*
                    additional queries:

                    select top 10
                        format(dateadd(dd, -( day(o.OrderDate) -1 ), o.OrderDate), "MMM-yyyy", "en-US") as [OrderMth]
                        ,sum(o.OrderID) as [NumOfOrders]
                    from
                        Sales.Orders o
                        left outer join Sales.Customers c on    
                            o.CustomerID = c.CustomerID
                    group by
                    dateadd(dd, -( day(o.OrderDate) -1 ), o.OrderDate)
                    order by    
                        [OrderMth] asc

                    ----

                    SELECT top 5
                        C.CustomerName
                        ,COUNT( DISTINCT A.OrderId) TotalNBOrders
                    FROM 
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
                    ) AS A, Sales.Customers As C
                    WHERE A.CustomerID = C.CustomerID
                    GROUP BY C.CustomerName
                    ORDER BY TotalNBOrders DESC, CustomerName
                */

                /* 
                    -- testing script

                    declare
                        @returnvalue as int = 0
                        ,@returnmessage as nvarchar(255) = ''
                        ,@column_axes_x_axes_label as varchar(max) = ''
                        ,@column_axes_y_axes_label as varchar(max) = '';

                    exec notiflyer_spChartDataPrepare
                        @query_select = 'select top 10 CustomerID,dateadd(month, datediff(month, 0, OrderDate), 0) as OrderMonth,count(1) as TotalAmount' 
                        ,@query_from = 'from WideWorldImporters.Sales.Orders'
                        ,@query_where = 'where PickedByPersonID = 2'
                        ,@query_group_by = 'group by CustomerID ,dateadd(month, datediff(month, 0, OrderDate), 0)'
                        ,@query_order_by = 'order by TotalAmount desc'
                        ,@chart_column_axes_x = 'OrderMonth'
                        ,@chart_column_axes_y = 'TotalAmount'
                        ,@chart_column_axes_x_axes_label = @column_axes_x_axes_label output
                        ,@chart_column_axes_y_axes_label = @column_axes_y_axes_label output
                        ,@returnvalue = @returnvalue output
                        ,@returnmessage = @returnmessage output;                    

                    select  
                        @column_axes_x_axes_label
                        ,@column_axes_y_axes_label
                        ,@returnvalue
                        ,@returnmessage;

                    select * from ##tmpnotiflyer_tbChartData;
                */
                
    @log
                cc  11212023 - generated basic script file
*/
(
    @query_select as nvarchar(max) = ''
    ,@query_from as nvarchar(max) = ''
    ,@query_where as nvarchar(max) = ''
    ,@query_group_by as nvarchar(max) = ''
    ,@query_order_by as nvarchar(max) = ''
    -- filter for ##tmpNotiflyer_tbMetaDataColumns to find metadata for columns
    ,@chart_column_axes_x as nvarchar(max) = ''
    ,@chart_column_axes_y as nvarchar(max) = ''
    -- values to be returned back to caller
    ,@chart_column_axes_x_axes_label as nvarchar(max) = '' output
    ,@chart_column_axes_y_axes_label as nvarchar(max) = '' output
    ,@returnvalue as int = 0 output
    ,@returnmessage as nvarchar(255) = '' output
)
as
begin
    begin try

        -- TODO:
        -- global tables, should be dropped? research
        -- clear up temp tables
        if object_id('tempdb..##tmpNotiflyer_tbMetaDataColumns') is not null 
            drop table ##tmpNotiflyer_tbMetaDataColumns

        if object_id('tempdb..##tmpnotiflyer_tbChartData') is not null 
            drop table ##tmpnotiflyer_tbChartData

        -- global variables
        declare 
            -- data type of columns/axes
            @chart_column_axes_x_datatype as nvarchar(max)
            ,@chart_column_axes_y_datatype as nvarchar(max)
            -- sql vars
            ,@sqlvar as nvarchar(max) -- temporary variable
            ,@sqlcmd as nvarchar(max); -- temporary commands

        -- generate and store metadata into global temp table ##tmpNotiflyer_tbMetaDataColumns
        exec notiflyer_spGetMetaData
            @query_select = @query_select
            ,@query_from = @query_from
            ,@query_where = @query_where
            ,@query_group_by = @query_group_by
            ,@query_order_by = @query_order_by
            ,@returnvalue = @returnvalue output
            ,@returnmessage = @returnmessage output;            

        -- capture data types for cartesian axes columns
        -- x axes
        select
            @chart_column_axes_x_axes_label = name
            ,@chart_column_axes_x_datatype = system_type_name
        from
            ##tmpNotiflyer_tbMetaDataColumns
        where
            name = @chart_column_axes_x;

        -- y axes
        select
            @chart_column_axes_y_axes_label = name
            ,@chart_column_axes_y_datatype = system_type_name
        from
            ##tmpNotiflyer_tbMetaDataColumns
        where
            name = @chart_column_axes_y;

        -- execute query and store results into global temp table ##tmpNotiflyer_tbQueryExecuteResults
        exec notiflyer_spExecuteQuery
            @query_select = @query_select
            ,@query_from = @query_from
            ,@query_where = @query_where
            ,@query_group_by = @query_group_by
            ,@query_order_by = @query_order_by
            ,@query_executed = @returnvalue output
            ,@query_output = @returnmessage output;


        -- TODO:
        -- issue #84 - https://github.com/cleancoda/notiflyer/issues/84
        -- prep create table statement for chart data
		
        -- original code below prior to #84
        -- select
		-- 	@sqlcmd = 'create table ##tmpnotiflyer_tbChartData ( datacolumn_x ' + @chart_column_axes_x_datatype + ' , datacolumn_y ' + case when isnull(@chart_column_axes_y_datatype,'') <> '' then  + @chart_column_axes_y_datatype else 'varchar(10)' end  + ' );';

        -- new attempt #84
        select
            @sqlcmd = 'create table ##tmpnotiflyer_tbChartData ( datacolumn_x nvarchar(max), datacolumn_y nvarchar(max));';

        -- execute create statement
        exec(@sqlcmd);

        -- TODO:
        -- when multiple data series support is added, convert the following alter table statement
        -- into a loop for  generating dynamic alter table statement depending on number 
        -- of data series columns being utilized

        -- TODO:
        -- issue #84 - https://github.com/cleancoda/notiflyer/issues/84
        -- prep create table statement for chart data
        if(@chart_column_axes_x_datatype like '%date%' or @chart_column_axes_y_datatype like '%date%')
            begin

                -- handle date formats
                -- when 
                begin try
                    select

                        -- TODO: review date challenges
                        -- issue #84 - https://github.com/cleancoda/notiflyer/issues/84
                        -- doc'd out to test conversion for dates into mm/dd/yyyy format
                        -- need to review if TIMESTAMP is needed in certain cases
                        -- @sqlcmd = 'select ' 
                        --             + '"'
                        --             + try_cast(@chart_column_axes_x as nvarchar(max))
                        --             + '"'
                        --             + ' as datacolumn_x, ' 
                        --             + '"'
                        --             + try_cast(@chart_column_axes_y as nvarchar(max)) 
                        --             + '"'
                        --             + ' as datacolumn_y '
                        --             + 'from ##tmpNotiflyer_tbQueryExecuteResults ' 
                        --             + @query_order_by;

                        @sqlcmd = 'insert into ##tmpnotiflyer_tbChartData ( datacolumn_x, datacolumn_y) select ' 
                                    + 'try_convert(varchar(10), ' + @chart_column_axes_x + ', 101)'
                                    + ' as datacolumn_x, ' 
                                    + 'try_convert(varchar(10), ' + @chart_column_axes_y + ', 101)'
                                    + ' as datacolumn_y '
                                    + 'from ##tmpNotiflyer_tbQueryExecuteResults ' 
                                    + @query_order_by;
                end try
                begin catch
                    select
                        @returnvalue = 1
                        ,@returnmessage = 'error occured: ['
                                        +  ' error_line: ' + try_cast(error_line() as nvarchar(max))
                                        +  ' error_number: ' + try_cast(error_number() as nvarchar(max))
                                        +  ' error_message: ' + try_cast(error_message() as nvarchar(max))
                                        +  ' ]'
                end catch
            end

        -- insert data for X/Y values into new temp table
        -- insert into ##tmpnotiflyer_tbChartData
        begin try
            print @sqlcmd;
            exec(@sqlcmd);  
        end try

        begin catch
            select
                @returnvalue = 1
                ,@returnmessage = 'error occured: ['
                                +  ' error_line: ' + try_cast(error_line() as nvarchar(max))
                                +  ' error_number: ' + try_cast(error_number() as nvarchar(max))
                                +  ' error_message: ' + try_cast(error_message() as nvarchar(max))
                                +  ' ]'
        end catch

        /*
            -- TODO:
            -- issue #64 - https://github.com/cleancoda/notiflyer/issues/64
            -- replace with cursor to loop through multiple series of data;

            -- temporary mvp logic:
            -- ensure table columns are in varchar
            -- prep insert select statement for copying data plot points from ##tmpNotiflyer_tbQueryExecuteResults into ##tmpnotiflyer_tbChartData -- order by query
            select @sqlcmd = 'select ' + @chart_column_axes_x + ' ,' + case when isnull(@chart_column_axes_y,'') <> '' then + @chart_column_axes_y else '''''' end +  ' from ##tmpNotiflyer_tbQueryExecuteResults ' + @query_order_by;

            -- insert data for X/Y values into new temp table
            insert into ##tmpnotiflyer_tbChartData
            exec(@sqlcmd);  

            alter table tempdb..##tmpnotiflyer_tbChartData
                alter column datacolumn_x nvarchar(max);

            -- ensure table columns are in varchar
            alter table tempdb..##tmpnotiflyer_tbChartData
                alter column datacolumn_y nvarchar(max);

            -- append ' on string values for axes labels
            -- x axes
            select
                @sqlvar = case when @chart_column_axes_x_datatype like '%char%' then '"' when @chart_column_axes_x_datatype like '%date%' then '"' else '' end;

            update ##tmpnotiflyer_tbChartData
            set
                datacolumn_x = @sqlvar + datacolumn_x + @sqlvar;

            -- append ' on string values for axes labels
            -- y axes
            select
                @sqlvar = case when @chart_column_axes_y_datatype like '%char%' then '"' when @chart_column_axes_y_datatype like '%date%' then '"' else '' end;

            update ##tmpnotiflyer_tbChartData
            set
                datacolumn_y = @sqlvar + datacolumn_y + @sqlvar;
        */

        -- mark parse results as success
        select 
            @returnvalue = 0
            ,@returnmessage = 'query staging successfully completed.';
        return;
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
go