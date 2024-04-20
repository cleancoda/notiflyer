if object_id('notiflyer_spSetupSQLAgentJob') is not null
    print 'notiflyer_spSetupSQLAgentJob stored procedure exists, skipping create attempt..'
    print 'ignore error below, cannot create exception handling on ddl statements'
    return;
go

-- drop procedure notiflyer_spSetupSQLAgentJob
create procedure notiflyer_spSetupSQLAgentJob
/*
    @author     cleancoda
    @date       01052024
    @detail     creates and setup a new sql agent job
    @sample
                declare
                    @returnvalue as int = 0
                    ,@returnmessage as nvarchar(max) = '';
                
                exec notiflyer_spSetupSQLAgentJob
                    @job_id = 1
                    ,@returnvalue = 0
                    ,@returnmessage = ''

                select @returnvalue, @returnmessage;

    @log
                cc  04202024 - generated basic script file
*/
(
    @job_id as int = 0
    ,@job_name as varchar(255) = 'notiflyer_job'
    ,@returnvalue as int = 0
    ,@returnmessage as nvarchar(255) = ''
)
as
begin
    /*
        -- agent needs to be enabled
        exec sp_configure 
        -- check if Agent XPs = 1

        -- enable advanced options
        use master
        go
        exec sp_configure 'Show advanced options',1
        Go
        reconfigure with override
        go

        -- set Agent XPs = 1 to enable sql job agent
        use master
        go
        exec sp_configure 'Agent XPs',1
        Go
        reconfigure with override
        go
    */

    declare
        @job_name as nvarchar(255) = 'notiflyer_job'
        ,@job_description as nvarchar(255) = 'notiflyer job'
        ,@job_owner as nvarchar(255) = 'sa'
        ,@job_category as nvarchar(255) = 'notiflyer'
        ,@job_step_name as nvarchar(255) = 'notiflyer_job_step'
        ,@job_step_command as nvarchar(255) = 'exec notiflyer_spProcessNotification'
        ,@job_step_subsystem as nvarchar(255) = 'T-SQL'
        ,@job_step_on_success_action as int = 1
        ,@job_step_on_fail_action as int = 2
        ,@job_step_retry_attempts as int = 0
        ,@job_step_retry_interval as int = 0
        ,@job_step_output_file_name as nvarchar(255) = 'notiflyer_job_output.txt'
        ,@job_step_output_file_append as int = 1
        ,@job_step_output_file_overwrite as int = 0
        ,@job_step_output_file_no_output as int = 0
        ,@job_step_output_file_delete as int = 0
        ,@job_step_output_file_reopen as int = 0
        ,@job_step_output_file_reopen_interval as int = 0
        ,@job_step_output_file_reopen_threshold as int = 0
        ,@job_step_output_file_reopen_action as int = 0
        ,@job_step_output_file_reopen_action_threshold as int = 0
        ,@job_step_output_file_reopen_action_interval as int = 0
        ,@job_step_output_file_reopen_action_max as int = 0
        ,@job_step_output_file_reopen_action_min as int = 0
        ,@job_step_output_file_reopen_action_max_interval as int = 0
        ,@job_step_output_file_reopen_action_min_interval as int = 0
        ,@job_step_output_file_reopen_action_max_threshold as int = 0
        ,@job_step_output_file_reopen_action_min_threshold as int = 0
        ,@job_step_output_file_reopen_action_max_action as int = 0

    

end