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
                    @profilename = 'test'
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
    @profilename nvarchar(50) = 'profilename'
    ,@profile_description nvarchar(100) = 'profiledescription'
    ,@accountname nvarchar(50) = 'accountname'
    ,@account_description nvarchar(100) = 'profiledescription'
    ,@emailaddress nvarchar(100) = 'emailaddress'
    ,@displayname nvarchar(50) = 'displayname'
    ,@mailservername nvarchar(50) = 'mailservername'
    ,@port int = 587
    ,@enablessl bit = 1
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
            @profile_name = @profilename,  
            @description = @profile_description;  

        -- add profile to db role for emails, and set as default profile
        execute notiflyer_sp
            @profile_name = @profilename,  
            @principal_name = 'public',  
            @is_default = 1;
                    
        -- add a new smtp account
        execute msdb.dbo.sysmail_add_account_sp  
            @account_name = @accountname,  
            @description = @account_description,  
            @email_address = @emailaddress,  
            @display_name = @displayname,  
            @mailserver_name = @mailservername,
            @port = @port,
            @enable_ssl = @enablessl,
            @username = @username,
            @password = @password;  

        -- attach profile to new smtp account
        execute msdb.dbo.sysmail_add_profileaccount_sp  
            @profile_name = @profilename,  
            @account_name = @accountname,  
            @sequence_number = 1;   

            
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

