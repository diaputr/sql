--contoh
CREATE VIEW Sales.CategoryQtyYear AS (
SELECT c.categoryname, SUM(od.qty) QTY, YEAR(o.orderdate) Orderyear
FROM Sales.OrderDetails od
JOIN Sales.Orders o
ON o.orderid = od.orderid
JOIN Production.Products p
ON p.productid = od.productid
JOIN Production.Categories c
ON c.categoryid = p.categoryid
GROUP BY c.categoryname, YEAR(o.orderdate));

SELECT * FROM Sales.CategoryQtyYear;

--pivot
SELECT categoryname, [2006], [2007], [2008]
FROM (
SELECT categoryname, Qty, Orderyear FROM Sales.CategoryQtyYear
) D
PIVOT (
SUM(qty)
FOR Orderyear IN([2006], [2007], [2008])) pvt;

--ex
SELECT c.categoryname, COUNT(p.productid) product_count
FROM Production.Products p
JOIN Production.Categories c
ON c.categoryid = p.categoryid
GROUP BY categoryname;

SELECT [Beverages], [Condiments]
FROM (
SELECT categoryname, productid
FROM Production.Products p
JOIN Production.Categories c
ON c.categoryid = p.categoryid
GROUP BY categoryname, productid) P

PIVOT(
COUNT(productid) FOR categoryname IN([Beverages], [Condiments])) pvt;

--1
ALTER VIEW Sales.CustGroups AS (
SELECT custid,
CHOOSE(custid % 3 + 1, N'A', N'B', N'C') custgroup, country
FROM Sales.Customers);

SELECT * FROM Sales.CustGroups;

--2
SELECT country, [A], [B], [C] FROM Sales.CustGroups
PIVOT( 
COUNT(custid) FOR custgroup IN([A], [B], [C])) pvt;

--3
ALTER VIEW Sales.CustGroups AS (
SELECT custid,
CHOOSE(custid % 3 + 1, N'A', N'B', N'C') custgroup, 
country, city, contactname
FROM Sales.Customers);

SELECT * FROM Sales.CustGroups;

--
SELECT country, [A], [B], [C] FROM Sales.CustGroups
PIVOT( 
COUNT(custid) FOR custgroup IN([A], [B], [C])) pvt;

--4
SELECT * FROM Sales.CustGroups
PIVOT( 
COUNT(custid) FOR custgroup IN([A], [B], [C])) pvt;

--5
WITH PivotCustGroups AS(
SELECT custid, country, custgroup FROM Sales.CustGroups)
SELECT * FROM PivotCustGroups
PIVOT( 
COUNT(custid) FOR custgroup IN([A], [B], [C])) pvt;

--8
WITH SalesByCategory AS(
SELECT custid, (od.qty * od.unitprice) salesvalue, 
categoryname FROM Sales.Orders o
JOIN Sales.OrderDetails od
ON od.orderid = o.orderid
JOIN Production.Products p
ON od.productid = p.productid
JOIN Production.Categories c
ON p.categoryid = c.categoryid
WHERE YEAR(orderdate) = 2008)

SELECT * FROM SalesByCategory 
PIVOT( 
SUM(salesvalue) FOR categoryname IN([Beverages], [Condiments], [Confections], 
[Dairy Products], [Grain/Cereals], [Meat/Poultry], 
[Produce], [Seafood])) pvt;

--
CREATE VIEW Sales.PivotCustGroups AS 
WITH PivotCustGroups AS (
SELECT custid, country, custgroup
FROM Sales.CustGroups
) SELECT country, p.A, p.B, p.C
FROM PivotCustGroups
PIVOT(
COUNT(custid) FOR custgroup IN (A, B, C)) p;

--9
SELECT * FROM Sales.PivotCustGroups;

--10
SELECT custgroup, country, numberofcustomers
FROM Sales.PivotCustGroups
UNPIVOT(
numberofcustomers FOR custgroup IN([A], [B], [C])) unpvt;

--11
SELECT country, city, COUNT(custid) noofcustomers
FROM Sales.Customers
GROUP BY 
GROUPING SETS((country, city), country, city,());

--12
SELECT YEAR(orderdate) orderyear, 
MONTH(orderdate) ordermonth,
DAY(orderdate) orderday, SUM(val) salesvalue
FROM Sales.OrderValues
GROUP BY CUBE(YEAR(orderdate), MONTH(orderdate),
DAY(orderdate));

--13
SELECT YEAR(orderdate) orderyear, 
MONTH(orderdate) ordermonth,
DAY(orderdate) orderday, SUM(val) salesvalue
FROM Sales.OrderValues
GROUP BY ROLLUP(YEAR(orderdate), MONTH(orderdate),
DAY(orderdate));

--15
SELECT GROUPING_ID(YEAR(orderdate), MONTH(orderdate)) groupid,
YEAR(orderdate) orderyear, MONTH(orderdate) ordermonth, 
SUM(val) salesvalue
FROM Sales.OrderValues
GROUP BY GROUPING SETS((YEAR(orderdate), MONTH(orderdate)), YEAR(orderdate), ())
ORDER BY groupid, orderyear, ordermonth;