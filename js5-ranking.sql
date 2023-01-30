--1
SELECT orderid, orderdate, val,
ROW_NUMBER() OVER(ORDER BY orderdate) rowno
FROM Sales.OrderValues;

--2
SELECT orderid, orderdate, val,
ROW_NUMBER() OVER(ORDER BY orderdate) rowno,
RANK() OVER(ORDER BY orderdate) rankno
FROM Sales.OrderValues;

--4
SELECT orderid, orderdate, custid, val,
RANK() OVER(PARTITION BY custid ORDER BY val DESC) orderrankno
FROM Sales.OrderValues;

--5
SELECT custid, val, YEAR(orderdate) orderyear, 
RANK() OVER(PARTITION BY custid, YEAR(orderdate) ORDER BY val DESC) orderrankno
FROM Sales.OrderValues;

--6
SELECT * FROM
(SELECT custid, val, YEAR(orderdate) orderyear, 
RANK() OVER(PARTITION BY custid, YEAR(orderdate) ORDER BY val DESC) orderrankno
FROM Sales.OrderValues) od
WHERE orderrankno <3;

--7
WITH OrderRows AS (
SELECT orderid, orderdate, val, 
ROW_NUMBER() OVER(ORDER BY orderdate, orderid) rownow
FROM Sales.OrderValues)
SELECT * FROM OrderRows;

--8
WITH OrderRows AS (
SELECT orderid, orderdate, val, 
ROW_NUMBER() OVER(ORDER BY orderdate, orderid) rownow
FROM Sales.OrderValues)
SELECT a.orderid, a.orderdate, a.val, b.val prevval, 
a.val - b.val diffprev
FROM OrderRows a
LEFT JOIN OrderRows b 
ON a.rownow = b.rownow+1;

--9
SELECT orderid, orderid, val,
LAG(val) OVER(ORDER BY orderdate, orderid) prevval,
val - LAG(val) OVER(ORDER BY orderdate, orderid) diffprev
FROM Sales.OrderValues;

--10
WITH SalesMonth2007 AS(
SELECT MONTH(orderdate) monthno, SUM(val) val
FROM Sales.OrderValues
WHERE YEAR(orderdate) = 2007
GROUP BY MONTH(orderdate)) 
SELECT * FROM SalesMonth2007;

--11
WITH SalesMonth2007 AS(
SELECT MONTH(orderdate) monthno, SUM(val) val
FROM Sales.OrderValues
WHERE YEAR(orderdate) = 2007
GROUP BY MONTH(orderdate)) 
SELECT *,
(LAG(val, 1, 1) OVER(ORDER BY monthno) +
LAG(val, 2, 0) OVER(ORDER BY monthno) +
LAG(val, 3, 0) OVER(ORDER BY monthno) / 3) avglast3months,
val-FIRST_VALUE(val) OVER(ORDER BY monthno ROWS UNBOUNDED PRECEDING) diffjanuary,
LEAD(val) OVER(ORDER BY monthno) nextval
FROM SalesMonth2007;

--12
SELECT custid, orderid, orderdate, val,
(val/SUM(val) OVER(PARTITION BY custid)*100) percoftotalcust
FROM Sales.OrderValues
ORDER BY custid, val DESC;

--13
SELECT custid, orderid, orderdate, val,
(val/SUM(val) OVER(PARTITION BY custid)*100) percoftotalcust,
SUM(val) OVER(PARTITION BY custid ORDER BY orderid ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) runval
FROM Sales.OrderValues
ORDER BY custid, orderid;

--14
WITH SalesMonth2007 AS(
SELECT MONTH(orderdate) monthno, SUM(val) val
FROM Sales.OrderValues
WHERE YEAR(orderdate) = 2007
GROUP BY MONTH(orderdate)) 
SELECT *, AVG(val) 
OVER(ORDER BY monthno ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) avglast3months,
SUM(val) OVER(ORDER BY monthno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) ytdval
FROM SalesMonth2007;