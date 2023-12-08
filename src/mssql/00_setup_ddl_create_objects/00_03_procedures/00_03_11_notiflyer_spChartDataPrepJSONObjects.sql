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
                    ,@column_axes_x_axes_label = ''
                    ,@column_axes_x_data_label = ''
                    ,@column_axes_y_axes_data_type = 'int'
                    ,@column_axes_y_axes_label = ''
                    ,@column_axes_y_data_label = ''
                    ,@returnvalue = 0
                    ,@returnmessage = ''

                select  
                    @returnvalue
                    ,@returnmessage;

    @log
                cc  12062023 - generated basic script file
*/
(
    -- describe x-axes
    @column_axes_x_axes_data_type as nvarchar(max) = '' output
    ,@column_axes_x_axes_label as nvarchar(max) = '' output
    ,@column_axes_x_data_label as nvarchar(max) = '' output
    -- describe y-axes
    ,@column_axes_y_axes_data_type as nvarchar(max) = '' output
    ,@column_axes_y_axes_label as nvarchar(max) = '' output
    ,@column_axes_y_data_label as nvarchar(max) = '' output
    ,@returnvalue as int = 0 output
    ,@returnmessage as nvarchar(255) = '' output
)
as
begin
    begin try

        -- variables
        declare
            @x_axes_data_series as nvarchar(max) = ''
            ,@y_axes_data_series as nvarchar(max) = '';

        -- combine all records into single string using coalesce
        select
            @x_axes_data_series = coalesce (@x_axes_data_series , '')  + datacolumn_x + ','
            ,@y_axes_data_series = coalesce (@y_axes_data_series, '') +  datacolumn_y + ','
        from
            ##tmpnotiflyer_tbChartData;

        -- trim extra comma , at the end of string
        select  
            @x_axes_data_series = case when left(reverse(@x_axes_data_series),1) = ',' then left(@x_axes_data_series,len(@x_axes_data_series)-1) else @x_axes_data_series end
            ,@y_axes_data_series = case when left(reverse(@y_axes_data_series),1) = ',' then left(@y_axes_data_series,len(@y_axes_data_series)-1) else @y_axes_data_series end;

        select @x_axes_data_series, @y_axes_data_series;

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