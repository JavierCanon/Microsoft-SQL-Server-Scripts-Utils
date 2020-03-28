/* MIT LICENSE Copyright (c) 2020 Javier Cañon | www.javiercanon.com */
CREATE PROCEDURE [dbo].[Export_XML_Query]
    -- Add the parameters for the stored procedure here
     @query varchar(7000)
    ,@fileAndPath varchar(100)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
declare @tsql varchar(8000);

select @tsql = 'bcp "' + @query + ' FOR XML RAW, ROOT;" queryout  "' + @fileAndPath + '" -x -c -T -S'+ @@servername;

exec master..xp_cmdshell @tsql;

END