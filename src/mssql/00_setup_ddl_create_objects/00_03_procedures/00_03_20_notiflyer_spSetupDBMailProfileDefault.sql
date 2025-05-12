if object_id('notiflyer_spSetupDBMailProfileDefault') is not null
    print 'notiflyer_spSetupDBMailProfileDefault stored procedure exists, skipping create attempt..'
    print 'ignore error below, cannot create exception handling on ddl statements'
    return;
go

-- drop procedure notiflyer_spSetupDBMailProfileDefault
create procedure notiflyer_spSetupDBMailProfileDefault
/*
    @author     cleancoda
    @date       12122023
    @detail     
    @sample
                declare
                    @profile_name nvarchar(50) = 'test'
                    ,@returnvalue as int = 0
                    ,@returnmessage as nvarchar(255) = '';
                
                exec notiflyer_spSetupDBMailProfileDefault
                    @profile_name = @profile_name
                    ,@returnvalue = 0
                    ,@returnmessage = ''

    @log
                cc  12132023 - generated basic script file
*/
(
    @profile_name nvarchar(50) = ''
    ,@returnvalue as int = 0 output
    ,@returnmessage as nvarchar(255) = '' output
)
as
begin
    begin try
        execute 
            msdb.dbo.sysmail_add_principalprofile_sp
            @profile_name = @profile_name
            ,@principal_name = 'public'
            ,@is_default = 1;
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