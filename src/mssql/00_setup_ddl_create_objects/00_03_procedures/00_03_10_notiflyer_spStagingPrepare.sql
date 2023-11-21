if object_id('notiflyer_spStagingPrepare') is not null
    print 'notiflyer_spStagingPrepare stored procedure exists, skipping create attempt..'
    print 'ignore error below, cannot create exception handling on ddl statements'
    return;
go

create procedure notiflyer_spStagingPrepare
/*
    @author     cleancoda
    @date       11212023
    @detail     
    @sample
                exec notiflyer_spStagingPrepare;
    @log
                cc  11212023 - generated basic script file
*/