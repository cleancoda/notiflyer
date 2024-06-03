if object_id('notiflyer_spCreateLog') is not null
    print 'notiflyer_spCreateLog stored procedure exists, skipping create attempt..'
    print 'ignore error below, cannot create exception handling on ddl statements'
    return;
go

-- drop procedure notiflyer_spCreateLog 
create procedure notiflyer_spCreateLog
/*
    @author     cleancoda
    @date       06022024
    @detail     create log entry
    @sample
                exec notiflyer_spCreateLog

    @log
                cc  06022024 - generated basic script file
*/
(
    @log_description varchar(max) = ''
    ,@log_type char(1) = 'i' -- (i)nfo, (w)arning, (e)rror
    ,@log_source varchar(max) = ''
    ,@log_user varchar(max) = ''
    ,@returnvalue as int = 0 output
    ,@returnmessage as nvarchar(255) = '' output
)
as
begin
    begin try
        insert into notiflyer_tbLogApp
        (
            log_description
            ,log_type
            ,log_source
            ,log_user
        )
        values
        (
            @log_description
            ,@log_type
            ,@log_source
            ,@log_user
        )
    end try

    begin catch
        -- mark metadata scrape process as error
        select
            @returnvalue = 1
            ,@returnmessage = 'error occured: ['
                            +  ' error_line: ' + try_cast(error_line() as nvarchar(max))
                            +  ' error_number: ' + try_cast(error_number() as nvarchar(max))
                            +  ' error_message: ' + try_cast(error_message() as nvarchar(max))
                            +  ' ]'
    end catch  
end