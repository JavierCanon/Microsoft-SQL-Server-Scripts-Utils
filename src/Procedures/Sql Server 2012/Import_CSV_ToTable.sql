/* MIT LICENSE Copyright (c) 2020 Javier Cañon | www.javiercanon.com */
CREATE PROCEDURE [dbo].[ImportFromCSV_ToXTable]
  -- Add the parameters for the stored procedure here
  @FilePath VARCHAR(300)
AS
  BEGIN
      -- SET NOCOUNT ON added to prevent extra result sets from
      -- interfering with SELECT statements.
      SET NOCOUNT ON;

      -- wait for 10 second
      --WAITFOR DELAY '00:00:05';

      -- Insert statements for procedure here
      --SELECT @FilePath;

	  --TRUNCATE TABLE [XTable];
	  --DBCC CHECKIDENT ('XTable', RESEED, 1) ;
	
DECLARE @tsql NVARCHAR(4000);

SET @tsql = N'BULK INSERT [MyDatabase].[dbo].[XTable]
  FROM ''' + @FilePath  + '''
  WITH
    (
	  ERRORFILE = ''' + @FilePath + '.Error.txt' + '''
	 ,FIRSTROW=2
     ,FIELDTERMINATOR = ''\t''
     ,ROWTERMINATOR = ''\n''
    ) 
';

PRINT @tsql;

BEGIN TRY  
	EXEC (@tsql);
	SELECT 'Data Imported';
	RETURN;
	
END TRY  
BEGIN CATCH  

SELECT  
     ERROR_MESSAGE() AS ErrorMessage
    ,ERROR_NUMBER() AS ErrorNumber  
    ,ERROR_SEVERITY() AS ErrorSeverity  
    ,ERROR_STATE() AS ErrorState  
    ,ERROR_PROCEDURE() AS ErrorProcedure  
    ,ERROR_LINE() AS ErrorLine  
;  

END CATCH  
;  

  END