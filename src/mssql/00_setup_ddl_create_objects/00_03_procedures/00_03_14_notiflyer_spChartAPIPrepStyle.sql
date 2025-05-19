if object_id('notiflyer_spChartAPIPrepStyle') is not null
    print 'notiflyer_spChartAPIPrepStyle stored procedure exists, skipping create attempt..'
    print 'ignore error below, cannot create exception handling on ddl statements'
    return;
go

create procedure notiflyer_spChartAPIPrepStyle
/*
    @author     
    @date       
    @detail     Builds a JSON object string for QuickChart API with customizable options.
    @sample

    @log
                cc  - generated basic script file
*/
(
    @chart_type nvarchar(max),
    @column_axes_x_axes_json_label nvarchar(max),
    @column_axes_y_axes_json_label nvarchar(max),
    @chart_column_legend nvarchar(max),
    @background_color nvarchar(max) = 'rgba(75, 192, 192, 0.2)',
    @border_color nvarchar(max) = 'rgba(75, 192, 192, 1)',
    @font_size int = 12,
    @json_string nvarchar(max) output,
    @returnvalue int output,
    @returnmessage nvarchar(255) output
)
as
begin
    set nocount on;

    begin try
        -- Initialize JSON string
        set @json_string = '{'
            + '"type": "' + @chart_type + '",'
            + '"data": {'
                + '"labels": ' + @column_axes_x_axes_json_label + ','
                + '"datasets": ['
                    + '{'
                        + '"label": "' + @chart_column_legend + '",'
                        + '"data": ' + @column_axes_y_axes_json_label + ','
                        + '"backgroundColor": "' + @background_color + '",'
                        + '"borderColor": "' + @border_color + '",'
                        + '"borderWidth": 1'
                    + '}'
                + ']'
            + '},'
            + '"options": {'
                + '"plugins": {';

        -- Add chart-specific options
        set @json_string = @json_string
            + case 
                when @chart_type = 'pie' then
                    '"legend": { "display": true },'
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
                when @chart_type = 'bar' then
                    '"datalabels": {'
                        + '"anchor": "end",'
                        + '"align": "top",'
                        + '"offset": 10,'
                        + '"color": "#000",'
                        + '"font": {'
                            + '"size": ' + cast(@font_size as nvarchar)
                        + '}'
                    + '}'
                when @chart_type = 'line' then
                    '"datalabels": {'
                        + '"anchor": "center",'
                        + '"align": "middle",'
                        + '"color": "#333",'
                        + '"font": {'
                            + '"size": ' + cast(@font_size as nvarchar)
                        + '}'
                    + '}'
                else
                    '"datalabels": {'
                        + '"anchor": "end",'
                        + '"align": "top",'
                        + '"color": "#000",'
                        + '"font": {'
                            + '"size": ' + cast(@font_size as nvarchar)
                        + '}'
                    + '}'
            end;

        -- Close JSON string
        set @json_string = @json_string
            + '}'
            + '}'
        + '}';

        -- Set success return values
        set @returnvalue = 0;
        set @returnmessage = 'JSON string successfully generated.';
    end try
    begin catch
        -- Handle errors
        set @returnvalue = error_number();
        set @returnmessage = error_message();
    end catch;
end;
go
