/* MIT LICENSE Copyright (c) 2020 Javier Cañon | www.javiercanon.com */

-- SQL Server. How to List Queries With Memory Grant and Execution Plan.  it will show you all the currently running SQL Server queries. It will not show you historical information. the column granted_memory_kb displays how much memory was granted by SQL Server for that query to execute. Additionally the last two column demonstrates the query executed as well as execution plan for the query.
-- Reference : Pinal Dave (https://blog.sqlauthority.com)

SELECT mg.session_id
,mg.granted_memory_kb
,mg.requested_memory_kb
,mg.ideal_memory_kb
,mg.request_time
,mg.grant_time
,mg.query_cost
,mg.dop
,st.[TEXT]
,qp.query_plan
FROM sys.dm_exec_query_memory_grants AS mg
CROSS APPLY sys.dm_exec_sql_text(mg.plan_handle) AS st
CROSS APPLY sys.dm_exec_query_plan(mg.plan_handle) AS qp
ORDER BY mg.required_memory_kb DESC;