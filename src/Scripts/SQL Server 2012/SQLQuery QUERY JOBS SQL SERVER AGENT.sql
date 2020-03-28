/* MIT LICENSE Copyright (c) 2020 Javier Cañon | www.javiercanon.com */

-- https://docs.microsoft.com/en-us/sql/relational-databases/system-tables/dbo-sysjobhistory-transact-sql

-- query jobs
select 
  j.name as 'JobName'
 ,step_id
 ,step_name
 ,message	
 ,STUFF(STUFF(RIGHT(REPLICATE('0', 6) +  CAST(h.run_time as varchar(6)), 6), 3, 0, ':'), 6, 0, ':') 'run_time'
 ,STUFF(STUFF(STUFF(RIGHT(REPLICATE('0', 8) + CAST(h.run_duration as varchar(8)), 8), 3, 0, ':'), 6, 0, ':'), 9, 0, ':') 'run_duration' -- (DD:HH:MM:SS)
 ,msdb.dbo.agent_datetime(run_date, run_time) as 'RunDateTime'
 ,((run_duration/10000*3600 + (run_duration/100)%100*60 + run_duration%100 + 31 ) / 60) 
         as 'RunDurationMinutes'
,case run_status	
when 0 then 'Failed'
when 1 then 'Succeeded'
when 2 then 'Retry'
when 3 then 'Canceled'
end run_status
,retries_attempted
From msdb.dbo.sysjobs j 
INNER JOIN msdb.dbo.sysjobhistory h 
 ON j.job_id = h.job_id 
where j.enabled = 1   --Only Enabled Jobs
--and j.name = 'TestJob' --Uncomment to search for a single job
/*
and msdb.dbo.agent_datetime(run_date, run_time) 
BETWEEN '12/08/2012' and '12/10/2012'  --Uncomment for date range queries
*/
order by JobName, RunDateTime desc



-- query jobs with steps

select 
 j.name as 'JobName',
 s.step_id as 'Step',
 s.step_name as 'StepName',
 msdb.dbo.agent_datetime(run_date, run_time) as 'RunDateTime',
 ((run_duration/10000*3600 + (run_duration/100)%100*60 + run_duration%100 + 31 ) / 60) 
         as 'RunDurationMinutes'
,case run_status	
when 0 then 'Failed'
when 1 then 'Succeeded'
when 2 then 'Retry'
when 3 then 'Canceled'
when 4 then 'in progress'
else 'unknown'
end run_status
From msdb.dbo.sysjobs j 
INNER JOIN msdb.dbo.sysjobsteps s 
 ON j.job_id = s.job_id
INNER JOIN msdb.dbo.sysjobhistory h 
 ON s.job_id = h.job_id 
 AND s.step_id = h.step_id 
 AND h.step_id <> 0
where j.enabled = 1   --Only Enabled Jobs
--and j.name = 'TestJob' --Uncomment to search for a single job
/*
and msdb.dbo.agent_datetime(run_date, run_time) 
BETWEEN '12/08/2012' and '12/10/2012'  --Uncomment for date range queries
*/
order by JobName, RunDateTime desc



-- create a temporary table of instances when a job was initiated
declare @JOBS table
(
    RUN_INSTANCE uniqueidentifier, 
    job_id uniqueidentifier,
    name sysname,
    run_status int, 
    run_date int, 
    run_time int, 
    run_duration int
);

-- insert one record for each instanced job and assign it a unique identifier
insert into @JOBS
    select 
        RUN_INSTANCE = NewID(), 
        h.job_id, 
        j.name, 
        h.run_status, 
        h.run_date, 
        h.run_time, 
        h.run_duration
    from msdb.dbo.sysjobhistory h
        join msdb.dbo.sysjobs j on j.job_id = h.job_id
    where step_id = 0

-- query the jobs history
select 
    h.server,
    j.RUN_INSTANCE, 
    j.name, 
    h.step_id, 
    h.run_date, 
    h.run_time, 
    run_status = 
        case h.run_status
            when 0 then 'failed'
            when 1 then 'succeeded'
            when 2 then 'retry'
            when 3 then 'canceled'
            when 4 then 'in progress'
            else '???'
        end,
    h.message
from @JOBS j
    join msdb.dbo.sysjobhistory h on 
        h.job_id = j.job_id
        and convert(varchar(20),h.run_date) + convert(varchar(20),h.run_time) 
           between convert(varchar(20),j.run_date) + convert(varchar(20),j.run_time) 
           and convert(varchar(20),j.run_date) + convert(varchar(20),j.run_time + j.run_duration) 
order by j.RUN_INSTANCE, h.step_id  


-- RUNING JOBS EVITE FALSE POSITIVES FROM OTHER SESSIONS
-- https://stackoverflow.com/questions/200195/how-can-i-determine-the-status-of-a-job

SELECT
    job.name, 
    job.job_id, 
    job.originating_server, 
    activity.run_requested_date, 
    DATEDIFF( SECOND, activity.run_requested_date, GETDATE() ) as Elapsed
FROM 
    msdb.dbo.sysjobs_view job
JOIN
    msdb.dbo.sysjobactivity activity
ON 
    job.job_id = activity.job_id
JOIN
    msdb.dbo.syssessions sess
ON
    sess.session_id = activity.session_id
JOIN
(
    SELECT
        MAX( agent_start_date ) AS max_agent_start_date
    FROM
        msdb.dbo.syssessions
) sess_max
ON
    sess.agent_start_date = sess_max.max_agent_start_date
WHERE 
    run_requested_date IS NOT NULL AND stop_execution_date IS NULL