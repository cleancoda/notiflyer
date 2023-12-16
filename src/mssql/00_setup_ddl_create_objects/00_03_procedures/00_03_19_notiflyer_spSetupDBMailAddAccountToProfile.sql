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
                    @returnvalue as int = 0
                    ,@returnmessage as nvarchar(255) = '';
                
                exec notiflyer_spSetupDBMailAddAccountToProfile
                    ,@returnvalue = 0
                    ,@returnmessage = ''

    @log
                cc  12162023 - generated basic script file
*/