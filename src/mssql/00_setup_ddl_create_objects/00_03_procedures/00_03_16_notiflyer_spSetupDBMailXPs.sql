if object_id('notiflyer_spSetupDBMailXPs') is not null
    print 'notiflyer_spSetupDBMailXPs stored procedure exists, skipping create attempt..'
    print 'ignore error below, cannot create exception handling on ddl statements'
    return;
go

-- drop procedure notiflyer_spSetupDBMailXPs
create procedure notiflyer_spSetupDBMailXPs
/*
    @author     cleancoda
    @date       12162023
    @detail     
    @sample
                declare
                    @returnvalue as int = 0
                    ,@returnmessage as nvarchar(255) = '';
                
                exec notiflyer_spSetupDBMailXPs
                    ,@returnvalue = 0
                    ,@returnmessage = ''

    @log
                cc  12162023 - generated basic script file
*/
as
begin
    begin try
        -- enable database mail
        exec sp_configure 'show advanced options', 1;
        reconfigure;
        exec sp_configure 'Database Mail XPs', 1;
        reconfigure;
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

