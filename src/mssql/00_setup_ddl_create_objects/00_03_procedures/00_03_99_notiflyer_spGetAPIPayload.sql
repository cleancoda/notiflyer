if object_id('notiflyer_spGetAPIPayload') is not null
    print 'notiflyer_spGetAPIPayload stored procedure exists, skipping create attempt..'
    print 'ignore error below, cannot create exception handling on ddl statements'
    return;
go

create procedure notiflyer_spGetAPIPayload
/*
    @author     cleancoda
    @date       11162023
    @detail     future feature set for notiflyer - currently setup as default placeholder
                accepts rest api parameters for performing get,post,delete operations on the api
    @log
                cc  11162023 - generated basic script file
*/
(

    @api_url nvarchar(8000) = ''            -- api endpoint url
    ,@api_method nvarchar(5) = ''           -- GET, POST, PUT, DELETE
    ,@api_key nvarchar(8000) = ''           -- authorization key, api key, bearer key
    ,@api_payload_type nvarchar(255) = ''   -- application/json, application/xml
    ,@api_bodydata_type nvarchar(255) = ''  -- json string - parse using key/value pair definition '{"key":"value"}'
)
as 
begin
    begin try
    end try
    begin catch
    end catch
end