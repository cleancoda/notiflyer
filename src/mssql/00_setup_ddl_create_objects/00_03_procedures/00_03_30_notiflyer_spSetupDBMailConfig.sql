if object_id('notiflyer_spSetupDBMailConfig') is not null
    print 'notiflyer_spSetupDBMailConfig stored procedure exists, skipping create attempt..'
    print 'ignore error below, cannot create exception handling on ddl statements'
    return;
go

-- drop procedure notiflyer_spSetupDBMailConfig
create procedure notiflyer_spSetupDBMailConfig
/*
    @author     cleancoda
    @date       12122023
    @detail     
    @sample
                declare
                    @returnvalue as int = 0
                    ,@returnmessage as nvarchar(255) = '';
                
                exec notiflyer_spSetupDBMailConfig
                    @profile_name = 'test'
                    ,@profile_description = 'profile description'
                    ,@accountname = 'test'
                    ,@account_description = 'account description'
                    ,@emailaddress = '@gmail.com'
                    ,@displayname = 'test'
                    ,@mailservername = 'smtp.gmail.com'
                    ,@port = 587
                    ,@enablessl = 1
                    ,@username  = '@gmail.com'
                    ,@password  = ''
                    ,@returnvalue = 0 
                    ,@returnmessage = '' ;

                -- send sample email
                EXEC msdb.dbo.sp_send_dbmail
                    @profile_name = 'test'
                    ,@recipients = '@gmail.com'
                    ,@body = 'The stored procedure finished successfully.'
                    ,@subject = 'Test Email from SQL';

    @log
                cc  12132023 - generated basic script file
*/
(
    @profile_name nvarchar(50) = 'profilename'
    ,@profile_description nvarchar(100) = 'profiledescription'
    ,@account_name nvarchar(50) = 'accountname'
    ,@account_description nvarchar(100) = 'profiledescription'
    ,@email_address nvarchar(100) = 'emailaddress'
    ,@display_name nvarchar(50) = 'displayname'
    ,@mail_server_name nvarchar(50) = 'mailservername'
    ,@port int = 587
    ,@enable_ssl bit = 1
    ,@username nvarchar(50) = 'username'
    ,@password nvarchar(50) = 'password'
    ,@returnvalue as int = 0 output
    ,@returnmessage as nvarchar(255) = '' output
)
as
begin
    begin try

        -- TODO:
        -- issue #80
        -- add try/cast checks to see if exists prior to create

        -- setup new profile
        execute notiflyer_spSetupDBMailProfile
            @profile_name = @profile_name
            ,@profile_description = @profile_description;  

        -- add profile to db role for emails, and set as default profile
        execute notiflyer_spSetupDBMailProfileDefault
            @profile_name = @profile_name;
                    
        -- add a new smtp account
        execute notiflyer_spSetupDBMailAccount --msdb.dbo.sysmail_add_account_sp  
            @account_name = @account_name
            ,@account_description = @account_description
            ,@email_address = @email_address
            ,@display_name = @display_name 
            ,@mail_server_name = @mail_server_name
            ,@port = @port
            ,@enable_ssl = @enable_ssl
            ,@username = @username
            ,@password = @password;  

        -- attach profile to new smtp account
        execute notiflyer_spSetupDBMailAddAccountToProfile --msdb.dbo.sysmail_add_profileaccount_sp  
            @account_name = @account_name
            ,@profile_name = @profile_name;   

            
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

