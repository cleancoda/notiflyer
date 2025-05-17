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
                    ,@chart_column_legend = 'NumOfOrders'
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
    ,@chart_column_legend as nvarchar(max) = ''
    ,@json_string nvarchar(max) = '' output
    ,@returnvalue as int = 0 output
    ,@returnmessage as nvarchar(255) = '' output
)
as 
begin
    begin try
        -- Validate input parameters
        if @chart_type = '' or @column_axes_x_axes_json_label = '' or @column_axes_y_axes_json_label = ''
        begin
            set @returnvalue = 1;
            set @returnmessage = 'Invalid input: chart_type, column_axes_x_axes_json_label, and column_axes_y_axes_json_label are required.';
            return;
        end

        -- check for improperly escaped characters and fix them
        if @column_axes_x_axes_json_label like '%[^a-zA-Z0-9,:\[\]{}" ]%'
        begin
            set @column_axes_x_axes_json_label = replace(@column_axes_x_axes_json_label, '"', '\"');
            set @column_axes_x_axes_json_label = replace(@column_axes_x_axes_json_label, '\', '\\');
        end

        if @column_axes_y_axes_json_label like '%[^a-zA-Z0-9,:\[\]{}" ]%'
        begin
            set @column_axes_y_axes_json_label = replace(@column_axes_y_axes_json_label, '"', '\"');
            set @column_axes_y_axes_json_label = replace(@column_axes_y_axes_json_label, '\', '\\');
        end

        -- Build JSON string for the chart API
        select
            @json_string = '{'
                            + '"type": "' + @chart_type + '",'
                            + '"data": {'
                                + '"labels": ' + @column_axes_x_axes_json_label + ','
                                + '"datasets": ['
                                    + '{'
                                        + '"label": "' + @chart_column_legend + '",'
                                        + '"data": ' + @column_axes_y_axes_json_label
                                    + '}'
                                + ']'
                            + '},'
                            + '"options": {'
                                + '"plugins": {'
                                    +   case 
                                            when @chart_type = 'pie' then
                                                '"legend": "false",'
                                                    + '"outlabels": {'
                                                    + '"text": "%l %p",'
                                                    + '"color": "white",'
                                                    + '"stretch": 35,'
                                                    + '"font": {'
                                                        + '"resizable": true,'
                                                        + '"minSize": 12,'
                                                        + '"maxSize": 18'
                                                        + '}'
                                                    + '}'
                                        else
                                            + '"datalabels": {'
                                            + '"anchor": "end",'
                                            + '"align": "top",'
                                            + '"offset": 10,'
                                            + '"borderWidth": 1,'
                                            +   case 
                                                    when @chart_type = 'bar' then
                                                        '"backgroundColor": "rgba(34, 139, 34, 0.6)",' -- Fixed missing quotes
                                                        + '"borderColor": "rgba(34, 139, 34, 1.0)",' -- Fixed missing quotes
                                                        + '"borderRadius": 5,'
                                                end
                                            + '"color": "#000",'
                                            + '"font": {'
                                                + '"size": 8' -- Removed trailing comma
                                            + '}'
                                        + '}'
                                        end
                                + '}'
                            + '}'
                        + '}';

        print 'raw json: ' + @json_string;

        -- Encode the JSON string for appending to a URL
        select
            @json_string = dbo.notiflyer_fnUrlEncode(@json_string);

        -- Test the resulting JSON string
        if @json_string is null or len(@json_string) = 0
        begin
            set @returnvalue = 1;
            set @returnmessage = 'Error: JSON string generation failed.';
            return;
        end

        -- Mark success
        set @returnvalue = 0;
        set @returnmessage = 'JSON string generated and encoded successfully.';
    end try
    begin catch
        select
            @returnvalue = 1,
            @returnmessage = 'error occurred: ['
                            + ' error_line: ' + try_cast(error_line() as nvarchar(max))
                            + ' error_number: ' + try_cast(error_number() as nvarchar(max))
                            + ' error_message: ' + try_cast(error_message() as nvarchar(max))
                            + ' ]';
    end catch
end