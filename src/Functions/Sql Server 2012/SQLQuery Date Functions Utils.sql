/* MIT LICENSE Copyright (c) 2020 Javier Cañon | www.javiercanon.com */
GO
/****** Object:  UserDefinedFunction [dbo].[fnGetCountDaysInMonth]    Script Date: 3/28/2020 1:04:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetCountDaysInMonth] 
(
    -- Add the parameters for the function here
    @date DATE
)
RETURNS int
AS
BEGIN
    -- Declare the return variable here


    -- Return the result of the function
    RETURN datediff(day, dateadd(day, 1-day(@date), @date), dateadd(month, 1, dateadd(day, 1-day(@date), @date)))
    ;


END





GO
/****** Object:  UserDefinedFunction [dbo].[fnGetDatesFromDateRange]    Script Date: 3/28/2020 1:04:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnGetDatesFromDateRange]
(     
      @Increment              CHAR(1),
      @StartDate              DATE,
      @EndDate                DATE
)
RETURNS  
@SelectedRange    TABLE 
(IndividualDate DATE)
AS 
BEGIN
      ;WITH cteRange (DateRange) AS (
            SELECT @StartDate
            UNION ALL
            SELECT 
                  CASE
                        WHEN @Increment = 'd' THEN DATEADD(dd, 1, DateRange)
                        WHEN @Increment = 'w' THEN DATEADD(ww, 1, DateRange)
                        WHEN @Increment = 'm' THEN DATEADD(mm, 1, DateRange)
                  END
            FROM cteRange
            WHERE DateRange <= 
                  CASE
                        WHEN @Increment = 'd' THEN DATEADD(dd, -1, @EndDate)
                        WHEN @Increment = 'w' THEN DATEADD(ww, -1, @EndDate)
                        WHEN @Increment = 'm' THEN DATEADD(mm, -1, @EndDate)
                  END)
          
      INSERT INTO @SelectedRange (IndividualDate)
      SELECT DateRange
      FROM cteRange
      OPTION (MAXRECURSION 3660);
      RETURN
END


GO
/****** Object:  UserDefinedFunction [dbo].[fnGetDatesOfMonthCurrentYear]    Script Date: 3/28/2020 1:04:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetDatesOfMonthCurrentYear]
(
    -- Add the parameters for the function here
    @day DATE
)
RETURNS 
@Table_Var TABLE 
(
    -- Add the column definitions for the TABLE variable here
     DateOfMonth DATE
     ,DayOfMonth Int
    ,DayOfWeek Int
)
AS
BEGIN
    -- Fill the table variable with the rows for your result set
    DECLARE @month TINYINT
    SELECT	@month = MONTH(@day);

    WITH CTE_Days AS(
        SELECT 
        dateadd(month,@month-1,dateadd(year,datediff(year,0,getdate()),0)) D 
        UNION ALL
        SELECT 
        DATEADD(day, 1, D)FROM CTE_Days 
        WHERE D < dateadd(month,@month,dateadd(year,datediff(year,0,getdate()),0))-1
    )
    INSERT INTO @Table_Var
    SELECT 
      D
      ,DATEPART(DAY, D) 
     ,DATEPART(dw, D) 
    FROM CTE_Days
    ;

    RETURN 
END




GO
/****** Object:  UserDefinedFunction [dbo].[fnGetDatetimesFromDateRange]    Script Date: 3/28/2020 1:04:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnGetDatetimesFromDateRange]
(     
      @Increment              CHAR(1),
      @StartDate              DATETIME,
      @EndDate                DATETIME
)
RETURNS  
@SelectedRange    TABLE 
(IndividualDate DATETIME)
AS 
BEGIN
      ;WITH cteRange (DateRange) AS (
            SELECT @StartDate
            UNION ALL
            SELECT 
                  CASE
                        WHEN @Increment = 'd' THEN DATEADD(dd, 1, DateRange)
                        WHEN @Increment = 'w' THEN DATEADD(ww, 1, DateRange)
                        WHEN @Increment = 'm' THEN DATEADD(mm, 1, DateRange)
                  END
            FROM cteRange
            WHERE DateRange <= 
                  CASE
                        WHEN @Increment = 'd' THEN DATEADD(dd, -1, @EndDate)
                        WHEN @Increment = 'w' THEN DATEADD(ww, -1, @EndDate)
                        WHEN @Increment = 'm' THEN DATEADD(mm, -1, @EndDate)
                  END)
          
      INSERT INTO @SelectedRange (IndividualDate)
      SELECT DateRange
      FROM cteRange
      OPTION (MAXRECURSION 3660);
      RETURN
END



GO
/****** Object:  UserDefinedFunction [dbo].[fnGetDaysInMonth]    Script Date: 3/28/2020 1:04:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetDaysInMonth] 
(
    -- Add the parameters for the function here
    @date DATE
)
RETURNS int
AS
BEGIN
    -- Declare the return variable here


    -- Return the result of the function
    RETURN datediff(day, dateadd(day, 1-day(@date), @date), dateadd(month, 1, dateadd(day, 1-day(@date), @date)))
    ;


END



GO
/****** Object:  UserDefinedFunction [dbo].[fnGetFirstDayCurrentMonth]    Script Date: 3/28/2020 1:04:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetFirstDayCurrentMonth]
(
    -- Add the parameters for the function here
    @mydate DATE
)
RETURNS DATE
AS
BEGIN

    -- Return the result of the function
    RETURN DATEADD(dd,-(DAY(@mydate)-1), @mydate);

END




GO
/****** Object:  UserDefinedFunction [dbo].[fnGetFirstDayNextMonth]    Script Date: 3/28/2020 1:04:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetFirstDayNextMonth]
(
    -- Add the parameters for the function here
    @mydate DATE
)
RETURNS DATE
AS
BEGIN

    -- Return the result of the function
    RETURN DATEADD(dd,-(DAY(DATEADD(mm,1,@mydate))-1),DATEADD(mm,1,@mydate));

END




GO
/****** Object:  UserDefinedFunction [dbo].[fnGetFirstDayPreviousMonth]    Script Date: 3/28/2020 1:04:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetFirstDayPreviousMonth]
(
    -- Add the parameters for the function here
    @mydate DATE
)
RETURNS DATE
AS
BEGIN

    DECLARE @lastdaylm DATE;
    SET @lastdaylm = DATEADD(dd,-DAY(@mydate), @mydate);

    -- Return the result of the function
    RETURN DATEADD(dd,-DAY(@lastdaylm)+1, @lastdaylm);

END




GO
/****** Object:  UserDefinedFunction [dbo].[fnGetLastDayCurrentMonth]    Script Date: 3/28/2020 1:04:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetLastDayCurrentMonth]
(
    -- Add the parameters for the function here
    @mydate DATE
)
RETURNS DATE
AS
BEGIN

    -- Return the result of the function
    RETURN DATEADD(dd,-(DAY(DATEADD(mm,1,@mydate))),DATEADD(mm,1,@mydate));

END




GO
/****** Object:  UserDefinedFunction [dbo].[fnGetLastDayNextMonth]    Script Date: 3/28/2020 1:04:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetLastDayNextMonth]
(
    -- Add the parameters for the function here
    @mydate DATE
)
RETURNS DATE
AS
BEGIN

    DECLARE @lastdaynm DATE;
    SET @lastdaynm = DATEADD(month, 1, @mydate);

    -- Return the result of the function
    RETURN DATEADD(dd,-(DAY(DATEADD(mm,1,@lastdaynm))),DATEADD(mm,1,@lastdaynm));

END




GO
/****** Object:  UserDefinedFunction [dbo].[fnGetLastDayPreviousMonth]    Script Date: 3/28/2020 1:04:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetLastDayPreviousMonth]
(
    -- Add the parameters for the function here
    @mydate DATE
)
RETURNS DATE
AS
BEGIN

    -- Return the result of the function
    RETURN DATEADD(dd,-DAY(@mydate), @mydate);

END




GO
/****** Object:  UserDefinedFunction [dbo].[fnGetWeekDayFromMonday]    Script Date: 3/28/2020 1:04:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Javier Cañon
-- Create date: <Create Date, ,>
-- Description:	Return day of week without know of server SET DATEFIRST setting
-- =============================================
CREATE FUNCTION [dbo].[fnGetWeekDayFromMonday]
(
    -- Add the parameters for the function here
    @SomeDate DATE
)
RETURNS int
AS
BEGIN

DECLARE @SqlWeekDay INT, @ResultVar int;

    SET  @SqlWeekDay= DATEPART(dw, @SomeDate);
    SET @ResultVar = ((@SqlWeekDay + @@DATEFIRST - 1 - 1) % 7) + 1;


    -- Return the result of the function
    RETURN @ResultVar;

END
GO
