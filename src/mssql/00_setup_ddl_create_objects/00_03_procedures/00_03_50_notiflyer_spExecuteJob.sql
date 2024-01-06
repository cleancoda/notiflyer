if object_id('notiflyer_spExecuteJob') is not null
    print 'notiflyer_spExecuteJob stored procedure exists, skipping create attempt..'
    print 'ignore error below, cannot create exception handling on ddl statements'
    return;
go

-- drop procedure notiflyer_spExecuteJob
create procedure notiflyer_spExecuteJob
/*
    @author     cleancoda
    @date       01052024
    @detail     
    @sample
                declare
                    @returnvalue as int = 0
                    ,@returnmessage as nvarchar(max) = '';
                
                exec notiflyer_spExecuteJob
                    @job_id = 1
                    ,@returnvalue = 0
                    ,@returnmessage = ''

    @log
                cc  01052024 - generated basic script file
*/
(
    @job_id as int = 0
    ,@returnvalue as int = 0
    ,@returnmessage as nvarchar(255) = ''
)
as
begin

    /*
        =================================
        pseudocode
        =================================

        -- collect and prepare objects
        1. get and store job config from notiflyer_tbJobManager for matching job_id
        2. get and store query_id and pos_id from notiflyer_tbJobQueryGrid for matching job_id into a new temp table #tempJobQueryGrid
        3. get and store query config from notiflyer_tbQuery for every matching id from notiflyer_tbJobQueryGrid imported in step 2
        4. get and store parameters from notiflyer_tbJobQueryGridParameters for every matching query in notiflyer_tbQuery imported in step 3

        -- execute queries
        5. execute query from notiflyer_tbQuery imported in step 3

    */

    begin try
    -- 1. get and store job config from notiflyer_tbJobManager for matching job_id
        
        -- setup variables
        declare
            @name as nvarchar(max) = ''
            ,@email_subject as nvarchar(max) = ''
            ,@email_recepient as nvarchar(max) = ''
            ,@email_cc as nvarchar(max) = ''
            ,@email_bcc as nvarchar(max) = ''
            ,@email_body_header as nvarchar(max) = '';

        -- get job config
        select
            @name = name
            ,@email_subject = email_subject
            ,@email_recepient = email_recepient
            ,@email_cc = email_cc
            ,@email_bcc = email_bcc
            ,@email_body_header = email_body_header
        from
            notiflyer_tbJobManager
        where
            id = @job_id;

    -- 2. get and store query_id and pos_id from notiflyer_tbJobQueryGrid for matching job_id into a new temp table #tempJobQueryGrid

        -- drop temp table if exists
        if object_id('tempdb..#tempJobQueryGrid') is not null
            drop table #tempJobQueryGrid;

        -- create temp table
        create table #tempJobQueryGrid
        (
            id int  -- job grid position id
            ,name varchar(255)
            ,job_id int
            ,query_id int
            ,pos_id int
        );

        -- populate temp table
        insert into #tempJobQueryGrid
        (
            id
            ,name
            ,job_id
            ,query_id
            ,pos_id
        )
        select
            id as job_query_grid_id
            ,name
            ,job_id
            ,query_id
            ,pos_id
        from
            notiflyer_tbJobQueryGrid
        where
            job_id = @job_id;

    -- 3. get and store query config from notiflyer_tbQuery for every matching id from notiflyer_tbJobQueryGrid imported in step 2

        -- drop temp table if exists
        if object_id('tempdb..#tempQuery') is not null
            drop table #tempQuery;

        -- create temp table for query definition
        create table #tempQuery
        (
            job_query_grid_id int
            ,job_id int
            ,pos_id int
            ,query_id int
            ,query_select nvarchar(max)
            ,query_from nvarchar(max)
            ,query_where nvarchar(max)
            ,query_group_by nvarchar(max)
            ,query_order_by nvarchar(max)
            ,query_output nvarchar(max)     -- TODO: can be used later for holding chart image url?
            ,query_executed int             -- TODO: can be used later for query execution results
        );

        -- populate temp table with job grid config and matching query definition
        insert into #tempQuery
        (
            job_query_grid_id
            ,job_id
            ,pos_id
            ,query_id
            ,query_select
            ,query_from
            ,query_where
            ,query_group_by
            ,query_order_by
        )
        select
            g.id
            ,g.job_id
            ,g.pos_id
            ,g.query_id
            ,q.query_select
            ,q.query_from
            ,q.query_where
            ,q.query_group_by
            ,q.query_order_by
        from
            #tempJobQueryGrid g
            left outer join notiflyer_tbQuery q on 
                g.query_id = q.id
        where
            g.job_id = @job_id;

    -- 4. get and store parameters from notiflyer_tbJobQueryGridParameters for every matching query in notiflyer_tbQuery imported in step 3

        -- drop temp table if exists
        if object_id('tempdb..#tempQueryParameters') is not null
            drop table #tempQueryParameters;

        -- create temp table for query parameters by grid position
        create table #tempQueryParameters
        (
            job_id int
            ,pos_id int
            ,query_id int
            ,parameter_name nvarchar(max)
            ,parameter_value nvarchar(max)
        );

        -- populate temp table with job grid config and matching query parameter definition
        insert into #tempQueryParameters
        select
            q.job_id
            ,q.pos_id
            ,q.query_id
            ,gp.parameter_name
            ,gp.parameter_value
        from
            #tempQuery q
            left outer join notiflyer_tbJobQueryGridParameters gp on
                q.job_query_grid_id = gp.job_query_grid_id;


        -- TESTING BELOW
        select
            @name
            ,@email_subject
            ,@email_recepient
            ,@email_cc
            ,@email_bcc
            ,@email_body_header;

        select * from #tempJobQueryGrid;
        select * from #tempQuery;
        select * from #tempQueryParameters;

        

    end try
    begin catch
    end catch

    
end