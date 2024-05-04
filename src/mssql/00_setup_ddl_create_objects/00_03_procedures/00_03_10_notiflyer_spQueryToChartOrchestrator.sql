if object_id('notiflyer_spQueryToChartOrchestrator') is not null
    print 'notiflyer_spQueryToChartOrchestrator stored procedure exists, skipping create attempt..'
    print 'ignore error below, cannot create exception handling on ddl statements'
    return;
go

-- create procedure notiflyer_spQueryToChartOrchestrator
-- /*
--     @author     cleancoda
--     @date       03202024
--     @detail     invoked by job or manually, orchestrates running the query and 
--                 converts the data into json for quickchart
--     @sample     
-- */
-- (
    
-- )
-- as
-- begin

-- end