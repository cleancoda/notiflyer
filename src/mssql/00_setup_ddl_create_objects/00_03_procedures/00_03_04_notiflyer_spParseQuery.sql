if object_id('notiflyer_spParseQuery') is not null
    print 'notiflyer_spParseQuery stored procedure exists, skipping create attempt..'
    print 'ignore error below, cannot create exception handling on ddl statements'
    return;
go

create procedure notiflyer_spParseQuery
/*
    @author     cleancoda
    @date       11192023
    @detail     procedure processes and generates dataset from the query passed as a parameter to
                returns a dataset table with only the columns required
    @sample
                exec notiflyer_spGetMetaData
                    @query = 'select * from Sales.Customers';
    @log
                cc  11112023 - generated basic script file
*/
(
    
)
as
begin

end