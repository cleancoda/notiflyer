if object_id('notiflyer_spEmailBuildBody') is not null
    print 'notiflyer_spEmailBuildBody stored procedure exists, skipping create attempt..'
    print 'ignore error below, cannot create exception handling on ddl statements'
    return;
go

-- drop procedure notiflyer_spEmailBuildBody
create procedure notiflyer_spEmailBuildBody 
/*
    @author     cleancoda
    @date       12122023
    @detail     
    @sample
                declare
                    @html_full as nvarchar(max) = ''
                    ,@returnvalue as int = 0
                    ,@returnmessage as nvarchar(255) = '';
                
                exec notiflyer_spEmailBuildBody
                    @html_full = @html_full
                    ,@returnvalue = 0
                    ,@returnmessage = ''

                select @html_full;

    @log
                cc  12132023 - generated basic script file
    @credits
                icons - https://icon-icons.com
*/
(
    @html_full as nvarchar(max) = '' output
    ,@returnvalue as int = 0 output
    ,@returnmessage as nvarchar(255) = '' output
)
as
begin
    begin try

        -- loop variables for drawing html table
        declare
            @html_header as nvarchar(max) = ''
            ,@html_footer as nvarchar(max) = ''
            ,@rows as int = 0
            ,@columns as int = 0
            ,@row_counter as int = 1
            ,@column_counter as int = 1;

        select
            @rows = max(t.grid_row)
            ,@columns = max(t.grid_column)
        from
            ##tmpnotiflyer_tbQueryResults t;

        print @rows
        print @columns;
        
        -- build html table
        declare
            @html_body as nvarchar(max) = '';

        select
            @html_header = N'<html>
                        <body style="background-color: #ffffff;">
                            <div class="header" style="display: flex; justify-content: center; align-items: center; text-align: center; height: 70px; background-color: #ffffff;">
                                <img src="https://cdn.icon-icons.com/icons2/2351/PNG/512/logo_telegram_airplane_air_plane_paper_airplane_icon_143169.png" alt="Logo" style="max-width: 40px;">
                                <h1 style="margin: 0;">notiflyer</h1>
                            </div>
                            <div class="grid-container" style="display: grid; grid-template-rows: 1fr 1fr; grid-template-columns: 1fr 1fr;">
                        ';

        select
            @html_footer = N'
                            </div>
                            <div class="footer" style="display: flex; justify-content: center; align-items: center; text-align: center; height: 100px; background-color: #ffffff;">
                                <div>
                                    <!--<img src="https://cdn.icon-icons.com/icons2/555/PNG/512/facebook_icon-icons.com_53612.png" alt="Facebook" style="max-width: 32px;">
                                    <img src="https://cdn.icon-icons.com/icons2/555/PNG/512/twitter_icon-icons.com_53611.png" alt="Twitter" style="max-width: 32px;">
                                    <img src="https://cdn.icon-icons.com/icons2/555/PNG/512/instagram_icon-icons.com_53610.png" alt="Instagram" style="max-width: 32px;">--!>
                                    <p>made with <img src="https://cdn.icon-icons.com/icons2/860/PNG/512/love_icon-icons.com_67808.png" style="max-height: 12px;"> by <a href="https://github.com/cleancoda" style="link:#2EE21D;hover:#00FF78;visited:#00FF78;active:#5EF00F;">cleancoda</p>
                                </div>
                            </div>
                        </body>
                        </html>';

        -- loop through rows and columns
        while @row_counter <= @rows
        begin
            print 'row: ' + try_cast(@row_counter as nvarchar(max));
            -- start row
            while @column_counter <= @columns
            begin
                -- start column
                set @html_body = @html_body + N'<div class="grid-item">';

                select
                    
                    @html_body = @html_body 
                                    -- label header = chart title
                                    + 
                                        case when isnull(t.label_header,'') <> '' then
                                            N'<h2 style="text-align: center;">' + isnull(t.label_header,'') + '</h2>'
                                        else
                                            N''
                                        end
                                    -- chart url
                                    +  N'<img src="' + isnull(t.chart_url,'') + '" style="max-width: 100%;"></div>'
                from
                    ##tmpnotiflyer_tbQueryResults t
                where
                    t.grid_row = @row_counter
                    and t.grid_column = @column_counter;

                select *
                from
                    ##tmpnotiflyer_tbQueryResults t
                where   
                    t.grid_row = @row_counter
                    and t.grid_column = @column_counter;

                set @column_counter = @column_counter + 1;
            end
            -- reset column counter
            set @column_counter = 1;
            set @row_counter = @row_counter + 1;
        end

        -- 
        select
            @html_full = isnull(@html_header, '') + isnull(@html_body, '') + isnull(@html_footer, '');

        print @html_full;
        return @html_full;

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

