if object_id('notiflyer_spTestDBMailSendEmail') is not null
    print 'notiflyer_spTestDBMailSendEmail stored procedure exists, skipping create attempt..'
    print 'ignore error below, cannot create exception handling on ddl statements'
    return;
go

-- drop procedure notiflyer_spDBMailSendEmail
create procedure notiflyer_spDBMailSendEmail
/*
    @author     cleancoda
    @date       04072024
    @detail     
    @sample
                declare
                    @returnvalue as int = 0
                    ,@returnmessage as nvarchar(255) = '';
                
                exec notiflyer_spDBMailSendEmail
                    @profile_name = 'test'
                    ,@recipients = 'pranav.shirodkar@protonmail.com'
                    ,@body = '<html><body><p>test</p></body></html>'
                    ,@subject = 'test'
                    ,@returnvalue = 0
                    ,@returnmessage = ''

    @log
                cc  04072024 - generated basic script file
*/
(
        
    @profile_name as nvarchar(50) = ''
    ,@recipients as nvarchar(max) = ''
    ,@body as nvarchar(max) = ''
    ,@subject as nvarchar(255) = ''
    ,@returnvalue as int = 0 output
    ,@returnmessage as nvarchar(255) = '' output
)
as
begin
    begin try
        exec msdb.dbo.sp_send_dbmail
            @profile_name = @profile_name,
            @recipients = @recipients,
            @body = @body,
            @subject = @subject,
            @body_format = 'HTML';
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