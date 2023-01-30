USE TSQL;

--1
select CURRENT_TIMESTAMP as currentdatetime,
convert(date, CURRENT_TIMESTAMP) as currentdate, 
convert(time, CURRENT_TIMESTAMP) as currenttime,
year(CURRENT_TIMESTAMP) as currentyear,
month(CURRENT_TIMESTAMP) as currentmonth,
day(CURRENT_TIMESTAMP) as currentday,
datepart(week, CURRENT_TIMESTAMP) as currentweeknumber,
DATENAME(month, CURRENT_TIMESTAMP) as currentmonthname;

--3
select convert(date, CURRENT_TIMESTAMP) as todaysdate;
select convert(varchar, GETDATE(), 107) as todaysdate;
select convert(varchar, GETDATE(), 106) as todaysdate;

select cast(current_timestamp as date) as todaysdate1,
CONVERT(varchar, CURRENT_TIMESTAMP, 107) as todaysdate2,
FORMAT(CURRENT_TIMESTAMP, 'dd MMM yyyy') as todaysdate3;

--4
select DATEADD(month, 5, GETDATE()) as fivemonths;
select DATEDIFF(day, CURRENT_TIMESTAMP, DATEADD(month, 5, GETDATE())) as diffdays;
select DATEDIFF(week, '1945/08/17', '2022/08/17') as diffweeks;
select DATEADD(month, DATEDIFF(MONTH, 0, GETDATE()), 0) as firstday;
--select EOMONTH(GETDATE()) as lastday;

--5
/*CREATE TABLE Sales.Somedates (
isitdate varchar(9)
);*/

INSERT INTO Sales.Somedates (isitdate) VALUES 
('20110101'),
('20110102'),
('20110103X'),
('20110104'),
('20110105'),
('20110106'),
('20110107Y'),
('20110108'); 

select *, try_convert(date, isitdate) as convertdate from Sales.Somedates;

--6
SELECT SYSDATETIME() AS sysdt, CURRENT_TIMESTAMP as currentts;

--8
SELECT custid, shipname, shippeddate FROM Sales.Orders 
where shippeddate between '2008-03-01' and EOMONTH('2008-03-01')
order by custid;

--9
SELECT GETDATE() as today, 
DATEADD(month, DATEDIFF(MONTH, 0, GETDATE()), 0) as firstofmonth,
CAST(EOMONTH (CURRENT_TIMESTAMP) AS DATETIME) as endofmonth;

--10
SELECT orderid, custid, orderdate, shipaddress 
FROM Sales.Orders 
where DATEDIFF(DAY, orderdate, EOMONTH(orderdate)) < 5;

--11
SELECT CONCAT(contactname, ' (city: ', city,')') as contactdetails
FROM Sales.Customers;

--12
SELECT contactname, contacttitle 
FROM Sales.Customers 
where contactname like N'[a-g]%' 
order by contactname;

--13
SELECT replace(contactname, ',', '') as contactname, 
SUBSTRING(contactname, 1, charindex(',', contactname)-1) as lastname
FROM Sales.Customers;

--14
SELECT custid,
IIF(custid < 10, CONCAT('C000',custid), CONCAT('C00',custid)) as newcustid
FROM Sales.Customers
ORDER BY newcustid;

--15
SELECT contactname, len(contactname) - len(replace (contactname, 'a', '')) as numberofa
FROM Sales.Customers;

--17
CREATE VIEW Production.ProductsBeverages AS
--16
SELECT productid, productname, supplierid, unitprice, discontinued
FROM Production.Products
WHERE categoryid = 1;

--18
SELECT productid, productname
FROM Production.ProductsBeverages
WHERE supplierid = 1;

--19
USE TSQL
GO
ALTER VIEW Production.ProductsBeverages AS
SELECT
productid, productname, supplierid, unitprice, discontinued
FROM Production.Products
WHERE categoryid = 1 
ORDER BY productname;

--20
USE TSQL
GO
ALTER VIEW Production.ProductsBeverages AS
SELECT TOP(100) PERCENT
 productid, productname, supplierid, unitprice, discontinued 
FROM Production.Products 
WHERE categoryid = 1 
ORDER BY productname;

select * from Production.ProductsBeverages;

ALTER VIEW Production.ProductsBeverages AS
SELECT TOP(100)
 productid, productname, supplierid, unitprice, discontinued
FROM Production.Products
WHERE categoryid = 1
ORDER BY productname;

SELECT * FROM Production.ProductsBeverages

--21
USE TSQL
GO
ALTER VIEW Production.ProductsBeverages AS 
SELECT
productid, productname, supplierid, unitprice, discontinued,
CASE WHEN unitprice > 100. THEN N'high' ELSE N'normal' END AS pricetype
FROM Production.Products
WHERE categoryid = 1; 

select*from Production.ProductsBeverages;

IF OBJECT_ID(N'Production.ProductsBeverages', N'V') IS NOT NULL 
DROP VIEW Production.ProductsBeverages; 

--23
SELECT productid, productname
FROM (
	SELECT productid, productname, supplierid, unitprice, discontinued,
	CASE WHEN unitprice > 100. THEN N'high' ELSE N'normal' END AS pricetype
	FROM Production.Products
	WHERE categoryid = 1
) AS p
WHERE pricetype='high';

--24
WITH ProductBeverages AS(
SELECT productid, productname, supplierid, unitprice, discontinued,
	CASE WHEN unitprice > 100. THEN N'high' ELSE N'normal' END AS pricetype
	FROM Production.Products
	WHERE categoryid = 1
) SELECT productid, productname
FROM ProductBeverages
WHERE pricetype= 'high';

--25
ALTER FUNCTION dbo.fnGetSalesByCustomer
(@orderyear AS INT) RETURNS TABLE
AS
RETURN 
SELECT custid, 
SUM(val) AS totalsalesamount 
FROM Sales.OrderValues 
WHERE YEAR(orderdate) = 2007
GROUP BY custid;

--27
SELECT custid, totalsalesamount
FROM dbo.fnGetSalesByCustomer(2007);

--28
CREATE FUNCTION dbo.fnGetTop3ProductsForCustomer 
(@custid AS INT) RETURNS TABLE
AS
RETURN 
SELECT TOP(3) 
p.productname, c.categoryname, 
SUM(d.qty * d.unitprice) AS totalamount 
FROM Sales.Orders AS o 
INNER JOIN Sales.OrderDetails AS d ON d.orderid = o.orderid 
INNER JOIN Production.Products AS p ON p.productid = d.productid 
INNER JOIN Production.Categories AS c ON p.categoryid = c.categoryid 
WHERE custid = 33
GROUP BY p.productname, c.categoryname 
ORDER BY totalamount DESC

select*from dbo.fnGetTop3ProductsForCustomer(1);

SELECT pro.productid, p.productname, p.totalamount as totalsalesamount
FROM dbo.fnGetTop3ProductsForCustomer(1) as p
join Production.Products as pro on p.productname = pro.productname;