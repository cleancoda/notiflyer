if object_id('notiflyer_spChartDataPrepJSONObjects') is not null
    print 'notiflyer_spChartDataPrepJSONObjects stored procedure exists, skipping create attempt..'
    print 'ignore error below, cannot create exception handling on ddl statements'
    return;
go

-- drop procedure notiflyer_spChartDataPrepJSONObjects
create procedure notiflyer_spChartDataPrepJSONObjects
/*
    @author     cleancoda
    @date       12062023
    @detail     
    @sample
                declare
                    @returnvalue as int = 0
                    ,@returnmessage as nvarchar(255) = '';
                
                exec notiflyer_spChartDataPrepJSONObjects
                    @column_axes_x_axes_data_type = 'varchar(max)'
                    ,@column_axes_x_axes_json_label = 'OrderMth'
                    ,@column_axes_y_axes_data_type = 'numeric(12,2)'
                    ,@column_axes_y_axes_json_label = ''
                    ,@column_axes_y_data_label = 'NumOfOrders'
                    ,@returnvalue = 0
                    ,@returnmessage = ''

                select  
                    @returnvalue
                    ,@returnmessage;

    @log
                cc  12062023 - generated basic script file
*/
(
    -- describe cartesian axes - x/y axes and data-types
    @column_axes_x_axes_label as nvarchar(max) = ''
    ,@column_axes_y_axes_label as nvarchar(max) = ''
    -- return values only below
    ,@column_axes_x_axes_json_label as nvarchar(max) = '' output
    ,@column_axes_y_axes_json_label as nvarchar(max) = '' output
    -- execution return variables
    ,@returnvalue as int = 0 output
    ,@returnmessage as nvarchar(255) = '' output
)
as
begin
    begin try

        -- TODO:
        -- when multiple data series support is added, convert the following alter table statement
        -- into a loop for  generating dynamic alter table statement depending on number 
        -- of data series columns being utilized
        
        -- variables
        declare
            @x_axes_data_series as nvarchar(max) = ''
            ,@y_axes_data_series as nvarchar(max) = '';

        -- combine all records into single string using coalesce
        select
            @x_axes_data_series = coalesce (@x_axes_data_series , '') + datacolumn_x + ','
            ,@y_axes_data_series = coalesce (@y_axes_data_series, '') + datacolumn_y + ','
        from
            ##tmpnotiflyer_tbChartData;

        -- trim extra comma , at the end of string
        select  
            @x_axes_data_series = case when left(reverse(@x_axes_data_series),1) = ',' then left(@x_axes_data_series,len(@x_axes_data_series)-1) else @x_axes_data_series end
            ,@y_axes_data_series = case when left(reverse(@y_axes_data_series),1) = ',' then left(@y_axes_data_series,len(@y_axes_data_series)-1) else @y_axes_data_series end;

        -- prepare series in json
        -- x axes data label
        set
            @column_axes_x_axes_json_label = '[' + @x_axes_data_series + ']';
            
        -- TODO:
        -- when multiple data series support is added, convert the following set statement
        -- into a loop for number of columns in the series and build the datasets query
        -- of data series columns being utilized

        -- y axes data label
        set
            @column_axes_y_axes_json_label = '"' + @column_axes_y_axes_label + '", data: [' + @y_axes_data_series + ']';

        select
            @column_axes_x_axes_json_label
            ,@column_axes_y_axes_json_label;

        -- TODO:
        -- chart design/options/colors/fonts/configurations/plugins
        -- the 'label' section of the json string will contain
        -- config values required to customize the chart it produces
        -- these values will be stored on the notiflyer_tbJobManager or 
        -- a new additional table/grid will be created and linked to the job
        -- use that table and call another stored procedure at this point to 
        -- add those config values to the json string


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