
/*
    @author     cleancoda
    @date       11182023
    @detail     analytical queries to run against sample database provided
                by microsoft - wide world importers
    @log
                cc  11182023 - generated basic script file
    @credit(s) 
                https://cjlise.github.io/software-engineering/SQLComplexQueries/
*/


-- top 10 customers by order month
select top 10 CustomerID,dateadd(month, datediff(month, 0, OrderDate), 0) as OrderMonth,count(1) as TotalAmount
from WideWorldImporters.Sales.Orders
group by CustomerID ,dateadd(month, datediff(month, 0, OrderDate), 0)
order by TotalAmount desc


-- consistency between orders and their attached invoices
SELECT A.CustomerId, C.CustomerName,  COUNT( DISTINCT A.OrderId) TotalNBOrders, COUNT( DISTINCT A.InvoiceId) TotalNBInvoices,
       SUM(A.UnitPrice*A.Quantity)AS OrdersTotalValue,  SUM(A.UnitPriceI * A.QuantityI) AS InvoicesTotalValue,
	   ABS(SUM(A.UnitPrice * A.Quantity) -  SUM(A.UnitPriceI*A.QuantityI)) AS AbsoluteValueDifference
FROM 
(
	SELECT O.CustomerID, O.OrderId, NULL AS InvoiceID, OL.UnitPrice, OL.Quantity, 0 AS UnitPriceI, 0 AS QuantityI, OL.OrderLineID, NULL AS InvoiceLineID 
	FROM Sales.Orders As O, Sales.OrderLines AS OL
	WHERE O.OrderId = OL.OrderID AND EXISTS
	(	SELECT II.OrderId
		FROM Sales.Invoices AS II
		WHERE II.OrderID = O.OrderID
	)
	UNION
	SELECT I.CustomerID, NULL AS OrderId, I.InvoiceID, 0 AS UnitPriceO, 0 AS QuantityO, IL.UnitPrice, IL.Quantity, NULL AS OrderLineID, InvoiceLineID
	FROM Sales.Invoices AS I, Sales.InvoiceLines AS IL
	WHERE I.InvoiceID = IL.InvoiceID
) AS A, Sales.Customers As C
WHERE A.CustomerID = C.CustomerID
GROUP BY A.CustomerID, C.CustomerName
ORDER BY AbsoluteValueDifference DESC, TotalNBOrders, CustomerName


-- loss of revenue from orders not being converted into invoices
SELECT  D.CustomerCategoryName, D.MaxLoss, D.CustomerName, D.CustomerID
FROM
(
	SELECT DISTINCT S.CustomerCategoryName, S.MaxLoss, S.CustomerName, S.CustomerID, ROW_NUMBER() OVER (Partition by S.CustomerCategoryName  
		            Order by S.MaxLoss DESC) AS RowNo 
	FROM
	(
		SELECT CustomerCategoryName, SUM(F.UnitPrice * F.Quantity)  OVER ( Partition by CustomerCategoryName, F.CustomerName) AS MaxLoss, 
				F.CustomerName , F.CustomerID
		FROM
		(
			SELECT  C.CustomerName, C.CustomerId, C.CustomerCategoryId, L.UnitPrice, L.Quantity
			FROM
			(
				SELECT  T.CustomerID, T.OrderID, OL.UnitPrice, OL.Quantity
				FROM 
				(
					SELECT O.CustomerID, O.OrderID
					FROM Sales.Orders as O
					WHERE NOT EXISTS
					(
						SELECT *
						FROM Sales.Invoices as I
						WHERE I.OrderID = O.OrderID
					)
				) AS T, Sales.OrderLines AS OL
				WHERE T.OrderID = OL.OrderID
			) AS L, Sales.Customers AS C
			WHERE L.CustomerID = C.CustomerID
		) AS F, Sales.CustomerCategories AS G
		WHERE F.CustomerCategoryID = G.CustomerCategoryID
	) AS S 
) AS D
WHERE D.RowNo <=1
ORDER BY D.MaxLoss DESC
