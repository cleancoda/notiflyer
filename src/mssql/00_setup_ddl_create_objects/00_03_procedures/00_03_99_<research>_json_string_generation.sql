/*
    @author     cleancoda
    @date       11122023
    @detail     research code
                - focus on creating a string with the labels and datasets separately first
                    - create functions/stored procedures to return a simple string like this: ['January','February','March','April','May']
                        - function/stored procedure should accept parameter - query - which calls the exec functionality and generates data output
                - then work on generating the wrapper text for quick chart
                
                - if research validates, convert into stored procedure and change script name
    @log
                cc  11122023 - generated basic script file
*/

-- sample query
/*
    select
            p.CustomerID
            ,(sum(l.Quantity) as qty
        from
            Sales.OrderLines l
            left outer join Sales.Orders p
                on
                    l.OrderID = p.OrderID
        group by
            p.CustomerID
*/

-- target example string
/*
    https://quickchart.io/chart?c={type:'line',data:{labels:['January','February','March','April','May'],datasets:[{label:'Dogs',data:[50,60,70,180,190],fill:false,borderColor:'blue'},{label:'Cats',data:[100,200,300,400,500],fill:false,borderColor:'green'}]}}
*/


/*
    url parameters

    chart?c={type:'line',data:{labels:['January','February','March','April','May'],datasets:[{label:'Dogs',data:[50,60,70,180,190],fill:false,borderColor:'blue'},{label:'Cats',data:[100,200,300,400,500],fill:false,borderColor:'green'}]}}

    type
    datasets

*/


SELECT '[' + STUFF((
    SELECT
          ',{'
        + '"Id":'+CAST(Id AS varchar(10)) + ','
        + COALESCE('"Name":"' + Name + '",','')
        + COALESCE('"About":"' + About + '",','')
        + COALESCE('"Age":'+CAST(Age AS varchar(10)) + ',','')
        + COALESCE('"AddressId":'+CAST(AddressId AS varchar(10)), '')
        + '}'
    FROM TestTable
    FOR XML PATH(''), TYPE).value('.', 'varchar(MAX)'),1,1,'')
    + ']';

select 
    '[' + stuff((
        select

          ',{'
                + '''' + cast(p.CustomerID as nvarchar(max)) + ''''
                + '''' +  coalesce(sum(l.Quantity) as qty
        from
            Sales.OrderLines l
            left outer join Sales.Orders p
                on
                    l.OrderID = p.OrderID
        group by
            p.CustomerID
        for xml path(''), type).value('.', 'varchar(max)'),1,1,'')
    + ']';