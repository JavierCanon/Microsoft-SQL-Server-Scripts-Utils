/* MIT LICENSE Copyright (c) 2020 Javier Cañon | www.javiercanon.com */
SELECT t.name, s.row_count from sys.tables t
JOIN sys.dm_db_partition_stats s
ON t.object_id = s.object_id
AND t.type_desc = 'USER_TABLE'
AND t.name not like '%dss%'
AND s.index_id IN (0,1)