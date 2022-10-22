select categoryid, count(unitprice) jml_up
from Production.Products
group by categoryid;

select categoryid, sum(unitprice) over() sum_up
from Production.Products;

select categoryid, unitprice, sum(unitprice) over(partition by categoryid) sum_up
from Production.Products;

select cast(25.6 as int)

SELECT LEN('Microsoft SQL SERVER')AS Result;
SELECT DATALENGTH('Microsoft SQL SERVER') AS Result;