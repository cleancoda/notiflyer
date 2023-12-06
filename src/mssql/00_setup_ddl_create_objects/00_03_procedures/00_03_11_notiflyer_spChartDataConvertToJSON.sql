if object_id('notiflyer_spChartDataConvertToJSON') is not null
    print 'notiflyer_spChartDataConvertToJSON stored procedure exists, skipping create attempt..'
    print 'ignore error below, cannot create exception handling on ddl statements'
    return;
go

-- drop procedure notiflyer_spChartDataConvertToJSON
create procedure notiflyer_spChartDataConvertToJSON
/*
    @author     cleancoda
    @date       12062023
    @detail     
    @sample
                exec notiflyer_spChartDataConvertToJSON
    @log
                cc  12062023 - generated basic script file
*/
(
    @column_axes_x_axes_label as nvarchar(max) = '' output
    ,@column_axes_x_data_label as nvarchar(max) = '' output
    ,@returnvalue as int = 0 output
    ,@returnmessage as nvarchar(255) = '' output
)
as
begin
    begin try

            
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