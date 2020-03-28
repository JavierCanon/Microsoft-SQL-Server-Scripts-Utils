/* MIT LICENSE Copyright (c) 2020 Javier Cañon | www.javiercanon.com */
DECLARE @TableName varchar(255)

DECLARE TableCursor CURSOR FOR
SELECT sysobjects.name AS CheckIDENT
FROM sysobjects INNER JOIN
 syscolumns ON sysobjects.id = syscolumns.id
WHERE (syscolumns.colstat & 1 <> 0) AND (sysobjects.xtype = 'U') AND (sysobjects.name <> N'dtproperties')

OPEN TableCursor

FETCH NEXT FROM TableCursor INTO @TableName
WHILE @@FETCH_STATUS = 0
BEGIN 
PRINT 'CHECK IDENTITY: ' + @TableName
DBCC CHECKIDENT(@TableName)
FETCH NEXT FROM TableCursor INTO @TableName
END

CLOSE TableCursor

DEALLOCATE TableCursor

