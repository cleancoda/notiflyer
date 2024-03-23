if object_id('notiflyer_spSetupDBMailProfile') is not null
    print 'notiflyer_spSetupDBMailProfile stored procedure exists, skipping create attempt..'
    print 'ignore error below, cannot create exception handling on ddl statements'
    return;
go

-- drop procedure notiflyer_spSetupDBMailProfile
create procedure notiflyer_spSetupDBMailProfile
/*
    @author     cleancoda
    @date       12162023
    @detail     
    @sample
                declare
                    @profile_id int
                    ,@returnvalue as int = 0
                    ,@returnmessage as nvarchar(255) = '';
                
                exec notiflyer_spSetupDBMailProfile
                    @profile_name = 'test'
                    ,@profile_description = 'test'
                    ,@profile_id = @profile_id
                    ,@returnvalue = 0
                    ,@returnmessage = ''

                SELECT @profile_id

    @log
                cc  12162023 - generated basic script file
*/
(
    @profile_name nvarchar(255) = ''
    ,@profile_description nvarchar(500) = ''
    ,@profile_id int = 0 output
    ,@returnvalue as int = 0 output
    ,@returnmessage as nvarchar(255) = '' output
)
as
begin
    begin try
        -- drop mail profile if exists
        exec 
            msdb.dbo.sysmail_delete_profile_sp
                @profile_name = @profile_name;

        exec
        -- add mail profile
            msdb.dbo.sysmail_add_profile_sp
                @profile_name = @profile_name
                ,@description = @profile_description
                ,@profile_id = @profile_id output;

        select
            @returnvalue = 0, @returnmessage = 'profile successfully added';
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

