---------------------------------------------------------------------
-- LAB 09
--
-- Exercise 1
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
-- 
-- Open the project file F:\10774A_Labs\10774A_09_PRJ\10774A_09_PRJ.ssmssln and the T-SQL script 51 - Lab Exercise 1.sql. To set your database context to that of the TSQL2012 database, highlight the statement USE TSQL2012; and execute the highlighted code. After executing this statement, the database name TSQL2012 should be selected in the Available Databases box. In subsequent exercises, you will simply be instructed to ensure that you are connected to the TSQL2012 database.
--
-- Write a SELECT statement that will return groups of customers that made a purchase. The SELECT clause should include the custid column from the Sales.Orders table and the contactname column from the Sales.Customers table. Group by both columns and filter only the orders from the sales employee whose empid equals five.
--
-- Execute the written statement and compare the results that you got with the desired results shown in the file 52 - Lab Exercise 1 - Task 1 Result.txt.
---------------------------------------------------------------------



---------------------------------------------------------------------
-- Task 2
-- 
-- Copy the T-SQL statement in task 1 and modify it to include the city column from the Sales.Customers table in the SELECT clause. 
--
-- Execute the query. You will get an error. What is the error message? Why?
--
-- Correct the query so that it will execute properly.
--
-- Execute the query and compare the results that you got with the desired results shown in the file 53 - Lab Exercise 1 - Task 2 Result.txt.
---------------------------------------------------------------------



---------------------------------------------------------------------
-- Task 3
-- 
-- Write a SELECT statement that will return groups of rows based on the custid column and a calculated column orderyear representing the order year based on the orderdate column from the Sales.Orders table. Filter the results to include only the orders from the sales employee whose empid equal five.
--
-- Execute the written statement and compare the results that you got with the desired results shown in the file 54 - Lab Exercise 1 - Task 3 Result.txt.
---------------------------------------------------------------------



---------------------------------------------------------------------
-- Task 4
-- 
-- Write a SELECT statement to retrieve groups of rows based on the categoryname column in the Production.Categories table. Filter the results to include only the product categories that were ordered in the year 2008.
--
-- Execute the written statement and compare the results that you got with the desired results shown in the file 55 - Lab Exercise 1 - Task 4 Result.txt. 
---------------------------------------------------------------------

--1
SELECT o.custid, c.contactname
FROM Sales.Orders o
JOIN Sales.Customers c
ON o.custid = c.custid
WHERE o.empid = 5
GROUP BY o.custid, c.contactname;

--2 & 4
SELECT o.custid, c.contactname, c.city
FROM Sales.Orders o
JOIN Sales.Customers c
ON o.custid = c.custid
WHERE o.empid = 5
GROUP BY o.custid, c.contactname;

--5
SELECT custid, YEAR(orderdate) orderyear
FROM Sales.Orders
WHERE empid = 5
GROUP BY custid, YEAR(orderdate);

--6
SELECT c.categoryid, c.categoryname 
FROM Production.Categories c
JOIN Production.Products p
ON p.categoryid = c.categoryid
JOIN Sales.OrderDetails od
ON od.productid = p.productid
JOIN Sales.Orders o
ON od.orderid = o.orderid
WHERE YEAR(o.orderdate) = YEAR('2008')
GROUP BY c.categoryid, c.categoryname
ORDER BY c.categoryid;

--7
SELECT o.orderid, o.orderdate, SUM(od.qty * od.unitprice) salesamount
FROM Sales.Orders o
JOIN Sales.OrderDetails od 
ON o.orderid = od.orderid
GROUP BY o.orderid, o.orderdate
ORDER BY salesamount DESC;

--8
SELECT o.orderid, o.orderdate, SUM(od.qty * od.unitprice) salesamount,
COUNT(o.orderid) nooforderlines, AVG(od.qty * od.unitprice) avgsalesamountperorderlines
FROM Sales.Orders o
JOIN Sales.OrderDetails od 
ON o.orderid = od.orderid
GROUP BY o.orderid, o.orderdate
ORDER BY salesamount DESC;

--9
SELECT YEAR(orderdate) * 100 + MONTH(orderdate) as yearmonthno,
SUM(od.qty * od.unitprice) salesamountpermonth
FROM Sales.Orders o
JOIN Sales.OrderDetails od
ON od.orderid = o.orderid
GROUP BY YEAR(orderdate), MONTH(orderdate)
ORDER BY yearmonthno;

--10
SELECT c.custid, c.contactname,
SUM(od.unitprice * od.qty) totalsalesamount,
MAX(od.unitprice * od.qty) maxsalesamountperorderlines,
COUNT(*) numberofrows, COUNT(o.orderid) numberoforderlines
FROM Sales.Customers c
FULL OUTER JOIN Sales.Orders o ON c.custid = o.custid
FULL OUTER JOIN Sales.OrderDetails od ON o.orderid = od.orderid
GROUP BY c.custid, c.contactname
ORDER BY totalsalesamount;

-- 11 & 12
SELECT
YEAR(orderdate) AS orderyear, 
COUNT(orderid) AS nooforders, 
COUNT(DISTINCT custid) AS noofcustomers 
FROM Sales.Orders
GROUP BY YEAR(orderdate);

--13
SELECT SUBSTRING(c.contactname, 1, 1) firstletter,
COUNT(DISTINCT c.custid) nocustomers,
COUNT(o.orderid) nooforders
FROM Sales.Customers c
LEFT OUTER JOIN Sales.Orders o
ON o.custid = c.custid
GROUP BY SUBSTRING(c.contactname, 1, 1)
ORDER BY firstletter;

--14
SELECT c.categoryid, c.categoryname ,
SUM(od.unitprice * od.qty) totalsalesamount,
COUNT(DISTINCT o.orderid) AS nooforders,
SUM(od.unitprice * od.qty)/COUNT(DISTINCT o.orderid) avgsalesamountperorder
FROM Production.Categories c
JOIN Production.Products p
ON p.categoryid = c.categoryid
JOIN Sales.OrderDetails od
ON od.productid = p.productid
JOIN Sales.Orders o
ON od.orderid = o.orderid
WHERE YEAR(o.orderdate) = YEAR('2008')
GROUP BY c.categoryid, c.categoryname
ORDER BY c.categoryid;

--15
SELECT TOP(5) o.custid,
SUM(od.qty * od.unitprice) totalsalesamount
FROM Sales.Orders o
JOIN Sales.OrderDetails od
ON od.orderid = o.orderid
GROUP BY o.custid
HAVING SUM(od.qty*od.unitprice) > 10000
ORDER BY totalsalesamount DESC;

--16
SELECT o.orderid, o.empid,
SUM(od.qty * od.unitprice) totalsalesamount
FROM Sales.Orders o
JOIN Sales.OrderDetails od
ON od.orderid = o.orderid
WHERE YEAR(o.orderdate) = YEAR('2008')
GROUP BY o.orderid, o.empid;

--17
SELECT o.orderid, o.empid,
SUM(od.qty * od.unitprice) totalsalesamount
FROM Sales.Orders o
JOIN Sales.OrderDetails od
ON od.orderid = o.orderid
WHERE YEAR(o.orderdate) = YEAR('2008')
GROUP BY o.orderid, o.empid
HAVING SUM(od.qty * od.unitprice) > 10000;

--18
SELECT o.orderid, o.empid,
SUM(od.qty * od.unitprice) totalsalesamount
FROM Sales.Orders o
JOIN Sales.OrderDetails od
ON od.orderid = o.orderid
WHERE YEAR(o.orderdate) = YEAR('2008') AND empid = 3
GROUP BY o.orderid, o.empid
HAVING SUM(od.qty * od.unitprice) > 10000;

--19
SELECT o.custid,
MAX(orderdate) lastorderdate,
SUM(od.qty*od.unitprice) totalsalesmonth
FROM Sales.Orders o
JOIN Sales.OrderDetails od
ON od.orderid = o.orderid
GROUP BY o.custid
HAVING COUNT(DISTINCT o.orderid) > 25
ORDER BY lastorderdate;

--20
SELECT MAX(orderdate) lastorderdate
FROM Sales.Orders;

--21
SELECT orderid, orderdate, empid, custid
FROM Sales.Orders
WHERE orderdate = (SELECT MAX(orderdate) FROM Sales.Orders)
ORDER BY orderid DESC;

--22
SELECT orderid, orderdate, empid, custid
FROM Sales.Orders
WHERE custid IN (SELECT custid FROM Sales.Customers
WHERE contactname LIKE N'B%');

--25
SELECT o.orderid,
SUM(od.qty * od.unitprice) totalsalesamount
SUM(od.qty * od.unitprice)/
(SELECT SUM(od.qty * od.unitprice)
FROM Sales.Orders o
JOIN Sales.OrderDetails od
ON od.orderid = o.orderid
WHERE YEAR(o.orderdate) = YEAR('2008')*100 salespcoftotal)
FROM Sales.Orders o
JOIN Sales.OrderDetails od
ON od.orderid = o.orderid
WHERE YEAR(o.orderdate) = YEAR('2008')
GROUP BY o.orderid;

--26
SELECT productid, productname
FROM Production.Products
WHERE productid in
(
SELECT productid
FROM Sales.OrderDetails
WHERE qty > 100
)

--27
SELECT custid, contactname
FROM Sales.Customers
WHERE custid not in
(
SELECT custid
FROM Sales.Orders
)

--28
INSERT INTO Sales.Orders (
custid, empid, orderdate, requireddate, shippeddate, shipperid, freight, shipname, shipaddress, shipcity, shipregion, shippostalcode, shipcountry) VALUES
(NULL, 1, '20111231', '20111231', '20111231', 1, 0,
'ShipOne', 'ShipAddress', 'ShipCity', 'RA', '1000', 'USA');

--29
SELECT custid, contactname
FROM Sales.Customers
WHERE custid NOT IN
(
SELECT custid
FROM Sales.Orders
WHERE custid IS NOT NULL
)

--30
SELECT c.custid, c.contactname, (SELECT MAX(o.orderdate)
FROM Sales.Orders o WHERE o.custid = c.custid) lastorderdate
FROM Sales.Customers c;

--31
SELECT c.custid, c.contactname
FROM Sales.Customers c
WHERE NOT EXISTS
(
SELECT o.custid
FROM Sales.Orders o
WHERE c.custid = o.custid
)

--32
SELECT c.custid, c.contactname 
FROM Sales.Customers c
WHERE EXISTS(
	SELECT * FROM Sales.Orders o
	JOIN Sales.OrderDetails od
	ON o.orderid = od.orderid
	WHERE o.custid = c.custid
	AND od.unitprice > 100
	AND o.orderdate >= '20080401'
)


--33
SELECT YEAR(o.orderdate) orderyear, 
SUM(od.qty * od.unitprice) totalsales,
(
	SELECT SUM(od.qty * od.unitprice)
	FROM Sales.Orders o
	JOIN Sales.OrderDetails od
	ON o.orderid = o.orderid
	WHERE YEAR(o.orderdate) <= YEAR(o.orderdate)) runsales
FROM Sales.Orders o 
JOIN Sales.OrderDetails od
ON o.orderid = od.orderid
GROUP BY YEAR(o.orderdate)
ORDER BY orderyear;
--
SELECT
    YEAR(o.orderdate) orderyear,
    SUM(od.qty * od.unitprice) totalsales,
    (SELECT SUM(sod.qty * sod.unitprice)
    FROM Sales.Orders so
    JOIN Sales.OrderDetails sod on
        so.orderid = sod.orderid
    WHERE YEAR(so.orderdate) <= YEAR(o.orderdate)
    ) runsales
FROM Sales.Orders o
JOIN Sales.OrderDetails od on
    o.orderid = od.orderid
GROUP BY YEAR(o.orderdate)
ORDER BY orderyear;

SELECT o.orderid,
SUM(d.qty * d.unitprice) totalsalesamount,
SUM(d.qty * d.unitprice) /
(SELECT SUM(qty * unitprice)
 FROM Sales.OrderDetails
 WHERE orderid IN (SELECT orderid FROM Sales.Orders
    WHERE orderdate BETWEEN '2008-05-01' AND '2008-05-31')) * 100 salespctoftotal
FROM Sales.Orders o
JOIN Sales.OrderDetails d ON o.orderid = d.orderid
WHERE o.orderdate >= '20080501' AND o.orderdate < '20080601'
GROUP BY o.orderid;