/*
    @author     cleancoda
    @date       11112023
    @detail     procedure to accept several parameters, including sql queries to 
                generate and return a table as output containing metadata about the query
                passed as a parameter
    @log
                cc  11112023 - generated basic script file
*/

create procedure notiflyer_spGetMetaData
(
    @query as nvarchar(max) = ''
)
as
begin   
    -- no query passed
    if(@query = '')
        begin
            return;
        end

    -- test
    EXEC sp_describe_first_result_set 
            @tsql = N'SELECT * FROM Sales.Orders', 
            @params = null, 
            @browse_information_mode = 0;

    
end