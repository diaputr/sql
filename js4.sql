--ex 1a
SELECT productid, productname
FROM Production.Products
WHERE categoryid = 4;

--ex 1b
SELECT p.productid, p.productname
FROM Production.Products p
JOIN Sales.OrderDetails od
ON p.productid = od.productid
GROUP BY p.productid, p.productname
HAVING SUM(od.qty * od.unitprice) > 50000;

--1
SELECT productid, productname
FROM Production.Products
WHERE categoryid = 4
UNION 
SELECT p.productid, p.productname
FROM Production.Products p
JOIN Sales.OrderDetails od
ON p.productid = od.productid
GROUP BY p.productid, p.productname
HAVING SUM(od.qty * od.unitprice) > 50000;

--2
SELECT productid, productname
FROM Production.Products
WHERE categoryid = 4
UNION ALL
SELECT p.productid, p.productname
FROM Production.Products p
JOIN Sales.OrderDetails od
ON p.productid = od.productid
GROUP BY p.productid, p.productname
HAVING SUM(od.qty * od.unitprice) > 50000;

--4
(SELECT TOP 10 
c.custid, c.contactname, o.orderdate, o.val
FROM Sales.Customers c
JOIN Sales.OrderValues o
ON c.custid = o.custid
WHERE MONTH(o.orderdate) = MONTH(1) AND YEAR(o.orderdate) = YEAR('2008')
GROUP BY o.val)
UNION ALL
SELECT TOP 10
c.custid, c.contactname, o.orderdate, o.val
FROM Sales.Customers c
JOIN Sales.OrderValues o
ON c.custid = o.custid
WHERE O.orderdate BETWEEN CONVERT(Datetime,'2008-02-01') AND DATEADD(MONTH, 1,CONVERT(Datetime,'2008-02-01'))
--WHERE MONTH(orderdate) = MONTH(02) AND YEAR(o.orderdate) = YEAR('2008')
ORDER BY o.val DESC;

(
    SELECT DISTINCT TOP 10 C.custid, C.contactname, O.orderdate, OV.val FROM Sales.Orders O
        INNER JOIN Sales.Customers C ON O.custid = C.custid
        INNER JOIN Sales.OrderValues OV ON O.orderid = OV.orderid
    WHERE O.orderdate BETWEEN CONVERT(Datetime,'2008-01-01') AND DATEADD(MONTH, 1,CONVERT(Datetime,'2008-01-01'))
)
UNION
(
    SELECT DISTINCT TOP 10 C.custid, C.contactname, O.orderdate, OV.val FROM Sales.Orders O
        INNER JOIN Sales.Customers C ON O.custid = C.custid
        INNER JOIN Sales.OrderValues OV ON O.orderid = OV.orderid
    WHERE O.orderdate BETWEEN CONVERT(Datetime,'2008-02-01') AND DATEADD(MONTH, 1,CONVERT(Datetime,'2008-02-01'))
) ORDER BY OV.val DESC;

(SELECT DISTINCT TOP 10 c.custid, c.contactname, o.orderdate, ov.val FROM Sales.Orders o
JOIN Sales.Customers c ON o.custid = c.custid
JOIN Sales.OrderValues ov ON o.orderid = ov.orderid
WHERE o.orderdate BETWEEN CONVERT(Datetime,'2008-01-01') AND DATEADD(MONTH, 1, CONVERT(Datetime,'2008-01-01')))
UNION
(SELECT DISTINCT TOP 10 c.custid, c.contactname, o.orderdate, ov.val FROM Sales.Orders o
JOIN Sales.Customers c ON o.custid = c.custid
JOIN Sales.OrderValues ov ON o.orderid = ov.orderid
WHERE o.orderdate BETWEEN CONVERT(Datetime,'2008-02-01') AND DATEADD(MONTH, 1, CONVERT(Datetime,'2008-02-01'))) 
ORDER BY ov.val DESC;


--ex 5a
SELECT p.productid, p.productname, o.orderid
FROM Production.Products p
CROSS APPLY(
	SELECT TOP(2)
	d.orderid
	FROM Sales.OrderDetails d
	WHERE d.productid = p.productid
	ORDER BY d.orderid DESC
) o
ORDER BY p.productid;

--ex 5b
IF OBJECT_ID('dbo.fnGetTop3ProductsForCustomer') IS NOT NULL
DROP FUNCTION dbo.fnGetTop3ProductsForCustomer;
GO
CREATE FUNCTION dbo.fnGetTop3ProductsForCustomer (@custid AS INT)
RETURNS TABLE
AS
RETURN
SELECT TOP(3)
d.productid, p.productname, SUM(d.qty*d.unitprice) totalsalesamount
FROM Sales.Orders o
JOIN Sales.OrderDetails d 
ON d.orderid = o.orderid
JOIN Production.Products p 
ON p.productid = d.productid
WHERE custid = @custid
GROUP BY d.productid, productname
ORDER BY totalsalesamount DESC;

--ex 5c
SELECT c.custid, c.contactname, p.productid, p.productname, p.totalsalesamount
FROM Sales.Customers c
CROSS APPLY
dbo.fnGetTop3ProductsForCustomer(custid) p
ORDER BY c.custid;

--5
SELECT c.custid, c.contactname, p.productid, p.productname, p.totalsalesamount
FROM Sales.Customers c
OUTER APPLY
dbo.fnGetTop3ProductsForCustomer(custid) p
ORDER BY c.custid;

--6
SELECT c.custid, c.contactname, p.productid, p.productname, p.totalsalesamount
FROM Sales.Customers c
OUTER APPLY
dbo.fnGetTop3ProductsForCustomer(custid) p
WHERE p.productid IS NULL
ORDER BY c.custid;

--ex 7
SELECT o.custid
FROM Sales.Orders o
JOIN Sales.OrderDetails d
ON d.orderid = o.orderid
GROUP BY o.custid
HAVING COUNT(DISTINCT d.productid) > 20;

--7
SELECT o.custid 
FROM Sales.Orders o
JOIN Sales.Customers c
ON o.custid = c.custid
WHERE c.country = 'USA'
EXCEPT 
SELECT o.custid
FROM Sales.Orders o
JOIN Sales.OrderDetails d
ON d.orderid = o.orderid
GROUP BY o.custid
HAVING COUNT(DISTINCT d.productid) > 20

--ex 8
SELECT o.custid
FROM Sales.Orders o
JOIN Sales.OrderDetails d
ON d.orderid = o.orderid
GROUP BY o.custid
HAVING SUM(d.qty*d.unitprice) > 10000;

--8
SELECT o.custid
FROM Sales.Orders AS o
EXCEPT
SELECT o.custid
FROM Sales.Orders o
JOIN Sales.OrderDetails d
ON d.orderid = o.orderid
GROUP BY o.custid
HAVING COUNT(DISTINCT d.productid) > 20
INTERSECT
SELECT o.custid
FROM Sales.Orders o
JOIN Sales.OrderDetails d
ON d.orderid = o.orderid
GROUP BY o.custid
HAVING SUM(d.qty*d.unitprice) > 10000;

--10
(SELECT o.custid
FROM Sales.Orders o
JOIN Sales.OrderDetails d
ON d.orderid = o.orderid
GROUP BY o.custid
HAVING COUNT(DISTINCT d.productid) > 20)
INTERSECT
SELECT o.custid
FROM Sales.Orders o
JOIN Sales.OrderDetails d
ON d.orderid = o.orderid
GROUP BY o.custid
HAVING SUM(d.qty*d.unitprice) > 10000;

--trigger
IF OBJECT_ID('Sales.trgAutoAddOrderDetailsForOrder') IS NOT NULL
DROP TRIGGER Sales.trgAutoAddOrderDetailsForOrder;
GO;
CREATE TRIGGER trgAutoAddOrderDetailsForOrder ON Sales.Orders
AFTER INSERT
AS
PRINT 'TRIGGER trgAutoAddOrderDetailsForOrder dipanggil!';
DECLARE @orderid INT = (SELECT orderid FROM inserted);
DECLARE @productid INT = 1;
DECLARE @unitprice MONEY = 0;
DECLARE @qty SMALLINT = 1;
DECLARE @discount NUMERIC(4,3) = 0;

INSERT INTO Sales.OrderDetails VALUES
(@orderid, @productid, @unitprice, @qty, @discount);
PRINT 'Data kosong ditambah secara otomatis ke tabel Sales.OrderDetails';
GO;

INSERT INTO Sales.Orders(custid, empid, orderdate, requireddate, shipperid, freight, shipname, shipaddress, shipcity, shipcountry)
VALUES (85, 5, GETDATE(), GETDATE(), 3, 100, 'Kapal Api', 'Jl. Soehat', 'Malang', 'Indonesia');

SELECT * FROM Sales.Orders WHERE shipcity = 'Malang';
--DELETE FROM Sales.Orders WHERE shipcity = 'Malang';
SELECT orderid, productid, unitprice, qty, discount FROM Sales.OrderDetails ORDER BY orderid DESC;

--trigger2
IF OBJECT_ID('Production.trgAutoUpdateOrderDetailsUnitPrice') IS NOT NULL
DROP TRIGGER Production.trgAutoUpdateOrderDetailsUnitPrice;
GO;
CREATE TRIGGER trgAutoUpdateOrderDetailsUnitPrice ON Production.Products
AFTER UPDATE
AS
PRINT 'TRIGGER Production.trgAutoUpdateOrderDetailsUnitPrice dipanggil!';
DECLARE @productid INT = (SELECT productid FROM inserted);
DECLARE @unitprice MONEY = 
COALESCE((SELECT unitprice FROM inserted), 0.0);
UPDATE Sales.OrderDetails SET unitprice = @unitprice
WHERE productid = @productid;
PRINT 'Harga di tabel Sales.OrderDetails secara otomatis disesuaikan..'
GO;

UPDATE Production.Products SET unitprice = 100 WHERE productid = 11;
SELECT * FROM Production.Products WHERE productid = 11;
SELECT * FROM Sales.OrderDetails WHERE productid = 11;

--12
IF OBJECT_ID('Sales.trgAutoDeleteOrderDetailsForOrder') IS NOT NULL
    DROP TRIGGER Sales.trgAutoDeleteOrderDetailsForOrder;
GO;

CREATE TRIGGER trgAutoDeleteOrderDetailsForOrder ON Sales.OrderDetails
    AFTER DELETE
AS
    PRINT 'Trigger trgAutoDeleteOrderDetailsForOrder dipanggil!';
    Declare @productid INT = (SELECT TOP 1 productid FROM deleted);

    UPDATE Production.Products SET discontinued = 1
    WHERE productid = @productid;

    PRINT 'Men-discontinue product dengan id: ' + CAST(@productid AS VARCHAR);
GO;

DELETE FROM Sales.OrderDetails WHERE productid = 10;
SELECT * FROM Production.Products WHERE productid = 10;

--trigger3
INSERT INTO HR.EmployeesBackup(
lastname, firstname, title, titleofcourtesy, birthdate, hiredate, [address], city, region, postalcode, country, phone, mgrid)
SELECT
lastname, firstname, title, titleofcourtesy, birthdate, hiredate, [address], city, region, postalcode, country, phone, mgrid
FROM HR.Employees;

SELECT * FROM HR.EmployeesBackup;
SELECT * FROM HR.Employees;

IF OBJECT_ID('HR.trgDivertInsertEmployeeToBackup') IS NOT NULL
    DROP TRIGGER HR.trgDivertInsertEmployeeToBackup;
GO;

CREATE TRIGGER HR.trgDivertInsertEmployeeToBackup ON HR.Employees
    INSTEAD OF INSERT
AS
    PRINT 'Trigger trgDivertInsertEmployeeToBackup dipanggil!';

	INSERT INTO HR.EmployeesBackup(
	lastname, firstname, title, titleofcourtesy, birthdate, hiredate, [address], city, region, postalcode, country, phone, mgrid)
	SELECT
	lastname, firstname, title, titleofcourtesy, birthdate, hiredate, [address], city, region, postalcode, country, phone, mgrid
	FROM inserted;

    PRINT 'Employee baru disimpan di tabel HR.EmployeesBackup..';
GO;

DISABLE TRIGGER HR.trgDivertInsertEmployeeToBackup ON HR.Employees;

INSERT INTO HR.Employees VALUES
('Santoso', 'Adi', 'Staff', 'Mr.', '19830101', '20170101', 'Jl. Soehat', 'Malang', 'Jawa Timur', '65150', 'Indonesia', '(085) 123-456', 1);

ENABLE TRIGGER HR.trgDivertInsertEmployeeToBackup ON HR.Employees;

--13
IF OBJECT_ID('HR.trgDivertUpdateEmployeeToBackup') IS NOT NULL
    DROP TRIGGER HR.trgDivertUpdateEmployeeToBackup;
GO;

CREATE TRIGGER HR.trgDivertUpdateEmployeeToBackup ON HR.Employees
    INSTEAD OF UPDATE
AS
    PRINT 'Trigger trgDivertUpdateEmployeeToBackup dipanggil!';
	DECLARE @empid INT = (SELECT empid FROM inserted);
	UPDATE HR.EmployeesBackup SET lastname = (SELECT lastname FROM 
	inserted), firstname = (SELECT firstname FROM inserted)
	WHERE empid = @empid;
	PRINT 'Karyawan dengan empid: '+CAST(@empid AS VARCHAR)+' yang ada di HR.EmployeesBackup yang diupdate.';

UPDATE HR.Employees SET firstname = 'DEPAN', lastname = 'BELAKANG' WHERE firstname = 'Adi';
SELECT * FROM HR.EmployeesBackup WHERE firstname = 'depan';


--14
IF OBJECT_ID('HR.trgDivertDeleteEmployeeToBackup') IS NOT NULL
	DROP TRIGGER HR.trgDivertDeleteEmployeeToBackup
GO;

CREATE TRIGGER HR.trgDivertDeleteEmployeeToBackup ON HR.Employees
INSTEAD OF DELETE
AS
    PRINT 'Trigger trgDivertDeleteEmployeeToBackup dipanggil!';
	DECLARE @empid INT = (SELECT TOP 1 empid FROM deleted);
	DELETE FROM HR.EmployeesBackup WHERE empid = @empid;
	PRINT 'Karyawan dengan nama: '+f+' yang ada di HR.EmployeesBackup yang diupdate.';

DELETE FROM HR.Employees WHERE firstname = 'Maria'
SELECT * FROM HR.EmployeesBackup;





--13
IF OBJECT_ID('HR.trgDivertUpdateEmployeeToBackup') IS NOT NULL
DROP TRIGGER HR.trgDivertUpdateEmployeeToBackup
GO

CREATE TRIGGER trgDivertUpdateEmployeeToBackup ON HR.Employees
INSTEAD OF UPDATE
AS
PRINT 'TRIGGER trgDivertUpdateEmployeeToBackup DIPANGGIL!';
DECLARE @empid INT = (SELECT empid FROM inserted);
UPDATE HR.EmployeesBackup SET lastname = (SELECT lastname FROM
inserted), firstname = (SELECT firstname FROM inserted)
WHERE empid = @empid;
PRINT 'Karyawan dengan ID: '+CAST(@empid AS VARCHAR)+' yang ada di 
HR.EmployeesBackup yang di update.';
GO

UPDATE HR.Employees SET firstname = 'DEPAN', lastname = 'BELAKANG' WHERE
firstname = 'Adi';

SELECT * FROM HR.EmployeesBackup WHERE empid = 10;


--13
IF OBJECT_ID('HR.trgDrivertUpdateEmployeeToBackup') IS NOT NULL
DROP TABLE HR. trgDrivertUpdateEmployeeToBackup
GO

CREATE TRIGGER trgDivertUpdateEmployeeToBackup ON HR.Employees
INSTEAD OF UPDATE
AS
PRINT 'TRIGGER trgDrivertUpdateEmployeeToBackup DIPANGGIL!'; 
DECLARE @firstname VARCHAR(15) = (SELECT firstname FROM inserted);
DECLARE @lastname VARCHAR(15) = (SELECT lastname FROM inserted);
DECLARE @title VARCHAR(5)= (SELECT title FROM inserted); 
DECLARE @titleofcourtesy VARCHAR(5)= (SELECT titleofcourtesy FROM inserted);
DECLARE @birthdate DATETIME = (SELECT birthdate FROM inserted); 
DECLARE @hiredate DATETIME = (SELECT hiredate FROM inserted); 
DECLARE @address VARCHAR(100) (SELECT [address] FROM inserted);
DECLARE @city VARCHAR(15) = (SELECT city FROM inserted); 
DECLARE @region VARCHAR(7) = (SELECT region FROM inserted);
DECLARE @postalcode VARCHAR(6) = (SELECT postalcode FROM inserted);
DECLARE @country VARCHAR(10) = (SELECT country FROM inserted);
DECLARE @phone VARCHAR(15) = (SELECT phone FROM inserted); 
DECLARE @mgrid VARCHAR(15) = (SELECT mgrid FROM inserted);
DECLARE @empid INT = (SELECT empid FROM inserted);

UPDATE HR.EmployeesBackup SET firstname=@firstname, lastname=@lastname, title=@title, titleofcourtesy=@titleofcourtesy, 
birthdate=@birthdate, hiredate=@hiredate, [address]=@address, city=@city, region=@region, postalcode=@postalcode,
country=@country, phone=@phone, mgrid=@mgrid WHERE empid=@empid;

PRINT 'Karyawan dengan empid: ' + CAST(@empid AS VARCHAR) + ' yang ada di HR. EmployeesBackup yang diupdate.';

UPDATE HR. Employees SET firstname='DEPAN', lastname='BELAKANG'
WHERE firstname LIKE '%Adi'; 
SELECT * FROM HR. Employees;


--13
IF OBJECT_ID('HR.trgDrivertUpdateEmployeeToBackup') IS NOT NULL
DROP TABLE HR. trgDrivertUpdateEmployeeToBackup
GO

CREATE TRIGGER trgDivertUpdateEmployeeToBackup ON HR.Employees
INSTEAD OF UPDATE
AS
PRINT 'TRIGGER trgDrivertUpdateEmployeeToBackup DIPANGGIL!'; 
DECLARE @impId INT = (SELECT TOP 1 empid FROM inserted);

UPDATE HR.EmployeesBackup
SET lastname = i.lastname,
	firstname = i.firstname
FROM HR.EmployeesBackup as c
	INNER JOIN inserted as i ON i.firstname = c.firstname
WHERE c.firstname = i.firstname;

PRINT 'Karyawan dengan empid: ' + CAST(@impId AS VARCHAR) + 


--13
IF OBJECT_ID('HR.trgDivertUpdateEmployeeToBackup') IS NOT NULL
DROP TRIGGER HR.trgDivertUpdateEmployeeToBackup
GO

CREATE TRIGGER trgDivertUpdateEmployeeToBackup On HR.Employees
INSTEAD OF UPDATE 
AS 
PRINT 'trigger trgDivertUpdateEmployeeToBackup DIPANGGIL';
INSERT INTO HR.EmployeesBackup(
lastname,firstname,title,titleofcourtesy,birthdate,hiredate,
[address],city,region,postalcode,country,phone,mgrid)
SELECT
lastname,firstname,title,titleofcourtesy,birthdate,hiredate,
[address],city,region,postalcode,country,phone,mgrid
FROM inserted;
PRINT'karyawan dengan empid yang di HR.EmployeesBackup yang di update';



-- No 14
IF OBJECT_ID('HR.trgDivertDeleteEmployeeBackup') IS NOT NULL
    DROP TRIGGER HR.trgDivertDeleteEmployeeBackup;
GO

CREATE TRIGGER trgDivertDeleteEmployeeBackup ON HR.Employees
    INSTEAD OF DELETE
    AS
    PRINT 'Trigger trgDivertDeleteEmployeeBackup DIPANGGIL!';
    DECLARE @impId INT = (SELECT TOP 1 empid FROM deleted);
    DECLARE @first Varchar(100) = (SELECT TOP 1 firstname FROM deleted);
    DECLARE @last Varchar(100) = (SELECT TOP 1 lastname FROM deleted);

    DELETE FROM HR.EmployeesBackup
    WHERE empid = @impId;

    PRINT 'Karyawan dengan nama: ' + CONCAT(@first, ' ', @last) + ' dihapus di HR.EmployeesBackup saja. ' +
          'Di tabel aslinya tetep.';
GO

DELETE FROM HR.Employees
WHERE firstname = 'Maria';
SELECT * FROM HR.EmployeesBackup;

INSERT INTO HR.EmployeesBackup(lastname, firstname, title, titleofcourtesy, birthdate, hiredate, address, city, region, postalcode, country, phone, mgrid)
  VALUES(N'Cameron', N'Maria', N'Sales Representative', N'Ms.', '19680109 00:00:00.000', '20040305 00:00:00.000', N'4567 - 11th Ave. N.E.', N'Seattle', N'WA', N'10006', N'USA', N'(206) 555-0102', 3);