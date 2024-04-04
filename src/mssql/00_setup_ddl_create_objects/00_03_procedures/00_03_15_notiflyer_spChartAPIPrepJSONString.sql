if object_id('notiflyer_spChartAPIPrepJSONString') is not null
    print 'notiflyer_spChartAPIPrepJSONString stored procedure exists, skipping create attempt..'
    print 'ignore error below, cannot create exception handling on ddl statements'
    return;
go

-- drop procedure notiflyer_spChartAPIPrepJSONString
create procedure notiflyer_spChartAPIPrepJSONString
/*
    @author     cleancoda
    @date       12112023
    @detail     
    @sample
                declare
                    @strop as nvarchar(max)
                    ,@returnvalue as int = 0
                    ,@returnmessage as nvarchar(255) = '';
                
                exec notiflyer_spChartAPIPrepJSONString
                    @chart_type = 'bar'
                    ,@column_axes_x_axes_json_label = '["2013-10-01","2014-02-01","2014-05-01","2014-06-01","2014-09-01","2015-04-01","2015-07-01","2015-10-01","2016-02-01","2016-04-01"]'
                    ,@column_axes_y_axes_json_label = '"NumOfOrders", data: [25122565,33840707,51614336,54621907,56244441,99612848,121123417,116340715,113902841,137679922]'
                    ,@json_string = @strop output
                    ,@returnvalue = 0
                    ,@returnmessage = ''

                select  
                    @strop;

    @log
                cc  12112023 - generated basic script file
*/
(
    @chart_type as nvarchar(max) = ''
    ,@column_axes_x_axes_json_label as nvarchar(max) = ''
    ,@column_axes_y_axes_json_label as nvarchar(max) = ''
    ,@json_string nvarchar(max) = '' output
    ,@returnvalue as int = 0 output
    ,@returnmessage as nvarchar(255) = '' output
)
as 
begin
    begin try
        
        -- TODO:
        -- multiple data series for a single axes
        -- build json string for required chart api endpoint parameters
        /*
            example:
                {
                    type: 'bar',
                    data: {
                        labels: ['January', 'February', 'March', 'April', 'May'],
                        datasets: [
                        { label: 'Dogs', data: [50, 60, 70, 180, 190] },
                        ],
                    },
                }
        */
        select
            @json_string = '{ type: "' 
                                + @chart_type 
                                + '",'
                                + 'data: { '
                                -- x axes labels
                                    + 'labels: ' 
                                    -- example: ['January', 'February', 'March', 'April', 'May']
                                    + @column_axes_x_axes_json_label
                                    + ','
                                    -- y axes label + data plot point
                                    + 'datasets: [ '
                                        + '{ label: '
                                        -- example: 'Dogs', data: [50, 60, 70, 180, 190],
                                        + @column_axes_y_axes_json_label
                                        + '}'
                                    + ','
                                    + ']'
                                + ','
                                + '}'
                            + ','
                            + '}'

            -- encode string for appending to a url
            -- select
            --     @json_string = dbo.notiflyer_fnUrlEncode(@json_string);

            return @json_string;

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