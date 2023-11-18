
/*
    @author     cleancoda
    @date       11182023
    @detail     analytical stored procedures to run against sample
                database provided by microsoft - wide world importers
    @log
                cc  11182023 - generated basic script file
    @credit(s) 
                https://cjlise.github.io/software-engineering/SQLComplexQueries/
*/

CREATE PROCEDURE [dbo].[ReportCustomerTurnover] 
	-- Add the parameters for the stored procedure here
	@Choice  int=1, 
	@Year int = 2013
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @TurnOver VARCHAR;
	SET @TurnOver = 'ToTalTurnOver' + CAST(@YEAR AS VARCHAR) ;
	
	IF @Choice = 1 AND  NOT(@Year IS NULL)
	
	BEGIN
		SELECT DISTINCT C.CustomerName, 

			   SUM(CASE  WHEN MONTH(T.InvoiceDate)= 1 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) As Jan ,
			   SUM(CASE  WHEN MONTH(T.InvoiceDate)= 2 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) AS Feb,
			   SUM(CASE  WHEN MONTH(T.InvoiceDate)= 3 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) AS Mar,
			   SUM(CASE  WHEN MONTH(T.InvoiceDate)= 4 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) AS Apr,
			   SUM(CASE  WHEN MONTH(T.InvoiceDate)= 5 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) AS May,
			   SUM(CASE  WHEN MONTH(T.InvoiceDate)= 6 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) AS Jun,
			   SUM(CASE  WHEN MONTH(T.InvoiceDate)= 7 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) AS Jul,
			   SUM(CASE  WHEN MONTH(T.InvoiceDate)= 8 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) AS Aug,
			   SUM(CASE  WHEN MONTH(T.InvoiceDate)= 9 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) AS Sep,
			   SUM(CASE  WHEN MONTH(T.InvoiceDate)= 10 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) AS Oct,
			   SUM(CASE  WHEN MONTH(T.InvoiceDate)= 11 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) As Nov,
			   SUM(CASE  WHEN MONTH(T.InvoiceDate)= 12 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) AS [Dec]

		FROM
		(	SELECT I.InvoiceID, I.CustomerID, I.InvoiceDate, IL.UnitPrice, IL.Quantity, IL.InvoiceLineID

   
			FROM Sales.Invoices AS I, Sales.InvoiceLines AS IL
			WHERE I.InvoiceID = IL.InvoiceID
		) AS T, Sales.Customers AS C 
		WHERE T.CustomerID = C.CustomerID
		AND YEAR(T.InvoiceDate) = @Year
		GROUP BY CustomerName  
		ORDER BY CustomerName ;
	END;
	IF @Choice = 2 AND  NOT(@Year IS NULL)
	BEGIN
		SELECT C.CustomerName, 

			   SUM(CASE  WHEN DATEPART(qq,T.InvoiceDate) = 1 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) As Q1 ,
			   SUM(CASE  WHEN DATEPART(qq,T.InvoiceDate) = 2 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) AS Q2 ,
			   SUM(CASE  WHEN DATEPART(qq,T.InvoiceDate) = 3 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) AS Q3,
			   SUM(CASE  WHEN DATEPART(qq,T.InvoiceDate) = 4 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) AS Q4

		FROM
		(	SELECT I.InvoiceID, I.CustomerID, I.InvoiceDate, IL.UnitPrice, IL.Quantity, IL.InvoiceLineID

   
			FROM Sales.Invoices AS I, Sales.InvoiceLines AS IL
			WHERE I.InvoiceID = IL.InvoiceID
		) AS T, Sales.Customers AS C 
		WHERE T.CustomerID = C.CustomerID
		AND YEAR(T.InvoiceDate) = @Year
		GROUP BY CustomerName 	
		ORDER BY CustomerName ;
	END;
	IF @Choice = 3
	BEGIN
		SELECT C.CustomerName, 

			   SUM(CASE  WHEN YEAR(T.InvoiceDate) = 2013 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) AS '2013' ,
			   SUM(CASE  WHEN YEAR(T.InvoiceDate) = 2014 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) AS '2014' ,
			   SUM(CASE  WHEN YEAR(T.InvoiceDate) = 2015 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) AS '2015',
			   SUM(CASE  WHEN YEAR(T.InvoiceDate) = 2016 THEN (T.UnitPrice * T.Quantity) ELSE 0 END) AS '2016'

		FROM
		(	SELECT I.InvoiceID, I.CustomerID, I.InvoiceDate, IL.UnitPrice, IL.Quantity, IL.InvoiceLineID

   
			FROM Sales.Invoices AS I, Sales.InvoiceLines AS IL
			WHERE I.InvoiceID = IL.InvoiceID
		) AS T, Sales.Customers AS C 
		WHERE T.CustomerID = C.CustomerID
		GROUP BY CustomerName 	
		ORDER BY CustomerName ;
	END;

END
