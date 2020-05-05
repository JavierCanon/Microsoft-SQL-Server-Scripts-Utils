SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
–- =============================================
–- Author:        Nicolas Verhaeghe
–- Create date: 12/14/2008
–- Description:   Determines if a given integer is a prime
/*

      SELECT dbo.IsPrime(1)

      SELECT dbo.IsPrime(9)

      SELECT dbo.IsPrime(7867)

*/
–- =============================================
CREATE FUNCTION [dbo].[IsPrime]
(
      @NumberToTest int
)
RETURNS bit
AS
BEGIN
      -– Declare the return variable here
      DECLARE @IsPrime bit,
                  @Divider int

      –- To speed things up, we will only attempt dividing by odd numbers

      –- We first take care of all evens, except 2
      IF (@NumberToTest % 2 = 0 AND @NumberToTest > 2)
            SET @IsPrime = 0
      ELSE
            SET @IsPrime = 1 –- By default, declare the number a prime

      –- We then use a loop to attempt to disprove the number is a prime

      SET @Divider = 3 -– Start with the first odd superior to 1

      –- We loop up through the odds until the square root of the number to test
      –- or until we disprove the number is a prime
      WHILE (@Divider <= floor(sqrt(@NumberToTest))) AND (@IsPrime = 1)
      BEGIN

            –- Simply use a modulo
            IF @NumberToTest % @Divider = 0
                  SET @IsPrime = 0
            –- We only consider odds, therefore the step is 2
            SET @Divider = @Divider + 2
      END  

      –- Return the result of the function
      RETURN @IsPrime

END

GO

CREATE FUNCTION IsPrime2
(
    @number INT
)
RETURNS VARCHAR(10)
BEGIN
    DECLARE @prime_or_notPrime INT
    DECLARE @counter INT
    DECLARE @retVal VARCHAR(10)
    SET @retVal = 'FALSE'

    SET @prime_or_notPrime = 1
    SET @counter = 2

    WHILE (@counter <= @number/2 )
    BEGIN

        IF (( @number % @counter) = 0 )
        BEGIN
            set @prime_or_notPrime = 0
            BREAK
        END

        IF (@prime_or_notPrime = 1 )
        BEGIN
            SET @retVal = 'TRUE'
        END

        SET @counter = @counter + 1
    END
    return @retVal
END


GO


/*
-- OTHER OPCIONS --

-- Return table:

WITH temp
     AS (SELECT
           2 AS Value;
         UNION ALL
         SELECT
           t.Value + 1 AS Value
         FROM   temp t
         WHERE
           t.Value < 1000;)
SELECT
  *
FROM   temp t
WHERE
  NOT EXISTS
      (SELECT
         1
       FROM   temp t2
       WHERE
        t.Value % t2.Value = 0
        AND t.Value != t2. Value)
OPTION (MaxRecursIon 0); 

----------------------------------

DECLARE @Min int = 2, @Max int = 100000
--
IF OBJECT_ID('tempdb..#N','U') IS NOT NULL DROP TABLE #N
--
CREATE TABLE #N(N int NOT NULL, SqrtN int NOT NULL);
--
  WITH L0 AS (SELECT 'Anything' N FROM (VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) AS T(N)), -- 16 values
       L1 AS (SELECT A.N FROM L0 A, L0 B, L0 C, L0 D, L0 E, L0 F, L0 G, L0 H), -- 15^8  values (2562890625 more than enough for max value of int (2^31-1)
       L2 AS (SELECT TOP(@Max/6) CONVERT(int,6*ROW_NUMBER() OVER (ORDER BY (SELECT NULL))) RowNum FROM L1)
INSERT INTO #N(N, SqrtN)
SELECT T.N, SQRT(N)
  FROM L2
 CROSS APPLY(VALUES(L2.RowNum-1),(L2.RowNum+1)) T(N)
 WHERE T.N BETWEEN @Min AND @Max
   AND 0 NOT IN (N%5,N%7,N%11,N%13,N%17,N%19,N%23,N%29,N%31,N%37,N%41,N%43,N%47,N%53,N%59)  -- Not interested in anything dividable by these low primes
--
ALTER TABLE #N ADD PRIMARY KEY CLUSTERED(N) WITH FILLFACTOR = 100
--
IF OBJECT_ID('tempdb..#Primes','U') IS NOT NULL DROP TABLE #Primes
--
SELECT Z.N Prime
  FROM (SELECT N FROM (VALUES(2),(3),(5),(7),(11),(13),(17),(19),(23),(29),(31),(37),(41),(43),(47),(53),(59)) T(N)
         WHERE T.N BETWEEN @Min AND @Max
         UNION ALL
        SELECT X.N
          FROM #N AS X
         WHERE NOT EXISTS(SELECT *
                            FROM #N AS C
                           WHERE C.N <= X.SqrtN 
                             AND 0 = X.N%C.N)) Z
 ORDER BY 1
 
----------------------------------------------

*/
