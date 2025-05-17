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

                select @returnvalue, @returnmessage;

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
        2. get and store query_id and row and column position from notiflyer_tbJobQueryGrid for matching job_id into a new temp table #tempJobQueryGrid
        3. get and store query config from notiflyer_tbQuery for every matching id from notiflyer_tbJobQueryGrid imported in step 2
        4. get and store parameters from notiflyer_tbJobQueryGridParameters in new temp table #tempQueryParameters for every matching query in notiflyer_tbQuery imported in step 3
        5. update parameters from #tempQueryParameters and replace matching parameters in #tempQuery
        6. loop through #tempQuery and execute query
        7. store results in a new temp table #tempQueryResults

        -- execute queries
        . execute query from notiflyer_tbQuery imported in step 3

    */

    begin try
    -- 1. get and store job config from notiflyer_tbJobManager for matching job_id
        
        -- setup variables
        declare
            @name as nvarchar(max) = ''
            ,@email_profile_name as nvarchar(max) = ''
            ,@email_subject as nvarchar(max) = ''
            ,@email_recepient as nvarchar(max) = ''
            ,@email_cc as nvarchar(max) = ''
            ,@email_bcc as nvarchar(max) = ''
            ,@email_body_header as nvarchar(max) = ''
            ,@email_process_result as int = 0
            ,@email_output as nvarchar(max) = '';

        -- TODO:
        -- automate app config retreival for email profile name
        select
            @email_profile_name = 'test';

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

    -- 2. get and store query_id and row and column from notiflyer_tbJobQueryGrid for matching job_id into a new temp table #tempJobQueryGrid

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
            ,grid_row int
            ,grid_column int
            ,label_header nvarchar(max)
        );

        -- populate temp table
        insert into #tempJobQueryGrid
        (
            id
            ,name
            ,job_id
            ,query_id
            ,grid_row
            ,grid_column
            ,label_header
        )
        select
            id as job_query_grid_id
            ,name
            ,job_id
            ,query_id
            ,grid_row
            ,grid_column
            ,label_header
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
            id int identity(1,1)            -- used for looping through queries
            ,job_query_grid_id int
            ,job_id int
            ,grid_row int
            ,grid_column int
            ,label_header nvarchar(max)
            ,query_id int
            ,query_select nvarchar(max) default ''
            ,query_from nvarchar(max) default ''
            ,query_where nvarchar(max) default ''
            ,query_group_by nvarchar(max) default ''
            ,query_order_by nvarchar(max) default ''
            ,query_output nvarchar(max)     -- TODO: can be used later for holding chart image url?
            ,query_executed int             -- TODO: can be used later for query execution results
            ,chart_column_legend nvarchar(max) -- TODO: can be used later for chart legend
            ,chart_column_axes_x nvarchar(max) -- TODO: can be used later for chart axes x
            ,chart_column_axes_y nvarchar(max) -- TODO: can be used later for chart axes y
            ,chart_graph_type nvarchar(max) -- TODO: can be used later for chart graphtype
        );

        -- populate temp table with job grid config and matching query definition
        insert into #tempQuery
        (
            job_query_grid_id
            ,job_id
            ,grid_row
            ,grid_column
            ,label_header
            ,query_id
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
            g.id
            ,g.job_id
            ,g.grid_row
            ,g.grid_column
            ,g.label_header
            ,g.query_id
            ,q.query_select
            ,q.query_from
            ,q.query_where
            ,q.query_group_by
            ,q.query_order_by
            ,q.chart_column_legend
            ,q.chart_column_axes_x
            ,q.chart_column_axes_y
            ,q.chart_graph_type
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
            ,grid_row int
            ,grid_column int
            ,query_id int
            ,parameter_name nvarchar(max)
            ,parameter_value nvarchar(max)
        );

        -- populate temp table with job grid config and matching query parameter definition
        insert into #tempQueryParameters
        select
            q.job_id
            ,q.grid_row
            ,q.grid_column
            ,q.query_id
            ,gp.parameter_name
            ,gp.parameter_value
        from
            #tempQuery q
            left outer join notiflyer_tbJobQueryGridParameters gp on
                q.job_query_grid_id = gp.job_query_grid_id;

    -- 5. update parameters from #tempQueryParameters and replace matching parameters in #tempQuery

        -- update parameters in #tempQuery
        update #tempQuery
        set
           query_where = replace(query_where, parameter_name, parameter_value)
        from    
            #tempQuery q
            left outer join #tempQueryParameters p on
                q.job_id = p.job_id
                and q.grid_row = p.grid_row
                and q.grid_column = p.grid_column
                and q.query_id = p.query_id;

    -- 6. loop through #tempQuery and execute query

        -- variables for parsing query
        declare
            @query_parsed as int = 0
            ,@query_executed as int = 0
            ,@query_output as nvarchar(max) = '';

        -- setup loop variables
        declare
            @query_counter as int = 0
            ,@query_count as int = 0
            ,@job_query_grid_id as int = 0
            ,@grid_row as int = 0
            ,@grid_column as int = 0
            ,@label_header as nvarchar(max) = ''
            ,@query_id as int = 0
            ,@query_select as nvarchar(max) = ''
            ,@query_from as nvarchar(max) = ''
            ,@query_where as nvarchar(max) = ''
            ,@query_group_by as nvarchar(max) = ''
            ,@query_order_by as nvarchar(max) = ''
            ,@chart_column_legend nvarchar(max) -- TODO: can be used later for chart legend
            ,@column_axes_x_datatype as nvarchar(max) -- TODO: can be used later for chart axes x
            ,@column_axes_y_datatype as nvarchar(max) -- TODO: can be used later for chart axes y
            ,@chart_column_axes_x_datatype as nvarchar(max) -- TODO: can be used later for chart axes x
            ,@chart_column_axes_y_datatype as nvarchar(max) -- TODO: can be used later for chart axes y
            ,@chart_column_axes_x nvarchar(max) -- TODO: can be used later for chart axes x
            ,@chart_column_axes_y nvarchar(max) -- TODO: can be used later for chart axes y
            ,@chart_graph_type nvarchar(max);

        
        -- read results
        -- TODO: capture data types and column names for later use
        -- TODO: this table will be called by notiflyer_spChartDataPrepJSONObjects
        -- prepare variables for notiflyer_spChartDataPrepJSONObjects
        declare
            -- chart column data types
            @column_axes_x_axes_data_type as nvarchar(max)
            ,@column_axes_y_axes_data_type as nvarchar(max)
            -- variables returned from notiflyer_spChartDataPrepJSONObjects as converted json objects
            ,@column_axes_x_axes_json_label as nvarchar(max)
            ,@column_axes_y_axes_json_label as nvarchar(max)
            -- TODO: this will be used later for chart legend
            ,@column_axes_x_axes_label as nvarchar(max)
            ,@column_axes_y_axes_label as nvarchar(max);

        -- prepare email string
        declare
            @json_string as nvarchar(max) = ''
            ,@chart_api_url as nvarchar(max) = ''
            ,@html_full as nvarchar(max) = '';

        -- TODO:
        -- get app config for chart api from notiflyer_tbAppConfig
        select
            @chart_api_url = 'https://quickchart.io/chart?c=';
        

        -- get total number of queries to execute
        select
            @query_count = max(id)
        from
            #tempQuery;

        -- create temp table to hold query results in json format
        if object_id('tempdb..##tmpnotiflyer_tbQueryResults') is not null
            drop table ##tmpnotiflyer_tbQueryResults;

        create table ##tmpnotiflyer_tbQueryResults
        (
            id int
            ,job_id int
            ,query_id int
            ,job_query_grid_id int
            ,grid_row int
            ,grid_column int
            ,label_header nvarchar(max)
            ,column_axes_x_axes_label nvarchar(max) 
            ,column_axes_x_axes_json_label nvarchar(max)
            ,column_axes_y_axes_label nvarchar(max)
            ,column_axes_y_axes_json_label nvarchar(max)
            ,chart_url nvarchar(max)
        );

        -- while loop through #tempQuery
        while @query_counter < @query_count
            begin
                -- increment counter (counter starts at 0, element count at >= 1)
                select
                    @query_counter = @query_counter + 1;

                -- get query config
                select
                    @job_query_grid_id = q.job_query_grid_id
                    ,@grid_row = q.grid_row
                    ,@grid_column = q.grid_column
                    ,@label_header = q.label_header
                    ,@query_id = q.query_id
                    ,@query_select = q.query_select
                    ,@query_from = q.query_from
                    ,@query_where = q.query_where
                    ,@query_group_by = q.query_group_by
                    ,@query_order_by = q.query_order_by
                    ,@chart_column_legend = q.chart_column_legend
                    ,@chart_column_axes_x = q.chart_column_axes_x
                    ,@chart_column_axes_y = q.chart_column_axes_y
                    ,@chart_graph_type = q.chart_graph_type
                from
                    #tempQuery q
                where   
                    id = @query_counter;

                -- TODO:
                -- fix errors on certain queries not parsing even with correct syntax
                -- -- trap errors from execution
                -- begin try

                --     -- parse and validate query
                --     exec notiflyer_spParseQuery
                --         @query_select = @query_select
                --         ,@query_from = @query_from
                --         ,@query_where = @query_where
                --         ,@query_group_by = @query_group_by
                --         ,@query_order_by = @query_order_by
                --         ,@query_parsed = @query_parsed output
                --         ,@query_output = @query_output output;

                -- end try
                -- begin catch
                --     select
                --         -- mark parse results as error
                --         @query_parsed = 1
                --         ,@query_output = 'error occured: ['
                --                         +  ' error_line: ' + try_cast(error_line() as nvarchar(max))
                --                         +  ' error_number: ' + try_cast(error_number() as nvarchar(max))
                --                         +  ' error_message: ' + try_cast(error_message() as nvarchar(max))
                --                         +  ' ]'
                --     -- TODO: log error and send email notification
                --     print @query_output;

                --     -- move on to next query in line
                --     continue;
                -- end catch

                -- trap errors from execution
                begin try
                    -- if query parsed successfully, execute query and prepare chart data
                    --if @query_parsed = 0
                        begin

                            -- prepare chart data
                            exec notiflyer_spChartDataPrepare
                                @query_select = @query_select
                                ,@query_from = @query_from
                                ,@query_where = @query_where
                                ,@query_group_by = @query_group_by
                                ,@query_order_by = @query_order_by
                                ,@chart_column_axes_x = @chart_column_axes_x
                                ,@chart_column_axes_y = @chart_column_axes_y
                                ,@chart_column_axes_x_datatype = @column_axes_x_datatype output
                                ,@chart_column_axes_y_datatype = @column_axes_y_datatype output
                                ,@chart_column_axes_x_axes_label = @column_axes_x_axes_label output
                                ,@chart_column_axes_y_axes_label = @column_axes_y_axes_label output
                                ,@returnvalue = @returnvalue output
                                ,@returnmessage = @returnmessage output;

                            -- check for errors
                            if(@returnvalue <> 0)
                            begin

                                -- add error location
                                set
                                    @returnmessage = 'notiflyer_spChartDataPrepare - ' + @returnmessage;

                                -- append the error message to the output
                                select
                                    @returnmessage += ' job_id: ' + try_cast(@job_id as nvarchar(max))
                                                        + ' query_id: ' + try_cast(@query_id as nvarchar(max));

                                -- add to log
                                exec notiflyer_spCreateLog
                                    @log_description = @returnmessage
                                    ,@log_type = 'e'
                                    ,@log_source = 'notiflyer_spExecuteJob'
                                    ,@log_user = 'system'
                                    ,@returnvalue = 0
                                    ,@returnmessage = '';

                                -- exit procedure
                                return;
                            end

                            -- convert chart data into json objects
                            exec notiflyer_spChartDataPrepJSONObjects
                                @column_axes_x_axes_label = @column_axes_x_axes_label
                                ,@column_axes_y_axes_label = @column_axes_y_axes_label
                                ,@column_axes_x_axes_json_label = @column_axes_x_axes_json_label output
                                ,@column_axes_y_axes_json_label = @column_axes_y_axes_json_label output
                                ,@returnvalue = @returnvalue
                                ,@returnmessage = @returnmessage;

                            -- check for errors
                            if(@returnvalue <> 0)
                            begin

                                -- add error location
                                set
                                    @returnmessage = 'notiflyer_spChartDataPrepJSONObjects - ' + @returnmessage;

                                -- append the error message to the output
                                set
                                    @returnmessage += ' job_id: ' + try_cast(@job_id as nvarchar(max))
                                                        + ' query_id: ' + try_cast(@query_id as nvarchar(max));

                                -- add to log
                                exec notiflyer_spCreateLog
                                    @log_description = @returnmessage
                                    ,@log_type = 'e'
                                    ,@log_source = 'notiflyer_spExecuteJob'
                                    ,@log_user = 'system'
                                    ,@returnvalue = 0
                                    ,@returnmessage = '';

                                -- exit procedure
                                return;
                            end

                            print 'chart_column_axes_x_axes_label: ' + @column_axes_x_axes_label;
                            print 'chart_column_axes_y_axes_label: ' + @column_axes_y_axes_label;

                            -- convert into json string
                            exec notiflyer_spChartAPIPrepJSONString
                                @chart_type = @chart_graph_type
                                ,@column_axes_x_axes_json_label = @column_axes_x_axes_json_label
                                ,@column_axes_y_axes_json_label = @column_axes_y_axes_json_label
                                ,@chart_column_legend = @chart_column_legend
                                ,@json_string = @json_string output
                                ,@returnvalue = 0
                                ,@returnmessage = '';

                            print 'json_string: ' + @json_string;

                            -- check for errors
                            if(@returnvalue <> 0)
                            begin

                                -- add error location
                                set
                                    @returnmessage = 'notiflyer_spChartAPIPrepJSONString - ' + @returnmessage;

                                -- append the error message to the output
                                set
                                    @returnmessage += ' job_id: ' + try_cast(@job_id as nvarchar(max))
                                                        + ' query_id: ' + try_cast(@query_id as nvarchar(max));

                                -- add to log
                                exec notiflyer_spCreateLog
                                    @log_description = @returnmessage
                                    ,@log_type = 'e'
                                    ,@log_source = 'notiflyer_spExecuteJob'
                                    ,@log_user = 'system'
                                    ,@returnvalue = 0
                                    ,@returnmessage = '';

                                -- exit procedure
                                return;
                            end

                            insert into ##tmpnotiflyer_tbQueryResults
                            (
                                id
                                ,job_id
                                ,query_id
                                ,job_query_grid_id
                                ,grid_row
                                ,grid_column
                                ,label_header
                                ,column_axes_x_axes_label
                                ,column_axes_x_axes_json_label
                                ,column_axes_y_axes_label
                                ,column_axes_y_axes_json_label
                                ,chart_url
                            )
                            select
                                @query_counter
                                ,@job_id
                                ,@query_id
                                ,@job_query_grid_id
                                ,@grid_row
                                ,@grid_column
                                ,@label_header
                                ,@column_axes_x_axes_label
                                ,@column_axes_x_axes_json_label
                                ,@column_axes_y_axes_label
                                ,@column_axes_y_axes_json_label
                                ,@chart_api_url + @json_string;
                        end
                end try
                begin catch
                    select
                        -- mark execution results as error
                        @query_executed = 1
                        ,@query_output = 'error occured: ['
                                        +  ' error_line: ' + try_cast(error_line() as nvarchar(max))
                                        +  ' error_number: ' + try_cast(error_number() as nvarchar(max))
                                        +  ' error_message: ' + try_cast(error_message() as nvarchar(max))
                                        +  ' ]'

                end catch
            end          
            
            -- builds email body in html using contents of ##tmpnotiflyer_tbQueryResults;
            exec notiflyer_spEmailBuildBody
                @html_full = @html_full output
                ,@returnvalue = 0
                ,@returnmessage = '';

            -- send email
            exec notiflyer_spDBMailSendEmail
                @profile_name = @email_profile_name
                ,@recipients = @email_recepient
                ,@body = @html_full
                ,@subject = @email_subject
                ,@returnvalue = @returnvalue output
                ,@returnmessage = @returnmessage output;

            -- check for errors
            if(@returnvalue <> 0)
            begin

                -- add error location
                set
                    @returnmessage = 'notiflyer_spDBMailSendEmail - ' + @returnmessage;

                -- append the error message to the output
                set
                    @returnmessage += ' job_id: ' + try_cast(@job_id as nvarchar(max))
                                        + ' query_id: ' + try_cast(@query_id as nvarchar(max));

                -- add to log
                exec notiflyer_spCreateLog
                    @log_description = @returnmessage
                    ,@log_type = 'e'
                    ,@log_source = 'notiflyer_spExecuteJob'
                    ,@log_user = 'system'
                    ,@returnvalue = 0
                    ,@returnmessage = '';

                -- exit procedure
                return;
            end

            -- mark success
            select
                @returnvalue = 0
                ,@returnmessage = 'job executed successfully';
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
go