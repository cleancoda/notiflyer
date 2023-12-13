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
                    @returnvalue as int = 0
                    ,@returnmessage as nvarchar(255) = '';
                
                exec notiflyer_spEmailBuildBody
                    ,@returnvalue = 0
                    ,@returnmessage = ''

    @log
                cc  12132023 - generated basic script file


*/
(
    @returnvalue as int = 0 output
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

