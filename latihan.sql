--case
SELECT p.categoryid, p.productname,
CASE
	WHEN p.categoryid = 1 THEN 'Beverages'
	WHEN p.categoryid = 2 THEN 'Condiments'
	WHEN p.categoryid = 3 THEN 'Confections'
	WHEN p.categoryid = 4 THEN 'Dairy Products'
	WHEN p.categoryid = 5 THEN 'Grains/Cereals'
	WHEN p.categoryid = 6 THEN 'Meat/Poultry'
	WHEN p.categoryid = 7 THEN 'Produce'
	WHEN p.categoryid = 8 THEN 'Seafood'
	ELSE 'Other'
END as categoryname,
CASE
	WHEN p.categoryid in(1, 7, 8) THEN 'Campaign Products'
	ELSE 'Non-Campaign Products'
END as status
FROM Production.Products p
WHERE p.categoryid = 8;


--top
SELECT TOP 20 PERCENT
productname, unitprice
FROM Production.Products
ORDER BY unitprice DESC;


--offset-fetch
SELECT productname, unitprice
FROM Production.Products 
ORDER BY unitprice desc
OFFSET 0 ROWS
FETCH NEXT 8 ROWS ONLY;


--view >> order by tidak boleh jika tidak ada top, offset
CREATE VIEW Sales.CustOnly AS
SELECT custid
FROM Sales.Customers;

DROP VIEW Sales.CustOnly;


--cte
WITH 