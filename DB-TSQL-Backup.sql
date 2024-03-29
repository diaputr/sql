USE [master]
GO
/****** Object:  Database [TSQL]    Script Date: 10/8/2022 8:40:41 PM ******/
CREATE DATABASE [TSQL]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TSQL', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\TSQL.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'TSQL_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\TSQL_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [TSQL].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [TSQL] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [TSQL] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [TSQL] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [TSQL] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [TSQL] SET ARITHABORT OFF 
GO
ALTER DATABASE [TSQL] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [TSQL] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [TSQL] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [TSQL] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [TSQL] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [TSQL] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [TSQL] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [TSQL] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [TSQL] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [TSQL] SET  ENABLE_BROKER 
GO
ALTER DATABASE [TSQL] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [TSQL] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [TSQL] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [TSQL] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [TSQL] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [TSQL] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [TSQL] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [TSQL] SET RECOVERY FULL 
GO
ALTER DATABASE [TSQL] SET  MULTI_USER 
GO
ALTER DATABASE [TSQL] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [TSQL] SET DB_CHAINING OFF 
GO
ALTER DATABASE [TSQL] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [TSQL] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [TSQL] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'TSQL', N'ON'
GO
ALTER DATABASE [TSQL] SET QUERY_STORE = OFF
GO
USE [TSQL]
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [TSQL]
GO
/****** Object:  Schema [HR]    Script Date: 10/8/2022 8:40:42 PM ******/
CREATE SCHEMA [HR]
GO
/****** Object:  Schema [Production]    Script Date: 10/8/2022 8:40:42 PM ******/
CREATE SCHEMA [Production]
GO
/****** Object:  Schema [Sales]    Script Date: 10/8/2022 8:40:42 PM ******/
CREATE SCHEMA [Sales]
GO
/****** Object:  Schema [Stats]    Script Date: 10/8/2022 8:40:42 PM ******/
CREATE SCHEMA [Stats]
GO
/****** Object:  Table [Production].[Products]    Script Date: 10/8/2022 8:40:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Production].[Products](
	[productid] [int] IDENTITY(1,1) NOT NULL,
	[productname] [nvarchar](40) NOT NULL,
	[supplierid] [int] NOT NULL,
	[categoryid] [int] NOT NULL,
	[unitprice] [money] NOT NULL,
	[discontinued] [bit] NOT NULL,
 CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
(
	[productid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  View [Production].[ProductsBeverages]    Script Date: 10/8/2022 8:40:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Production].[ProductsBeverages] AS
SELECT TOP(100) PERCENT
 productid, productname, supplierid, unitprice, discontinued 
FROM Production.Products 
WHERE categoryid = 1 
ORDER BY productname;
GO
/****** Object:  Table [Sales].[Orders]    Script Date: 10/8/2022 8:40:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Sales].[Orders](
	[orderid] [int] IDENTITY(1,1) NOT NULL,
	[custid] [int] NULL,
	[empid] [int] NOT NULL,
	[orderdate] [datetime] NOT NULL,
	[requireddate] [datetime] NOT NULL,
	[shippeddate] [datetime] NULL,
	[shipperid] [int] NOT NULL,
	[freight] [money] NOT NULL,
	[shipname] [nvarchar](40) NOT NULL,
	[shipaddress] [nvarchar](60) NOT NULL,
	[shipcity] [nvarchar](15) NOT NULL,
	[shipregion] [nvarchar](15) NULL,
	[shippostalcode] [nvarchar](10) NULL,
	[shipcountry] [nvarchar](15) NOT NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[orderid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Sales].[OrderDetails]    Script Date: 10/8/2022 8:40:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Sales].[OrderDetails](
	[orderid] [int] NOT NULL,
	[productid] [int] NOT NULL,
	[unitprice] [money] NOT NULL,
	[qty] [smallint] NOT NULL,
	[discount] [numeric](4, 3) NOT NULL,
 CONSTRAINT [PK_OrderDetails] PRIMARY KEY CLUSTERED 
(
	[orderid] ASC,
	[productid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  View [Sales].[OrderValues]    Script Date: 10/8/2022 8:40:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------
-- Create Views and Functions
---------------------------------------------------------------------

CREATE VIEW [Sales].[OrderValues]
  WITH SCHEMABINDING
AS

SELECT O.orderid, O.custid, O.empid, O.shipperid, O.orderdate, O.requireddate, O.shippeddate,
  SUM(OD.qty) AS qty,
  CAST(SUM(OD.qty * OD.unitprice * (1 - OD.discount))
       AS NUMERIC(12, 2)) AS val
FROM Sales.Orders AS O
  JOIN Sales.OrderDetails AS OD
    ON O.orderid = OD.orderid
GROUP BY O.orderid, O.custid, O.empid, O.shipperid, O.orderdate, O.requireddate, O.shippeddate;

GO
/****** Object:  UserDefinedFunction [dbo].[fnGetSalesByCustomer]    Script Date: 10/8/2022 8:40:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fnGetSalesByCustomer]
(@orderyear AS INT) RETURNS TABLE
AS
RETURN 
SELECT custid, 
SUM(val) AS totalsalesamount 
FROM Sales.OrderValues 
WHERE YEAR(orderdate) = @orderyear
GROUP BY custid;
GO
/****** Object:  Table [Production].[Categories]    Script Date: 10/8/2022 8:40:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Production].[Categories](
	[categoryid] [int] IDENTITY(1,1) NOT NULL,
	[categoryname] [nvarchar](15) NOT NULL,
	[description] [nvarchar](200) NOT NULL,
 CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
(
	[categoryid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  UserDefinedFunction [dbo].[fnGetTop3ProductsForCustomer]    Script Date: 10/8/2022 8:40:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnGetTop3ProductsForCustomer] 
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
GO
/****** Object:  View [Sales].[OrderTotalsByYear]    Script Date: 10/8/2022 8:40:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [Sales].[OrderTotalsByYear]
  WITH SCHEMABINDING
AS

SELECT
  YEAR(O.orderdate) AS orderyear,
  SUM(OD.qty) AS qty
FROM Sales.Orders AS O
  JOIN Sales.OrderDetails AS OD
    ON OD.orderid = O.orderid
GROUP BY YEAR(orderdate);

GO
/****** Object:  View [Sales].[CustOrders]    Script Date: 10/8/2022 8:40:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [Sales].[CustOrders]
  WITH SCHEMABINDING
AS

SELECT
  O.custid, 
  DATEADD(month, DATEDIFF(month, 0, O.orderdate), 0) AS ordermonth,
  SUM(OD.qty) AS qty
FROM Sales.Orders AS O
  JOIN Sales.OrderDetails AS OD
    ON OD.orderid = O.orderid
GROUP BY custid, DATEADD(month, DATEDIFF(month, 0, O.orderdate), 0);

GO
/****** Object:  View [Sales].[EmpOrders]    Script Date: 10/8/2022 8:40:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [Sales].[EmpOrders]  
  WITH SCHEMABINDING  
AS  
  
SELECT  
  O.empid,
  DATEADD(month, DATEDIFF(month, 0, O.orderdate), 0) AS ordermonth,  
  SUM(OD.qty) AS qty,
  CAST(SUM(OD.qty * OD.unitprice * (1 - discount))  
       AS NUMERIC(12, 2)) AS val,
  COUNT(*) AS numorders  
FROM Sales.Orders AS O  
  JOIN Sales.OrderDetails AS OD  
    ON OD.orderid = O.orderid  
GROUP BY empid, DATEADD(month, DATEDIFF(month, 0, O.orderdate), 0);  

GO
/****** Object:  UserDefinedFunction [dbo].[GetNums]    Script Date: 10/8/2022 8:40:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[GetNums](@low AS BIGINT, @high AS BIGINT) RETURNS TABLE
AS
RETURN
  WITH
    L0   AS (SELECT c FROM (SELECT 1 UNION ALL SELECT 1) AS D(c)),
    L1   AS (SELECT 1 AS c FROM L0 AS A CROSS JOIN L0 AS B),
    L2   AS (SELECT 1 AS c FROM L1 AS A CROSS JOIN L1 AS B),
    L3   AS (SELECT 1 AS c FROM L2 AS A CROSS JOIN L2 AS B),
    L4   AS (SELECT 1 AS c FROM L3 AS A CROSS JOIN L3 AS B),
    L5   AS (SELECT 1 AS c FROM L4 AS A CROSS JOIN L4 AS B),
    Nums AS (SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS rownum
            FROM L5)
  SELECT TOP(@high - @low + 1) @low + rownum - 1 AS n
  FROM Nums
  ORDER BY rownum;

GO
/****** Object:  Table [dbo].[Nums]    Script Date: 10/8/2022 8:40:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Nums](
	[n] [int] NOT NULL,
 CONSTRAINT [PK_Nums] PRIMARY KEY CLUSTERED 
(
	[n] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [HR].[Employees]    Script Date: 10/8/2022 8:40:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[Employees](
	[empid] [int] IDENTITY(1,1) NOT NULL,
	[lastname] [nvarchar](20) NOT NULL,
	[firstname] [nvarchar](10) NOT NULL,
	[title] [nvarchar](30) NOT NULL,
	[titleofcourtesy] [nvarchar](25) NOT NULL,
	[birthdate] [datetime] NOT NULL,
	[hiredate] [datetime] NOT NULL,
	[address] [nvarchar](60) NOT NULL,
	[city] [nvarchar](15) NOT NULL,
	[region] [nvarchar](15) NULL,
	[postalcode] [nvarchar](10) NULL,
	[country] [nvarchar](15) NOT NULL,
	[phone] [nvarchar](24) NOT NULL,
	[mgrid] [int] NULL,
 CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED 
(
	[empid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [HR].[EmployeesBackup]    Script Date: 10/8/2022 8:40:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[EmployeesBackup](
	[empid] [int] IDENTITY(1,1) NOT NULL,
	[lastname] [nvarchar](20) NOT NULL,
	[firstname] [nvarchar](10) NOT NULL,
	[title] [nvarchar](30) NOT NULL,
	[titleofcourtesy] [nvarchar](25) NOT NULL,
	[birthdate] [datetime] NOT NULL,
	[hiredate] [datetime] NOT NULL,
	[address] [nvarchar](60) NOT NULL,
	[city] [nvarchar](15) NOT NULL,
	[region] [nvarchar](15) NULL,
	[postalcode] [nvarchar](10) NULL,
	[country] [nvarchar](15) NOT NULL,
	[phone] [nvarchar](24) NOT NULL,
	[mgrid] [int] NULL,
 CONSTRAINT [PK_EmployeesBackup] PRIMARY KEY CLUSTERED 
(
	[empid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Production].[Suppliers]    Script Date: 10/8/2022 8:40:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Production].[Suppliers](
	[supplierid] [int] IDENTITY(1,1) NOT NULL,
	[companyname] [nvarchar](40) NOT NULL,
	[contactname] [nvarchar](30) NOT NULL,
	[contacttitle] [nvarchar](30) NOT NULL,
	[address] [nvarchar](60) NOT NULL,
	[city] [nvarchar](15) NOT NULL,
	[region] [nvarchar](15) NULL,
	[postalcode] [nvarchar](10) NULL,
	[country] [nvarchar](15) NOT NULL,
	[phone] [nvarchar](24) NOT NULL,
	[fax] [nvarchar](24) NULL,
 CONSTRAINT [PK_Suppliers] PRIMARY KEY CLUSTERED 
(
	[supplierid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Sales].[Customers]    Script Date: 10/8/2022 8:40:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Sales].[Customers](
	[custid] [int] IDENTITY(1,1) NOT NULL,
	[companyname] [nvarchar](40) NOT NULL,
	[contactname] [nvarchar](30) NOT NULL,
	[contacttitle] [nvarchar](30) NOT NULL,
	[address] [nvarchar](60) NOT NULL,
	[city] [nvarchar](15) NOT NULL,
	[region] [nvarchar](15) NULL,
	[postalcode] [nvarchar](10) NULL,
	[country] [nvarchar](15) NOT NULL,
	[phone] [nvarchar](24) NOT NULL,
	[fax] [nvarchar](24) NULL,
 CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED 
(
	[custid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Sales].[Shippers]    Script Date: 10/8/2022 8:40:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Sales].[Shippers](
	[shipperid] [int] IDENTITY(1,1) NOT NULL,
	[companyname] [nvarchar](40) NOT NULL,
	[phone] [nvarchar](24) NOT NULL,
 CONSTRAINT [PK_Shippers] PRIMARY KEY CLUSTERED 
(
	[shipperid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Sales].[Somedates]    Script Date: 10/8/2022 8:40:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Sales].[Somedates](
	[isitdate] [varchar](9) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [Stats].[Scores]    Script Date: 10/8/2022 8:40:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Stats].[Scores](
	[testid] [varchar](10) NOT NULL,
	[studentid] [varchar](10) NOT NULL,
	[score] [tinyint] NOT NULL,
 CONSTRAINT [PK_Scores] PRIMARY KEY CLUSTERED 
(
	[testid] ASC,
	[studentid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Stats].[Tests]    Script Date: 10/8/2022 8:40:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Stats].[Tests](
	[testid] [varchar](10) NOT NULL,
 CONSTRAINT [PK_Tests] PRIMARY KEY CLUSTERED 
(
	[testid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx_nc_lastname]    Script Date: 10/8/2022 8:40:43 PM ******/
CREATE NONCLUSTERED INDEX [idx_nc_lastname] ON [HR].[Employees]
(
	[lastname] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx_nc_postalcode]    Script Date: 10/8/2022 8:40:43 PM ******/
CREATE NONCLUSTERED INDEX [idx_nc_postalcode] ON [HR].[Employees]
(
	[postalcode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [categoryname]    Script Date: 10/8/2022 8:40:43 PM ******/
CREATE NONCLUSTERED INDEX [categoryname] ON [Production].[Categories]
(
	[categoryname] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_nc_categoryid]    Script Date: 10/8/2022 8:40:43 PM ******/
CREATE NONCLUSTERED INDEX [idx_nc_categoryid] ON [Production].[Products]
(
	[categoryid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx_nc_productname]    Script Date: 10/8/2022 8:40:43 PM ******/
CREATE NONCLUSTERED INDEX [idx_nc_productname] ON [Production].[Products]
(
	[productname] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_nc_supplierid]    Script Date: 10/8/2022 8:40:43 PM ******/
CREATE NONCLUSTERED INDEX [idx_nc_supplierid] ON [Production].[Products]
(
	[supplierid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx_nc_companyname]    Script Date: 10/8/2022 8:40:43 PM ******/
CREATE NONCLUSTERED INDEX [idx_nc_companyname] ON [Production].[Suppliers]
(
	[companyname] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx_nc_postalcode]    Script Date: 10/8/2022 8:40:43 PM ******/
CREATE NONCLUSTERED INDEX [idx_nc_postalcode] ON [Production].[Suppliers]
(
	[postalcode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx_nc_city]    Script Date: 10/8/2022 8:40:43 PM ******/
CREATE NONCLUSTERED INDEX [idx_nc_city] ON [Sales].[Customers]
(
	[city] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx_nc_companyname]    Script Date: 10/8/2022 8:40:43 PM ******/
CREATE NONCLUSTERED INDEX [idx_nc_companyname] ON [Sales].[Customers]
(
	[companyname] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx_nc_postalcode]    Script Date: 10/8/2022 8:40:43 PM ******/
CREATE NONCLUSTERED INDEX [idx_nc_postalcode] ON [Sales].[Customers]
(
	[postalcode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx_nc_region]    Script Date: 10/8/2022 8:40:43 PM ******/
CREATE NONCLUSTERED INDEX [idx_nc_region] ON [Sales].[Customers]
(
	[region] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_nc_orderid]    Script Date: 10/8/2022 8:40:43 PM ******/
CREATE NONCLUSTERED INDEX [idx_nc_orderid] ON [Sales].[OrderDetails]
(
	[orderid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_nc_productid]    Script Date: 10/8/2022 8:40:43 PM ******/
CREATE NONCLUSTERED INDEX [idx_nc_productid] ON [Sales].[OrderDetails]
(
	[productid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_nc_custid]    Script Date: 10/8/2022 8:40:43 PM ******/
CREATE NONCLUSTERED INDEX [idx_nc_custid] ON [Sales].[Orders]
(
	[custid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_nc_empid]    Script Date: 10/8/2022 8:40:43 PM ******/
CREATE NONCLUSTERED INDEX [idx_nc_empid] ON [Sales].[Orders]
(
	[empid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_nc_orderdate]    Script Date: 10/8/2022 8:40:43 PM ******/
CREATE NONCLUSTERED INDEX [idx_nc_orderdate] ON [Sales].[Orders]
(
	[orderdate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_nc_shippeddate]    Script Date: 10/8/2022 8:40:43 PM ******/
CREATE NONCLUSTERED INDEX [idx_nc_shippeddate] ON [Sales].[Orders]
(
	[shippeddate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_nc_shipperid]    Script Date: 10/8/2022 8:40:43 PM ******/
CREATE NONCLUSTERED INDEX [idx_nc_shipperid] ON [Sales].[Orders]
(
	[shipperid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx_nc_shippostalcode]    Script Date: 10/8/2022 8:40:43 PM ******/
CREATE NONCLUSTERED INDEX [idx_nc_shippostalcode] ON [Sales].[Orders]
(
	[shippostalcode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx_nc_testid_score]    Script Date: 10/8/2022 8:40:43 PM ******/
CREATE NONCLUSTERED INDEX [idx_nc_testid_score] ON [Stats].[Scores]
(
	[testid] ASC,
	[score] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [Production].[Products] ADD  CONSTRAINT [DFT_Products_unitprice]  DEFAULT ((0)) FOR [unitprice]
GO
ALTER TABLE [Production].[Products] ADD  CONSTRAINT [DFT_Products_discontinued]  DEFAULT ((0)) FOR [discontinued]
GO
ALTER TABLE [Sales].[OrderDetails] ADD  CONSTRAINT [DFT_OrderDetails_unitprice]  DEFAULT ((0)) FOR [unitprice]
GO
ALTER TABLE [Sales].[OrderDetails] ADD  CONSTRAINT [DFT_OrderDetails_qty]  DEFAULT ((1)) FOR [qty]
GO
ALTER TABLE [Sales].[OrderDetails] ADD  CONSTRAINT [DFT_OrderDetails_discount]  DEFAULT ((0)) FOR [discount]
GO
ALTER TABLE [Sales].[Orders] ADD  CONSTRAINT [DFT_Orders_freight]  DEFAULT ((0)) FOR [freight]
GO
ALTER TABLE [HR].[Employees]  WITH CHECK ADD  CONSTRAINT [FK_Employees_Employees] FOREIGN KEY([mgrid])
REFERENCES [HR].[Employees] ([empid])
GO
ALTER TABLE [HR].[Employees] CHECK CONSTRAINT [FK_Employees_Employees]
GO
ALTER TABLE [Production].[Products]  WITH CHECK ADD  CONSTRAINT [FK_Products_Categories] FOREIGN KEY([categoryid])
REFERENCES [Production].[Categories] ([categoryid])
GO
ALTER TABLE [Production].[Products] CHECK CONSTRAINT [FK_Products_Categories]
GO
ALTER TABLE [Production].[Products]  WITH CHECK ADD  CONSTRAINT [FK_Products_Suppliers] FOREIGN KEY([supplierid])
REFERENCES [Production].[Suppliers] ([supplierid])
GO
ALTER TABLE [Production].[Products] CHECK CONSTRAINT [FK_Products_Suppliers]
GO
ALTER TABLE [Sales].[OrderDetails]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetails_Orders] FOREIGN KEY([orderid])
REFERENCES [Sales].[Orders] ([orderid])
GO
ALTER TABLE [Sales].[OrderDetails] CHECK CONSTRAINT [FK_OrderDetails_Orders]
GO
ALTER TABLE [Sales].[OrderDetails]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetails_Products] FOREIGN KEY([productid])
REFERENCES [Production].[Products] ([productid])
GO
ALTER TABLE [Sales].[OrderDetails] CHECK CONSTRAINT [FK_OrderDetails_Products]
GO
ALTER TABLE [Sales].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Customers] FOREIGN KEY([custid])
REFERENCES [Sales].[Customers] ([custid])
GO
ALTER TABLE [Sales].[Orders] CHECK CONSTRAINT [FK_Orders_Customers]
GO
ALTER TABLE [Sales].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Employees] FOREIGN KEY([empid])
REFERENCES [HR].[Employees] ([empid])
GO
ALTER TABLE [Sales].[Orders] CHECK CONSTRAINT [FK_Orders_Employees]
GO
ALTER TABLE [Sales].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Shippers] FOREIGN KEY([shipperid])
REFERENCES [Sales].[Shippers] ([shipperid])
GO
ALTER TABLE [Sales].[Orders] CHECK CONSTRAINT [FK_Orders_Shippers]
GO
ALTER TABLE [Stats].[Scores]  WITH CHECK ADD  CONSTRAINT [FK_Scores_Tests] FOREIGN KEY([testid])
REFERENCES [Stats].[Tests] ([testid])
GO
ALTER TABLE [Stats].[Scores] CHECK CONSTRAINT [FK_Scores_Tests]
GO
ALTER TABLE [HR].[Employees]  WITH CHECK ADD  CONSTRAINT [CHK_birthdate] CHECK  (([birthdate]<=getdate()))
GO
ALTER TABLE [HR].[Employees] CHECK CONSTRAINT [CHK_birthdate]
GO
ALTER TABLE [Production].[Products]  WITH CHECK ADD  CONSTRAINT [CHK_Products_unitprice] CHECK  (([unitprice]>=(0)))
GO
ALTER TABLE [Production].[Products] CHECK CONSTRAINT [CHK_Products_unitprice]
GO
ALTER TABLE [Sales].[OrderDetails]  WITH CHECK ADD  CONSTRAINT [CHK_discount] CHECK  (([discount]>=(0) AND [discount]<=(1)))
GO
ALTER TABLE [Sales].[OrderDetails] CHECK CONSTRAINT [CHK_discount]
GO
ALTER TABLE [Sales].[OrderDetails]  WITH CHECK ADD  CONSTRAINT [CHK_qty] CHECK  (([qty]>(0)))
GO
ALTER TABLE [Sales].[OrderDetails] CHECK CONSTRAINT [CHK_qty]
GO
ALTER TABLE [Sales].[OrderDetails]  WITH CHECK ADD  CONSTRAINT [CHK_unitprice] CHECK  (([unitprice]>=(0)))
GO
ALTER TABLE [Sales].[OrderDetails] CHECK CONSTRAINT [CHK_unitprice]
GO
ALTER TABLE [Stats].[Scores]  WITH CHECK ADD  CONSTRAINT [CHK_Scores_score] CHECK  (([score]>=(0) AND [score]<=(100)))
GO
ALTER TABLE [Stats].[Scores] CHECK CONSTRAINT [CHK_Scores_score]
GO
USE [master]
GO
ALTER DATABASE [TSQL] SET  READ_WRITE 
GO
