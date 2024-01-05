if object_id('notiflyer_spExecuteJob') is not null
    print 'notiflyer_spExecuteJob stored procedure exists, skipping create attempt..'
    print 'ignore error below, cannot create exception handling on ddl statements'
    return;
go

-- drop procedure notiflyer_spExecuteJob
create procedure notiflyer_spExecuteJob
/*
    @author     cleancoda
    @date       01052024
    @detail     
    @sample
                declare
                    @returnvalue as int = 0
                    ,@returnmessage as nvarchar(255) = '';
                
                exec notiflyer_spExecuteJob
                    ,@returnvalue = 0
                    ,@returnmessage = ''

    @log
                cc  01052024 - generated basic script file
*/
(
    @
)