

-- truncate table before adding new entries
/*
    delete from notiflyer_tbJobQueryGridParameters;
    delete from notiflyer_tbJobQueryGrid;
    delete from notiflyer_tbQuery;
    delete from notiflyer_tbJobManager;
*/


declare
    @jobid as int
    ,@queryid as int
    ,@job_query_grid_id as int;

-- row = 1, column = 1

    insert into notiflyer_tbJobManager
    (
        name
        ,email_subject
        ,email_recepient
        ,email_body_header
        ,frequency
        ,run_time
    )
    select
        'Test Job ' + cast(row_number() over (order by (select null)) as varchar(10))
        ,'Test Subject ' + cast(row_number() over (order by (select null)) as varchar(10))
        ,'testemail@email.com'
        ,'test body header'
        ,'h'
        ,'00:15'

    select
        @jobid = max(id)
    from
        notiflyer_tbJobManager


    insert into notiflyer_tbQuery
    (
        name
        ,type
        ,query_select
        ,query_from
        ,query_where
        ,query_group_by
        ,query_order_by
        ,chart_column_legend
        ,chart_column_axes_x
        ,chart_column_axes_y
        ,chart_graph_type
    )
    select
        'Test Query ' + cast(row_number() over (order by (select null)) as varchar(10))
        ,'q'
        ,'select top 10 CustomerID,dateadd(month, datediff(month, 0, OrderDate), 0) as OrderMonth,count(1) as TotalAmount'
        ,'from WideWorldImporters.Sales.Orders'
        ,'where PickedByPersonID = @PickedByPersonID'
        ,'group by CustomerID ,dateadd(month, datediff(month, 0, OrderDate), 0)'
        ,'order by TotalAmount desc'
        ,'CustomerID'
        ,'OrderMonth'
        ,'CustomerID'
        ,'bar'

    select
        @queryid = max(id)
    from
        notiflyer_tbQuery;


    insert into notiflyer_tbJobQueryGrid
    (
        name
        ,job_id
        ,query_id
        ,grid_row
        ,grid_column
    )
    select
        'grid location'
        ,@jobid
        ,@queryid
        ,1
        ,1

    select 
        @job_query_grid_id = max(id) 
    from 
        notiflyer_tbJobQueryGrid;


    insert into notiflyer_tbJobQueryGridParameters
    (
        job_query_grid_id
        ,parameter_name
        ,parameter_value
    )
    select
        @job_query_grid_id
        ,'@PickedByPersonID'
        ,'17'

-- row = 1, column = 2
    -- use same job # as above

    insert into notiflyer_tbQuery
    (
        name
        ,type
        ,query_select
        ,query_from
        ,query_where
        ,query_group_by
        ,query_order_by
        ,chart_column_legend
        ,chart_column_axes_x
        ,chart_column_axes_y
        ,chart_graph_type
    )
    select
        'Test Query ' + cast(row_number() over (order by (select null)) as varchar(10))
        ,'q'
        ,'select c.CustomerName,  sum(l.ExtendedPrice) as TotalInvoiceValue'
        ,'from Sales.Invoices i left outer join Sales.InvoiceLines l on i.InvoiceID = l.InvoiceID left outer join Sales.Customers c on i.CustomerID = c.CustomerID'
        ,'where i.SalespersonPersonID = @SalespersonPersonID'
        ,'group by c.CustomerName'
        ,'order by TotalInvoiceValue desc'
        ,'CustomerName'
        ,'TotalInvoiceValue'
        ,'CustomerName'
        ,'bar'

    select
        @queryid = max(id)
    from
        notiflyer_tbQuery;


    insert into notiflyer_tbJobQueryGrid
    (
        name
        ,job_id
        ,query_id
        ,grid_row
        ,grid_column
    )
    select
        'grid location'
        ,@jobid
        ,@queryid
        ,1
        ,2

    select 
        @job_query_grid_id = max(id) 
    from 
        notiflyer_tbJobQueryGrid;


    insert into notiflyer_tbJobQueryGridParameters
    (
        job_query_grid_id
        ,parameter_name
        ,parameter_value
    )
    select
        @job_query_grid_id
        ,'@SalespersonPersonID'
        ,'14'

select * from notiflyer_tbJobManager where id = 1;
select * from notiflyer_tbQuery where id = @queryid;
select * from notiflyer_tbJobQueryGrid where id = @job_query_grid_id;
select * from notiflyer_tbJobQueryGridParameters where job_query_grid_id = @job_query_grid_id;