if object_id('notiflyer_fnJsonPrepDataSetLabel') is not null
    print 'notiflyer_fnJsonPrepDataSetLabel function exists, skipping create attempt..'
    print 'ignore error below, cannot create exception handling on ddl statements'
    return;
go

create function notiflyer_fnJsonPrepDataSetLabel
/*
    @author     cleancoda
    @date       11132023
    @detail     prepares a json string based on parameters passed to it
    @notes
                cc 11132023 -   access notiflyer_tbDataTable 
                                - this table will be globally accessible to notiflyer, and other procedures can access this table 
                                - this table will be populated prior to accessing this function
                                - at time of populating table, convert each element into string equivalent
                                - this function will ONLY work with STRING values
                                - this function aims at parsing and preparing the dataset and labels for notiflyer

                                - IMPORTANT - maintain the mapping of X/Y axes and their order of data (for example, Jan 23 - 200 orders - Customer A)
                                    - if they are separately parsed, there might be chance of incorrectly ordering/mapping the elements leading to an incorrect chart
    @log
                cc  11132023 - generated basic script file                                            
                                    
*/
(
    @chart_type nvarchar(max) = ''
    ,@x_column_label nvarchar(max) = ''
    ,@x_column_data nvarchar(max) = ''
    ,@x_column_data_type nvarchar(max) = ''
    ,@y_column_label nvarchar(max) = ''
    ,@y_column_data nvarchar(max) = ''
    ,@y_column_data_type nvarchar(max) = ''
) returns nvarchar(max)
as
    begin
        -- declare variables
        declare
            @jsonPayload as nvarchar(max);

        -- prep data series
        -- TODO:
		select
            *
		from
			notiflyer_tbDataTable;

        return @jsonPayload;
    end