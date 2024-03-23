if object_id('notiflyer_spSetupDBMailAddAccountToProfile') is not null
    print 'notiflyer_spSetupDBMailAddAccountToProfile stored procedure exists, skipping create attempt..'
    print 'ignore error below, cannot create exception handling on ddl statements'
    return;
go

-- drop procedure notiflyer_spSetupDBMailAddAccountToProfile
create procedure notiflyer_spSetupDBMailAddAccountToProfile
/*
    @author     cleancoda
    @date       12162023
    @detail     
    @sample
                declare
                    @account_id as int = 1
                    ,@profile_id as int = 1
                    ,@returnvalue as int = 0
                    ,@returnmessage as nvarchar(255) = '';
                
                exec notiflyer_spSetupDBMailAddAccountToProfile
                    @account_id = @account_id
                    ,@profile_id = @profile_id
                    ,@returnvalue = 0
                    ,@returnmessage = ''

    @log
                cc  12162023 - generated basic script file
*/
(
    @account_name nvarchar(100) = ''
    ,@profile_name nvarchar(255) = ''
    ,@returnvalue as int = 0 output
    ,@returnmessage as nvarchar(255) = '' output
)
as
begin
    begin try
        -- delete account from profile if exists
        exec 
            msdb.dbo.sysmail_delete_profileaccount_sp
                @profile_name = @profile_name
                ,@account_name = @account_name;

        -- attach account to profile
        exec 
            msdb.dbo.sysmail_add_profileaccount_sp
                @profile_name = @profile_name
                ,@account_name = @account_name
                ,@sequence_number = 1;
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