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
                cc 11132023 -   access notiflyer_tmpDataTable 
                                - this table will be globally accessible to notiflyer, and other procedures can access this table 
                                - this table will be populated prior to accessing this function
                                - at time of populating table, convert each element into string equivalent
                                - this function will ONLY work with STRING values
                                - this function aims at parsing and preparing the dataset and labels for notiflyer

                                - IMPORTANT - maintain the mapping of X/Y axes and their order of data (for example, Jan 23 - 200 orders - Customer A)
                                    - if they are separately parsed, there might be chance of incorrectly ordering/mapping the 
                                    elements leading to incorrect plot on chart
    @log
                cc  11132023 - generated basic script file             
                
                select dbo.notiflyer_fnJsonPrepDataSetLabel('pie','January, February, March, April, May','','','','','')
                                    
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

        /*
            example: 
            {type:'line',data:{labels:['January','February','March','April','May'],datasets:[{label:'Dogs',data:[50,60,70,180,190],fill:false,borderColor:'blue'},{label:'Cats',data:[100,200,300,400,500],fill:false,borderColor:'green'}]}}

            broken out:
            -- line
            {
                type: 'line',
                data: {
                    labels: ['January', 'February', 'March', 'April', 'May'],
                    datasets: [
                    {
                        label: 'Dogs',
                        data: [50, 60, 70, 180, 190]
                    },
                    {
                        label: 'Cats',
                        data: [100, 200, 300, 400, 500]
                    },
                    ],
                },
            }

            -- pie
            {
                type: 'pie',
                data: {
                    labels: ['January', 'February', 'March', 'April', 'May'],
                    datasets: [{ data: [50, 60, 70, 180, 190] }],
                },
            }        
        */

        -- cartesian axes
        -- pie chart
        select
            @jsonPayload =
            concat(
                    '{'''
                    ,coalesce(@chart_type,'')
                    ,''','
                    ,'data: {'
                        ,'labels: [',@x_column_label,']',','
                        ,'datasets: [{'
                    )

        return @jsonPayload;
    end