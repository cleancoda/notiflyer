if object_id('notiflyer_trJobManager') is not null
    print 'notiflyer_trJobManager trigger exists, skipping create attempt..'
    print 'ignore error below, cannot create exception handling on ddl statements'
    return;
go

-- drop trigger notiflyer_trJobManager
alter trigger notiflyer_trJobManager on notiflyer_tbJobManager for insert, update
/*
    @author     cleancoda
    @date       04252024
    @detail     trigger for job manager form - generates a new sql agent job
    @log
                cc  04252024 - generated basic script file
*/
as
begin

    declare @counter as int = 0, @jobid as int;

    -- loop through inserted jobs - handle multiple inserts/imports
    while(@counter < (select count(*) from inserted))
    begin
        select @jobid = id from inserted;
        exec notiflyer_spSetupSQLAgentJob @job_id = @jobid;
        set @counter = @counter + 1;
    end

end

