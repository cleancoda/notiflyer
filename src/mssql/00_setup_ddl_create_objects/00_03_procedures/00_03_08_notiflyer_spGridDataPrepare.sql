if object_id('notiflyer_spGridDataPrepare') is not null
    print 'notiflyer_spGridDataPrepare stored procedure exists, skipping create attempt..'
    print 'ignore error below, cannot create exception handling on ddl statements'
    return;
go

-- drop procedure notiflyer_spGridDataPrepare
-- go

alter procedure notiflyer_spGridDataPrepare
/*
    @author     cleancoda
    @date       05202024
    @detail     generates a html table 
    @sample
                declare @query_output varchar(max);

                exec notiflyer_spGridDataPrepare
                @query_select = 'SELECT top 2 * FROM WideWorldImporters.Sales.Orders'
                , @display_query = 1
                , @html_table_style = 'width:100%;border:1px solid black;'
                , @html_header_style = 'border:1px solid black;'
                , @html_data_style = 'background-color:#f0f0f0;'
                , @query_executed = 0 
                , @query_output = @query_output output;
                print @query_output;


                -- Sample execute statements
                declare @query_output varchar(max);
                exec notiflyer_spGridDataPrepare
                @query_select = 'SELECT top 5 * FROM WideWorldImporters.Sales.Orders'
                , @display_query = 1
                , @html_table_style = 'width:80%;border:2px solid red;'
                , @html_header_style = 'border:1px solid black;'
                , @html_data_style = 'background-color:#ffffff;'
                , @query_executed = 0 
                , @query_output = @query_output output;
                print @query_output;

                declare @query_output varchar(max);
                exec notiflyer_spGridDataPrepare
                @query_select = 'SELECT * FROM WideWorldImporters.Sales.Customers'
                , @query_where = 'WHERE CustomerID = 1'
                , @display_query = 1
                , @html_table_style = 'width:70%;border:1px solid green;'
                , @html_header_style = 'border:1px solid black;'
                , @html_data_style = 'background-color:#f0f0f0;'
                , @query_executed = 0 
                , @query_output = @query_output output;
                print @query_output;

                declare @query_output varchar(max);
                exec notiflyer_spGridDataPrepare
                @query_select = 'SELECT TOP 10 * FROM WideWorldImporters.Purchasing.Suppliers'
                , @query_order_by = 'ORDER BY SupplierName DESC'
                , @display_query = 1
                , @html_table_style = 'width:90%;border:1px solid blue;'
                , @html_header_style = 'border:1px solid black;'
                , @html_data_style = 'background-color:#f0f0f0;'
                , @query_executed = 0 
                , @query_output = @query_output output;
                print @query_output;
*/
(
    @query_select as nvarchar(max) = ''
    ,@query_from as nvarchar(max) = ''
    ,@query_where as nvarchar(max) = ''
    ,@query_group_by as nvarchar(max) = ''
    ,@query_order_by as nvarchar(max) = ''
    ,@display_query as int = 0
    ,@html_table_style as nvarchar(max) = 'width:100%;border:1px solid black;'
    ,@html_header_style as nvarchar(max) = 'border:1px solid black;'
    ,@html_data_style as nvarchar(max) = 'background-color:#f0f0f0;'
    ,@query_executed as int output
    ,@query_output as nvarchar(max) output
)
as
begin
    set nocount on;
    declare @query as nvarchar(max) = '';
    declare @queryexecuted as int = 0;
    declare @queryoutput as nvarchar(max) = '';

    set @query = isnull(@query_select,'') + ' ' + isnull(@query_from,'') + ' ' + isnull(@query_where,'') + ' ' + isnull(@query_group_by,'') + ' ' + isnull(@query_order_by,'');

    if @display_query = 1
        print @query;
        
    -- code credit: https://gist.github.com/PatrickDinh/93a03e706b143f016235
    DECLARE @exec_str  NVARCHAR(MAX)
    DECLARE @ParmDefinition NVARCHAR(500)

    --We need to use Dynamic SQL at this point so we can expand the input SQL query parameter
    SET @exec_str= N'
    DECLARE @exec_str  NVARCHAR(MAX)
    DECLARE @ParmDefinition NVARCHAR(500)

    --Make a copy of the result of the SQL query adding an indexing column
    --We need to add an index column to the table to facilitate sorting so we can maintain the
    --original table order as we iterate through adding HTML tags to the table fields.
    --New column called CustColHTML_ID (unlikely to be used by someone else!)
    --

    select CustColHTML_ID=0,* INTO #CustomTable2HTML FROM (' + @query + ') AS QueryResult

    --Now alter the table to add the auto-incrementing index. This will facilitate row finding
    DECLARE @COUNTER INT
    SET @COUNTER=0
    UPDATE #CustomTable2HTML SET @COUNTER = CustColHTML_ID=@COUNTER+1 



    -- @HTMLROWS will store all the rows in HTML format
    -- @ROW will store each HTML row as fields on each row are iterated through 
    -- using dymamic SQL and a cursor
    -- @FIELDS will store the header row for the HTML Table

    DECLARE @HTMLROWS NVARCHAR(MAX) DECLARE @FIELDS NVARCHAR(MAX) 
    SET @HTMLROWS='''' DECLARE @ROW NVARCHAR(MAX) 

    -- Create the first HTML row for the table (the table header). Ignore our indexing column!
    SET @FIELDS=''<tr>''
    SELECT @FIELDS=COALESCE(@FIELDS, '' '','''')+''<th ' + @html_header_style + '>'' + name + ''</th>''
    FROM tempdb.sys.columns
    WHERE object_id=object_id(''tempdb..#CustomTable2HTML'')
    AND name not like ''CustColHTML_ID''
    SET @FIELDS=@FIELDS + ''</tr>''

    -- @ColumnName stores the column name as found by the table cursor
    -- @maxrows is a count of the rows in the table, and @rownum is for marking the
    -- ''current'' row whilst processing

    DECLARE @ColumnName  NVARCHAR(500)
    DECLARE @maxrows INT
    DECLARE @rowNum INT

    --Find row count of our temporary table
    SELECT @maxrows=count(*) FROM  #CustomTable2HTML


    --Create a cursor which will look through all the column names specified in the temporary table
    --but exclude the index column we added (CustColHTML_ID)
    DECLARE col CURSOR FOR
    SELECT name FROM tempdb.sys.columns
    WHERE object_id=object_id(''tempdb..#CustomTable2HTML'')
    AND name not like ''CustColHTML_ID''
    ORDER BY column_id ASC

    --For each row, generate dymanic SQL which requests the each column name in turn by 
    --iterating through a cursor
    SET @rowNum=0
    SET @ParmDefinition=N''@ROWOUT NVARCHAR(MAX) OUTPUT,@rowNum_IN INT''

    While @rowNum < @maxrows
    BEGIN
    SET @HTMLROWS=@HTMLROWS + ''<tr>''

    SET @rowNum=@rowNum +1
    OPEN col
    FETCH NEXT FROM col INTO @ColumnName
    WHILE @@FETCH_STATUS=0
        BEGIN
        --Get nth row from table
        SET @exec_str=''SELECT @ROWOUT=(select COALESCE(['' + @ColumnName + ''], '''''''') AS ['' + @ColumnName + ''] from #CustomTable2HTML where CustColHTML_ID=@rowNum_IN)''

        EXEC	sp_executesql 
                @exec_str,
                @ParmDefinition,
                @ROWOUT=@ROW OUTPUT,
                @rowNum_IN=@rowNum

        SET @HTMLROWS =@HTMLROWS +  ''<td ' + @html_data_style + '>'' + @ROW + ''</td>''
        FETCH NEXT FROM col INTO @ColumnName
        END
    CLOSE col
    SET @HTMLROWS=@HTMLROWS + ''</tr>''
    END

    SET @query_output=''''
    IF @maxrows>0
    SET @query_output= ''<table ' + @html_table_style + '>'' + @FIELDS + @HTMLROWS + ''</table>''

    DEALLOCATE col
    '

    DECLARE @ParamDefinition nvarchar(max)
    SET @ParamDefinition=N'@query_output NVARCHAR(MAX) OUTPUT'

    --Execute Dynamic SQL. HTML table is stored in query_output which is passed back up (as it's
    --a parameter to this SP)
    begin try
        EXEC sp_executesql @exec_str,
        @ParamDefinition,
        @query_output=@query_output OUTPUT;

    end try
    begin catch
        set @query_output = 'error: ' + error_message();
        print @query_output;
    end catch


    set nocount off;

end
go