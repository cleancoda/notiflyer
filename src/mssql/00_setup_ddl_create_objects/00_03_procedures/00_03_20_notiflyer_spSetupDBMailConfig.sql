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

        -- setup new profile
        EXECUTE msdb.dbo.sysmail_add_profile_sp  
            @profile_name = '',  
            @description = '' ;  

        -- add profile to db role for emails, and set as default profile
        EXECUTE msdb.dbo.sysmail_add_principalprofile_sp  
            @profile_name = '',  
            @principal_name = 'public',  
            @is_default = 1 ;
            
        -- add a new smtp account
        EXECUTE msdb.dbo.sysmail_add_account_sp  
            @account_name = '',  
            @description = '',  
            @email_address = '',  
            @display_name = '',  
            @mailserver_name = '',
            @port = 587,
            @enable_ssl = 1,
            @username = '',
            @password = '' ;  

        -- attach profile to new smtp account
        EXECUTE msdb.dbo.sysmail_add_profileaccount_sp  
            @profile_name = '',  
            @account_name = '',  
            @sequence_number =1 ;            

            
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

