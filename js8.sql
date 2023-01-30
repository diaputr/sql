--1
CREATE PROCEDURE Sales.GetTopCustomers AS
SELECT TOP(10) c.custid, c.contactname,
SUM(o.val) AS salesvalue
FROM Sales.OrderValues AS o
INNER JOIN Sales.Customers AS c
ON c.custid = o.custid
GROUP BY c.custid, c.contactname
ORDER BY salesvalue DESC;

EXEC Sales.GetTopCustomers;

--3
ALTER PROCEDURE Sales.GetTopCustomers AS
SELECT c.custid, c.contactname,
SUM(o.val) AS salesvalue
FROM Sales.OrderValues AS o
INNER JOIN Sales.Customers AS c
ON c.custid = o.custid
GROUP BY c.custid, c.contactname
ORDER BY salesvalue DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

EXEC Sales.GetTopCustomers;

--7
ALTER PROCEDURE Sales.GetTopCustomers 
@orderyear int
AS
SELECT c.custid, c.contactname, 
SUM(o.val) AS salesvalue 
FROM Sales.OrderValues AS o 
INNER JOIN Sales.Customers AS c 
ON c.custid = o.custid 
WHERE YEAR(o.orderdate) = @orderyear 
GROUP BY c.custid, c.contactname 
ORDER BY salesvalue DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

EXECUTE Sales.GetTopCustomers;

--13
ALTER PROCEDURE Sales.GetTopCustomers 
@orderyear int = NULL
AS
SELECT c.custid, c.contactname, 
SUM(o.val) AS salesvalue 
FROM Sales.OrderValues AS o 
INNER JOIN Sales.Customers AS c 
ON c.custid = o.custid 
WHERE YEAR(o.orderdate) = @orderyear 
OR @orderyear IS NULL
GROUP BY c.custid, c.contactname 
ORDER BY salesvalue DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

EXECUTE Sales.GetTopCustomers;

--15
ALTER PROCEDURE Sales.GetTopCustomers 
@orderyear int = NULL, 
@n int = 10 
AS
SELECT c.custid, c.contactname, 
SUM(o.val) AS salesvalue 
FROM Sales.OrderValues AS o 
INNER JOIN Sales.Customers AS c 
ON c.custid = o.custid 
WHERE YEAR(o.orderdate) = @orderyear 
OR
@orderyear IS NULL
GROUP BY c.custid, c.contactname 
ORDER BY salesvalue DESC
OFFSET 0 ROWS FETCH NEXT @n ROWS ONLY;

EXECUTE Sales.GetTopCustomers;

--16
EXEC Sales.GetTopCustomers @orderyear = 2008, @n = 5;

--17
EXEC Sales.GetTopCustomers @n = 20 ;

--20
ALTER PROCEDURE Sales.GetTopCustomers 
@customerpos int = 1, 
@customername nvarchar(30) OUTPUT
AS
SET @customername = ( 
SELECT c.contactname 
FROM Sales.OrderValues AS o 
INNER JOIN Sales.Customers AS c 
ON c.custid = o.custid 
GROUP BY c.custid, c.contactname 
ORDER BY SUM(o.val) DESC 
OFFSET @customerpos - 1 ROWS FETCH NEXT 1 ROW ONLY 
);

DECLARE @outcustomername nvarchar(30);
EXECUTE Sales.GetTopCustomers @customername = @outcustomername OUTPUT;
SELECT @outcustomername customername;

--24
EXEC sys.sp_help 'Sales.Customers';

--25
EXEC sys.sp_helptext 'Sales.GetTopCustomers';

--26
EXEC sys.sp_columns 'Customers', 'Sales';