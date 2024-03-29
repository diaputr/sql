/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [orderid]
      ,[productid]
      ,[unitprice]
      ,[qty]
      ,[discount]
  FROM [TSQL].[Sales].[OrderDetails] ORDER BY [orderid] DESC;

  DELETE  FROM [TSQL].[Sales].[OrderDetails] WHERE productid = 1 AND qty = 1 AND unitprice = 0;