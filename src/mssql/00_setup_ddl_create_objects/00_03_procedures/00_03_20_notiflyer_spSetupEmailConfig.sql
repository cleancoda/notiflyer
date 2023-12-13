if object_id('notiflyer_spSetupEmailConfig') is not null
    print 'notiflyer_spSetupEmailConfig stored procedure exists, skipping create attempt..'
    print 'ignore error below, cannot create exception handling on ddl statements'
    return;
go

-- drop procedure notiflyer_spSetupEmailConfig
create procedure notiflyer_spSetupEmailConfig
/*
    @author     cleancoda
    @date       12122023
    @detail     
    @sample
                declare
                    @returnvalue as int = 0
                    ,@returnmessage as nvarchar(255) = '';
                
                exec notiflyer_spSetupEmailConfig
                    ,@returnvalue = 0
                    ,@returnmessage = ''

    @log
                cc  12132023 - generated basic script file
*/


