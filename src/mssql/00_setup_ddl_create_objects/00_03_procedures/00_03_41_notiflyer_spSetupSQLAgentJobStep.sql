if object_id('notiflyer_spSetupSQLAgentJobStep') is not null
    print 'notiflyer_spSetupSQLAgentJobStep stored procedure exists, skipping create attempt..'
    print 'ignore error below, cannot create exception handling on ddl statements'
    return;
go

-- drop procedure notiflyer_spSetupSQLAgentJobStep
create procedure notiflyer_spSetupSQLAgentJobStep
/*
    @author     cleancoda
    @date       04252024
    @detail     creates and setup a new sql agent job step
    @sample
                declare
                    @returnvalue as int = 0
                    ,@returnmessage as nvarchar(max) = '';
                
                exec notiflyer_spSetupSQLAgentJobStep
                    @job_id = 2
                    ,@returnvalue = 0
                    ,@returnmessage = ''

                select @returnvalue, @returnmessage;

    @log
                cc  04252024 - generated basic script file
*/
(
    @job_id as int = 0
    ,@returnvalue as int = 0
    ,@returnmessage as nvarchar(255) = ''
)
as
begin

    declare
        @job_name as nvarchar(255) = 'notiflyer_job'
        ,@job_description as nvarchar(255) = 'notiflyer job'
        ,@job_owner as nvarchar(255) = 'sa'
        ,@job_category as nvarchar(255) = 'notiflyer'
        ,@job_step_name as nvarchar(255) = 'notiflyer_job_step'
        ,@job_step_command as nvarchar(255) = 'exec notiflyer_spProcessNotification'
        ,@job_step_subsystem as nvarchar(255) = 'T-SQL'
        ,@database_name as nvarchar(255) = ''
        ,@active_start_date as int = 0
        ,@active_end_date as int = 99991231
        ,@freq_type as int = 4 -- (h)ourly,@ (d)aily,@ (w)eekly,@ (m)onthly
        ,@frequency char(1) = 'd'  -- (h)ourly,@ (d)aily,@ (w)eekly,@ (m)onthly
        ,@freq_interval as int = 1
        ,@freq_subday_type as int = 1
        ,@freq_subday_interval as int = 0
        ,@freq_relative_interval as int = 0
        ,@freq_recurrence_factor as int = 0
        ,@run_time varchar(5) = '02:00' -- job run time hh:mm - follows 24 hours pattern -- hourly jobs will use this as an interval
        ,@run_day_monday bit = 0
        ,@run_day_tuesday bit = 0
        ,@run_day_wednesday bit = 0
        ,@run_day_thursday bit = 0
        ,@run_day_friday bit = 0
        ,@run_day_saturday bit = 0
        ,@run_day_sunday bit = 0

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
        ,@job_step_output_file_reopen_action_max_action as int = 0;


    select
        @job_name = name
        ,@job_description = description
        ,@frequency = frequency
        ,@run_time = run_time
        ,@run_day_monday = run_day_monday
        ,@run_day_tuesday = run_day_tuesday
        ,@run_day_wednesday = run_day_wednesday
        ,@run_day_thursday = run_day_thursday
        ,@run_day_friday = run_day_friday
        ,@run_day_saturday = run_day_saturday
        ,@run_day_sunday = run_day_sunday
        ,@active_start_date = format(getdate(), 'yyyyMMdd')
        ,@database_name = db_name()
    from
        dbo.notiflyer_tbJobManager
    where
        id = @job_id;

    -- prepare sql command
    set @job_step_command = 'exec dbo.notiflyer_spExecuteJob ' + try_cast(@job_id as nvarchar(max)) + '';

    -- set step name
    set @job_step_name = 'execute query job ' + @job_name;

    -- set schedule parametrs
    select
        @freq_type = case @frequency
                            when 'h' then 4
                            when 'd' then 4
                            when 'w' then 8
                            when 'm' then 16
                            end
        ,@freq_interval = case @frequency
                            when 'h' then 4
                            when 'd' then 4
                            when 'w' then 8
                            when 'm' then 16
                            end
        ,@freq_subday_type = case @frequency
                            when 'h' then 8
                            when 'd' then 1
                            when 'w' then 1
                            when 'm' then 1
                            end
        -- ,@freq_subday_interval = case @frequency
        --                     when 'h' then 1
        --                     when 'd' then 0
        --                     when 'w' then 0
        --                     when 'm' then 0
        --                     end

    -- create job step
        exec msdb.dbo.sp_add_jobstep
            @job_name = @job_name
            ,@step_name = @job_step_name
            ,@step_id = 1
            ,@command = @job_step_command
            --,@database_name = @database_name
            -- ,@subsystem = @job_step_subsystem
            -- ,@on_success_action = @job_step_on_success_action
            -- ,@on_fail_action = @job_step_on_fail_action
            -- ,@retry_attempts = @job_step_retry_attempts
            -- ,@retry_interval = @job_step_retry_interval
            -- ,@output_file_name = @job_step_output_file_name
            -- ,@output_file_append = @job_step_output_file_append
            -- ,@output_file_overwrite = @job_step_output_file_overwrite
            -- ,@output_file_no_output = @job_step_output_file_no_output
            -- ,@output_file_delete = @job_step_output_file_delete
            -- ,@output_file_reopen = @job_step_output_file_reopen
            -- ,@output_file_reopen_interval = @job_step_output_file_reopen_interval
            -- ,@output_file_reopen_threshold = @job_step_output_file_reopen_threshold
            -- ,@output_file_reopen_action = @job_step_output_file_reopen_action
            -- ,@output_file_reopen_action_threshold = @job_step_output_file_reopen_action_threshold
            -- ,@output_file_reopen_action_interval = @job_step_output_file_reopen_action_interval
            -- ,@output_file_reopen_action_max = @job_step_output_file_reopen_action_max
            -- ,@output_file_reopen_action_min = @job_step_output_file_reopen_action_min
            -- ,@output_file_reopen_action_max_interval = @job_step_output_file_reopen_action_max_interval
            -- ,@output_file_reopen_action_min_interval = @job_step_output_file_reopen_action_min_interval
            -- ,@output_file_reopen_action_max_threshold = @job_step_output_file_reopen_action_max_threshold
            -- ,@output_file_reopen_action_min_threshold = @job_step_output_file_reopen_action_min_threshold
            -- ,@output_file_reopen_action_max_action = @job_step_output_file_reopen_action_max_action;

end