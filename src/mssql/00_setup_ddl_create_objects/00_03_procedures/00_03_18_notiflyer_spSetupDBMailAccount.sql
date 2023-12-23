if object_id('notiflyer_spSetupDBMailAccount') is not null
    print 'notiflyer_spSetupDBMailAccount stored procedure exists, skipping create attempt..'
    print 'ignore error below, cannot create exception handling on ddl statements'
    return;
go

-- drop procedure notiflyer_spSetupDBMailAccount
create procedure notiflyer_spSetupDBMailAccount
/*
    @author     cleancoda
    @date       12162023
    @detail     
    @sample
                declare
                    @returnvalue as int = 0
                    ,@returnmessage as nvarchar(255) = '';
                
                exec notiflyer_spSetupDBMailAccount
                    @account_name = 'account_name'
                    ,@email_address = 'example@example.com'
                    ,@display_name = 'account_display_name'
                    ,@mail_server_name = 'mail.example.com'
                    ,@port = 25
                    ,@username = 'username'
                    ,@password = 'password'
                    ,@use_default_credentials bit = 0
                    ,@returnvalue = 0
                    ,@returnmessage = ''

    @log
                cc  12162023 - generated basic script file
*/
(
    @account_name nvarchar(100) = ''
    ,@account_description nvarchar(max) = ''
    ,@email_address nvarchar(100) = ''
    ,@display_name nvarchar(100) = ''
    ,@mail_server_name nvarchar(100) = ''
    ,@port int = 25
    ,@enable_ssl int = 1
    ,@username nvarchar(100) = ''
    ,@password nvarchar(100) = ''
    ,@use_default_credentials bit = 0
    ,@returnvalue as int = 0 output
    ,@returnmessage as nvarchar(255) = '' output
)
as
begin
    begin try
        -- setup a new database mail account
        exec 
            msdb.dbo.sysmail_add_account_sp
                @account_name = @account_name
                ,@description = @account_description
                ,@email_address = @email_address
                ,@display_name = @display_name
                ,@mailserver_name = @mail_server_name
                ,@port = @port
                ,@enable_ssl = @enable_ssl
                ,@username = @username
                ,@password = @password
                ,@use_default_credentials = @use_default_credentials;

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
