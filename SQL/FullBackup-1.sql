USE [master]
GO
/****** Object:  Database [BashatParween]    Script Date: 23-04-2025 15:11:06 ******/
CREATE DATABASE [BashatParween]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Bashat_Test10', FILENAME = N'C:\Program Files (x86)\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Bashat_Test10.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Bashat_Test10_log', FILENAME = N'C:\Program Files (x86)\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Bashat_Test10_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [BashatParween] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BashatParween].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BashatParween] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BashatParween] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BashatParween] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BashatParween] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BashatParween] SET ARITHABORT OFF 
GO
ALTER DATABASE [BashatParween] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [BashatParween] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BashatParween] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BashatParween] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BashatParween] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BashatParween] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BashatParween] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BashatParween] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BashatParween] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BashatParween] SET  ENABLE_BROKER 
GO
ALTER DATABASE [BashatParween] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BashatParween] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BashatParween] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BashatParween] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BashatParween] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BashatParween] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BashatParween] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BashatParween] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [BashatParween] SET  MULTI_USER 
GO
ALTER DATABASE [BashatParween] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BashatParween] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BashatParween] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BashatParween] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [BashatParween] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [BashatParween] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [BashatParween] SET QUERY_STORE = ON
GO
ALTER DATABASE [BashatParween] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [BashatParween]
GO
/****** Object:  UserDefinedFunction [dbo].[AddDigit]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[AddDigit](@num1 int, @num2 int)
returns int
As
Begin
Declare @result int;
set @result = @num1 + @num2;
return @result
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetAllStudent]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetAllStudent]
(
  @RollNo INT
)
RETURNS @MarkSheet TABLE
(
  stName  VARCHAR(50),
  RollNo  INT,
  Science INT,
  Math    INT,
  Eng     INT,
  Average DECIMAL(5,2)
)
AS
BEGIN
  DECLARE 
    @StName   VARCHAR(50),
    @Sci      INT,
    @Mth      INT,
    @Engl     INT,
    @Average  DECIMAL(5,2);

  -- 1) Pull student name + marks in one go
  SELECT
    @StName = s.FirstName,  -- make sure this column really exists in your Student table
    @Sci    = m.Science,
    @Mth    = m.Math,
    @Engl   = m.Eng
  FROM dbo.Employee       AS s
  INNER JOIN dbo.Student_Marks AS m
    ON s.Id = m.RollNo
  WHERE s.Id = @RollNo;

  -- 2) Compute average (decimal division)
  SET @Average = CONVERT(DECIMAL(5,2), (@Sci + @Mth + @Engl) / 3.0);

  -- 3) Populate the return table
  INSERT INTO @MarkSheet
  (
    stName,
    RollNo,
    Science,
    Math,
    Eng,
    Average
  )
  VALUES
  (
    @StName,
    @RollNo,
    @Sci,
    @Mth,
    @Engl,
    @Average
  );

  RETURN;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[GetAllStudent2]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create FUNCTION [dbo].[GetAllStudent2]
(
  @RollNo INT
)
RETURNS @MarkSheet TABLE
(
  stName  VARCHAR(50), 
  RollNo  INT,
  Science INT,
  Math    INT,
  Eng     INT,
  Average DECIMAL(4,2)
)
AS
BEGIN
  DECLARE 
    @percentage DECIMAL(4,2),
    @stName     VARCHAR(100),
    @s          INT,
    @m          INT,
    @e          INT;

  -- fetch student name and marks into variables
  SELECT
    @stName = s.StudentName,
    @s      = m.Science,
    @m      = m.Math,
    @e      = m.Eng
  FROM dbo.Students      AS s
  JOIN dbo.Student_marks AS m
    ON s.RollNo = m.RollNo
  WHERE s.RollNo = @RollNo;

  -- compute average
  SET @percentage = CAST((@s + @m + @e) / 3.0 AS DECIMAL(4,2));

  -- now insert, referencing the variable
  INSERT INTO @MarkSheet
  (
    stName,
    RollNo,
    Science,
    Math,
    Eng,
    Average
  )
  VALUES
  (
    @stName,
    @RollNo,
    @s,
    @m,
    @e,
    @percentage
  );

  RETURN;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[GetAllStudents]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetAllStudents]
(
  @RollNo INT
)
RETURNS @MarkSheet TABLE
(
  StudentName  VARCHAR(50), 
  RollNo  INT,
  Science INT,
  Math    INT,
  Eng     INT,
  Average DECIMAL(4,2)
)
AS
BEGIN
  DECLARE 
    @DepId       INT,
    @StName      VARCHAR(50),
    @Sci         INT,
    @Mth         INT,
    @Engl        INT,
    @percentage  DECIMAL(4,2);

  -- 1) get student’s department and name
  SELECT
    @RollNo  = s.RollNo,
    @StName = s.StudentName
  FROM dbo.Students AS s
  WHERE s.RollNo = @RollNo;

  -- 2) get marks
  SELECT
    @Sci   = m.Science,
    @Mth   = m.Math,
    @Engl  = m.Eng
  FROM dbo.Student_marks AS m
  WHERE m.RollNo = @RollNo;

  -- 3) compute average
  SET @percentage = CAST((@Sci + @Mth + @Engl) / 3.0 AS DECIMAL(4,2));
  
  -- 4) get department name
  SELECT @StName = D_Name
  FROM dbo.Departments
  WHERE DepId = @DepId;
  
  -- 5) insert into your TVF’s table variable
  INSERT INTO @MarkSheet
    (StudentName, RollNo, Science, Math, Eng, Average)
  VALUES
    (@StName, @RollNo, @Sci, @Mth, @Engl, @percentage);

  RETURN;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[GetAvg]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[GetAvg](@Rollno int)
returns int
As
Begin
Declare @result int;
select @result = ((Science) + (Math) + (Eng))/3 
from Student_marks where RollNo = @Rollno;
return @result
end
GO
/****** Object:  UserDefinedFunction [dbo].[GetFullName]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetFullName]
(
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50)
)
RETURNS VARCHAR(100)
AS
BEGIN
    RETURN (@FirstName + ' ' + @LastName)
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetTotal]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[GetTotal](@Rollno int)
returns int
As
Begin
Declare @result int;
select @result = (Science) + (Math) + (Eng)
from Student_marks where RollNo = @Rollno;
return @result
end
GO
/****** Object:  Table [dbo].[Customers]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customers](
	[C_ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Address] [varchar](max) NULL,
	[City] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[C_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[order]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[order](
	[O_ID] [int] NOT NULL,
	[Item] [varchar](50) NULL,
	[Quantity] [int] NULL,
	[Price] [int] NULL,
	[C_ID] [int] NULL,
	[Place] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[O_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[GetAllInfo]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[GetAllInfo]
As
select c.*,o.O_ID,o.Item,o.Quantity,o.Price,o.Place from Customers as c
inner join
[order] as o 
ON c.C_ID = o.C_ID
where o.Price > 850;
GO
/****** Object:  Table [dbo].[Student_marks]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Student_marks](
	[RollNo] [int] NULL,
	[Name] [varchar](50) NULL,
	[Science] [int] NULL,
	[Math] [int] NULL,
	[Eng] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[GetStudentResult]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[GetStudentResult](@total int)
returns TABLE 
As
return
(
select * from Student_marks
where ((Science) + (Math) + (Eng)) > @total
);
GO
/****** Object:  Table [dbo].[Departments]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Departments](
	[DepId] [int] IDENTITY(1,1) NOT NULL,
	[D_Name] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[DepId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[GetDept]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetDept]
(
    @DeptID INT
)
RETURNS TABLE
AS
RETURN (
    SELECT DepId, D_Name
    FROM Departments
    WHERE DepId = @DeptID
);
GO
/****** Object:  Table [dbo].[MyEmployees]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MyEmployees](
	[Emp_Id] [int] NOT NULL,
	[Emp_name] [varchar](50) NULL,
	[Gender] [varchar](20) NULL,
	[Salary] [int] NULL,
	[City] [varchar](50) NULL,
	[Dept_Id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Emp_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MyDepartment]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MyDepartment](
	[Id] [int] NOT NULL,
	[Dept_Name] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_ForEmployees]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vw_ForEmployees]
As
select * from MyEmployees as E
inner join MyDepartment as D
on D.Id = E.Dept_Id;
GO
/****** Object:  View [dbo].[vw_ForEmployee1]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_ForEmployee1]
As
select A.*, B.Dept_Name from MyEmployees as A
inner join MyDepartment as B
on B.Id = A.Dept_Id;
GO
/****** Object:  View [dbo].[vw_ForEmployees2]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view  [dbo].[vw_ForEmployees2]
As
select A.Emp_Id, A.Emp_Name, A.Gender, A.City, A.Dept_Id, B.Dept_Name
from MyEmployees as A
inner join 
MyDepartment as B
on B.Id = A.Dept_Id;
GO
/****** Object:  View [dbo].[vw_ForEmployees3]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_ForEmployees3]
As
select A.*, B.Dept_Name from MyEmployees as A
inner join MyDepartment as B
on B.Id = A.Dept_Id
where Dept_Name = 'HR';
GO
/****** Object:  View [dbo].[vw_ForEmployees4]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_ForEmployees4]
As
select A.*, B.Dept_Name from MyEmployees as A
inner join MyDepartment as B
on B.Id = A.Dept_Id
where Dept_Name = 'HR' or Dept_Name = 'Accounts';
GO
/****** Object:  View [dbo].[vw_ForMyEmployees]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_ForMyEmployees]
as
select * from MyEmployees;
GO
/****** Object:  Table [dbo].[Courses]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Courses](
	[CourseID] [int] NOT NULL,
	[CourseName] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[CourseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customer_Audit_table]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer_Audit_table](
	[Audit_Id] [int] IDENTITY(1,1) NOT NULL,
	[Audit_info] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[Audit_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Department]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Department](
	[DepId] [int] NOT NULL,
	[DepName] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DepId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Department1]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Department1](
	[DeptID] [int] NOT NULL,
	[DeptName] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[DeptID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Division]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Division](
	[divId] [int] IDENTITY(1,1) NOT NULL,
	[divName] [varchar](100) NULL,
	[StdId] [int] NULL,
	[TeacherId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[divId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NULL,
	[Salary] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employee_details]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee_details](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[Gender] [varchar](20) NULL,
	[salary] [int] NOT NULL,
	[City] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employee1]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee1](
	[EmpID] [int] NOT NULL,
	[EmpName] [varchar](100) NULL,
	[DeptID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[EmpID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employees]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employees](
	[RegId] [int] IDENTITY(1,1) NOT NULL,
	[FullName] [varchar](50) NULL,
	[Salary] [int] NOT NULL,
	[Country] [varchar](100) NULL,
	[EmailId] [nvarchar](80) NULL,
	[CurrentDate] [datetime] NULL,
	[DepId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[RegId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Picnic]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Picnic](
	[PicId] [int] IDENTITY(1,1) NOT NULL,
	[StdId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[PicId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[student]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[student](
	[StdId] [int] NOT NULL,
	[Name] [varchar](50) NULL,
	[Standard] [int] NULL,
	[Address] [varchar](150) NULL,
	[age] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[StdId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Student_Details]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Student_Details](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Gender] [varchar](20) NOT NULL,
	[Class] [int] NULL,
	[Fees] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Student_Info]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Student_Info](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Gender] [varchar](20) NOT NULL,
	[Class] [int] NULL,
	[Fees] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Student_Log]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Student_Log](
	[Id] [int] NULL,
	[Name] [nvarchar](100) NULL,
	[InsertedDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Student_Log1]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Student_Log1](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Info] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudentCourses]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentCourses](
	[StudentID] [int] NOT NULL,
	[CourseID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[StudentID] ASC,
	[CourseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Students]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Students](
	[RollNo] [int] NOT NULL,
	[StudentName] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[RollNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Students1]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Students1](
	[StdId] [int] IDENTITY(1,1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[StdId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Students2]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Students2](
	[StudentID] [int] NOT NULL,
	[StudentName] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[StudentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tb1_Customer]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tb1_Customer](
	[Id] [int] NOT NULL,
	[Name] [varchar](50) NULL,
	[Gender] [varchar](20) NULL,
	[City] [varchar](50) NULL,
	[ContactNo] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Teacher]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Teacher](
	[TeacherId] [int] NOT NULL,
	[Name] [varchar](50) NULL,
	[Address] [varchar](200) NULL,
	[salary] [int] NULL,
	[StdId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[TeacherId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserProfiles]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserProfiles](
	[ProfileID] [int] NOT NULL,
	[UserID] [int] NULL,
	[Bio] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[ProfileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserID] [int] NOT NULL,
	[UserName] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Customer_Audit_table] ON 

INSERT [dbo].[Customer_Audit_table] ([Audit_Id], [Audit_info]) VALUES (1, N'Someone tries to insert data in customer table at : Apr 18 2025  3:39PM')
INSERT [dbo].[Customer_Audit_table] ([Audit_Id], [Audit_info]) VALUES (2, N'Someone tries to insert data in customer table at : Apr 18 2025  3:41PM')
INSERT [dbo].[Customer_Audit_table] ([Audit_Id], [Audit_info]) VALUES (3, N'Someone tries to Update data in customer table at : Apr 18 2025  3:45PM')
INSERT [dbo].[Customer_Audit_table] ([Audit_Id], [Audit_info]) VALUES (4, N'Someone tries to Delete data in customer table at : Apr 18 2025  3:48PM')
SET IDENTITY_INSERT [dbo].[Customer_Audit_table] OFF
GO
SET IDENTITY_INSERT [dbo].[Customers] ON 

INSERT [dbo].[Customers] ([C_ID], [Name], [Address], [City]) VALUES (1, N'Neha', N'Flora No:8', N'Mumbai')
INSERT [dbo].[Customers] ([C_ID], [Name], [Address], [City]) VALUES (2, N'Zeba', N'Flora No:5', N'Delhi')
INSERT [dbo].[Customers] ([C_ID], [Name], [Address], [City]) VALUES (3, N'Riya', N'Flora No:3', N'Mumbai')
INSERT [dbo].[Customers] ([C_ID], [Name], [Address], [City]) VALUES (4, N'Piya', N'Flora No:2', N'Lucknow')
INSERT [dbo].[Customers] ([C_ID], [Name], [Address], [City]) VALUES (5, N'Ziya', N'Flora No:9', N'Delhi')
INSERT [dbo].[Customers] ([C_ID], [Name], [Address], [City]) VALUES (6, N'Ruhi', N'Flora No:1', N'Lucknow')
SET IDENTITY_INSERT [dbo].[Customers] OFF
GO
INSERT [dbo].[Department] ([DepId], [DepName]) VALUES (1, N'Admin')
INSERT [dbo].[Department] ([DepId], [DepName]) VALUES (2, N'HR')
INSERT [dbo].[Department] ([DepId], [DepName]) VALUES (3, N'Managemnt')
INSERT [dbo].[Department] ([DepId], [DepName]) VALUES (4, N'sales')
INSERT [dbo].[Department] ([DepId], [DepName]) VALUES (5, N'Developer')
INSERT [dbo].[Department] ([DepId], [DepName]) VALUES (6, N'Developer')
GO
SET IDENTITY_INSERT [dbo].[Departments] ON 

INSERT [dbo].[Departments] ([DepId], [D_Name]) VALUES (1, N'HR')
INSERT [dbo].[Departments] ([DepId], [D_Name]) VALUES (2, N'Management')
SET IDENTITY_INSERT [dbo].[Departments] OFF
GO
SET IDENTITY_INSERT [dbo].[Division] ON 

INSERT [dbo].[Division] ([divId], [divName], [StdId], [TeacherId]) VALUES (1, N'A', 104, 201)
INSERT [dbo].[Division] ([divId], [divName], [StdId], [TeacherId]) VALUES (2, N'B', 105, 202)
INSERT [dbo].[Division] ([divId], [divName], [StdId], [TeacherId]) VALUES (3, N'C', 106, 204)
INSERT [dbo].[Division] ([divId], [divName], [StdId], [TeacherId]) VALUES (4, N'D', 101, 205)
INSERT [dbo].[Division] ([divId], [divName], [StdId], [TeacherId]) VALUES (5, N'E', 102, 206)
SET IDENTITY_INSERT [dbo].[Division] OFF
GO
SET IDENTITY_INSERT [dbo].[Employee] ON 

INSERT [dbo].[Employee] ([Id], [FirstName], [LastName], [Salary]) VALUES (1, N'Mysha', N'Alam', 23000)
INSERT [dbo].[Employee] ([Id], [FirstName], [LastName], [Salary]) VALUES (2, N'Zyna', N'Alam', 33000)
INSERT [dbo].[Employee] ([Id], [FirstName], [LastName], [Salary]) VALUES (3, N'Amna', N'Khan', 21000)
INSERT [dbo].[Employee] ([Id], [FirstName], [LastName], [Salary]) VALUES (4, N'Mysha', N'Alam', 24000)
INSERT [dbo].[Employee] ([Id], [FirstName], [LastName], [Salary]) VALUES (5, N'Zyna', N'Alam', 25000)
INSERT [dbo].[Employee] ([Id], [FirstName], [LastName], [Salary]) VALUES (6, N'Amna', N'Khan', 27000)
INSERT [dbo].[Employee] ([Id], [FirstName], [LastName], [Salary]) VALUES (7, N'Arslan', N'Alam', 23000)
SET IDENTITY_INSERT [dbo].[Employee] OFF
GO
SET IDENTITY_INSERT [dbo].[Employee_details] ON 

INSERT [dbo].[Employee_details] ([Id], [Name], [Gender], [salary], [City]) VALUES (1, N'Ali', N'Male', 45000, N'Mumbai')
INSERT [dbo].[Employee_details] ([Id], [Name], [Gender], [salary], [City]) VALUES (2, N'Neha', N'female', 65000, N'Chennai')
INSERT [dbo].[Employee_details] ([Id], [Name], [Gender], [salary], [City]) VALUES (3, N'Riya', N'Female', 55000, N'Mumbai')
INSERT [dbo].[Employee_details] ([Id], [Name], [Gender], [salary], [City]) VALUES (4, N'Ali', N'Male', 75000, N'Patna')
INSERT [dbo].[Employee_details] ([Id], [Name], [Gender], [salary], [City]) VALUES (5, N'Armaan', N'Male', 75000, N'Patna')
INSERT [dbo].[Employee_details] ([Id], [Name], [Gender], [salary], [City]) VALUES (6, N'Afzal', N'Male', 95000, N'Mumbai')
SET IDENTITY_INSERT [dbo].[Employee_details] OFF
GO
SET IDENTITY_INSERT [dbo].[Employees] ON 

INSERT [dbo].[Employees] ([RegId], [FullName], [Salary], [Country], [EmailId], [CurrentDate], [DepId]) VALUES (1, N'Bashat Parween', 94000, N'India', N'bashat@gmail.com', CAST(N'2025-04-14T12:06:52.590' AS DateTime), 1)
INSERT [dbo].[Employees] ([RegId], [FullName], [Salary], [Country], [EmailId], [CurrentDate], [DepId]) VALUES (2, N'Tanveer Shaikh', 34000, N'India', N'tanveer@gmail.com', CAST(N'2025-04-14T12:06:52.590' AS DateTime), 1)
INSERT [dbo].[Employees] ([RegId], [FullName], [Salary], [Country], [EmailId], [CurrentDate], [DepId]) VALUES (3, N'Arif Khan', 44000, N'India', N'arif@gmail.com', CAST(N'2025-04-14T12:06:52.590' AS DateTime), 3)
INSERT [dbo].[Employees] ([RegId], [FullName], [Salary], [Country], [EmailId], [CurrentDate], [DepId]) VALUES (4, N'Narayan Pandey', 54000, N'India', N'narayan@gmail.com', CAST(N'2025-04-14T12:06:52.590' AS DateTime), 2)
INSERT [dbo].[Employees] ([RegId], [FullName], [Salary], [Country], [EmailId], [CurrentDate], [DepId]) VALUES (5, N'Neha Pandey', 64000, N'India', N'neha@gmail.com', CAST(N'2025-04-14T12:06:52.590' AS DateTime), 2)
INSERT [dbo].[Employees] ([RegId], [FullName], [Salary], [Country], [EmailId], [CurrentDate], [DepId]) VALUES (7, N'Nikita Joshi', 94000, N'India', N'nikita@gmail.com', CAST(N'2025-04-14T14:43:43.237' AS DateTime), 4)
INSERT [dbo].[Employees] ([RegId], [FullName], [Salary], [Country], [EmailId], [CurrentDate], [DepId]) VALUES (8, N'Reem Shaikh', 34000, N'India', N'reem@gmail.com', CAST(N'2025-04-14T14:43:43.237' AS DateTime), 4)
INSERT [dbo].[Employees] ([RegId], [FullName], [Salary], [Country], [EmailId], [CurrentDate], [DepId]) VALUES (11, N'Tanveer Shaikh', 44000, N'India', N'tanveeralam@gmail.com', CAST(N'2025-04-21T16:34:28.047' AS DateTime), 3)
INSERT [dbo].[Employees] ([RegId], [FullName], [Salary], [Country], [EmailId], [CurrentDate], [DepId]) VALUES (12, N'Neha Pandey', 74000, N'India', N'pandey@gmail.com', CAST(N'2025-04-21T16:35:42.717' AS DateTime), 5)
SET IDENTITY_INSERT [dbo].[Employees] OFF
GO
INSERT [dbo].[MyDepartment] ([Id], [Dept_Name]) VALUES (1, N'Administration')
INSERT [dbo].[MyDepartment] ([Id], [Dept_Name]) VALUES (2, N'HR')
INSERT [dbo].[MyDepartment] ([Id], [Dept_Name]) VALUES (3, N'Accounts')
INSERT [dbo].[MyDepartment] ([Id], [Dept_Name]) VALUES (4, N'Counselling')
INSERT [dbo].[MyDepartment] ([Id], [Dept_Name]) VALUES (5, N'Managements')
INSERT [dbo].[MyDepartment] ([Id], [Dept_Name]) VALUES (6, N'HR')
GO
INSERT [dbo].[MyEmployees] ([Emp_Id], [Emp_name], [Gender], [Salary], [City], [Dept_Id]) VALUES (100, N'Bashat Parween', N'Female', 27000, N'Hyderabad', 2)
INSERT [dbo].[MyEmployees] ([Emp_Id], [Emp_name], [Gender], [Salary], [City], [Dept_Id]) VALUES (101, N'Ayeza Akhtar', N'Female', 35000, N'Alhabad', 1)
INSERT [dbo].[MyEmployees] ([Emp_Id], [Emp_name], [Gender], [Salary], [City], [Dept_Id]) VALUES (102, N'Ayaan Alam', N'Male', 22000, N'Aligarh', 3)
INSERT [dbo].[MyEmployees] ([Emp_Id], [Emp_name], [Gender], [Salary], [City], [Dept_Id]) VALUES (103, N'Arslaan Khan', N'Male', 34000, N'Lucknow', 4)
INSERT [dbo].[MyEmployees] ([Emp_Id], [Emp_name], [Gender], [Salary], [City], [Dept_Id]) VALUES (104, N'Maheen Akhtar', N'Female', 56000, N'Gandhi Nangar', 5)
INSERT [dbo].[MyEmployees] ([Emp_Id], [Emp_name], [Gender], [Salary], [City], [Dept_Id]) VALUES (105, N'Perwaiz Alam', N'Male', 58000, N'Delhi', 6)
INSERT [dbo].[MyEmployees] ([Emp_Id], [Emp_name], [Gender], [Salary], [City], [Dept_Id]) VALUES (113, N'Sufiyan', N'Male', 37000, N'Hyderabad', 3)
GO
INSERT [dbo].[order] ([O_ID], [Item], [Quantity], [Price], [C_ID], [Place]) VALUES (111, N'Hardisk', 2, 500, 3, N'Mira road')
INSERT [dbo].[order] ([O_ID], [Item], [Quantity], [Price], [C_ID], [Place]) VALUES (222, N'Ram', 5, 2500, 3, N'Naya Nagar')
INSERT [dbo].[order] ([O_ID], [Item], [Quantity], [Price], [C_ID], [Place]) VALUES (333, N'Keyboard', 7, 850, 2, N'Ganga Complex')
INSERT [dbo].[order] ([O_ID], [Item], [Quantity], [Price], [C_ID], [Place]) VALUES (444, N'Mouse', 2, 500, 3, N'Shivar garden')
INSERT [dbo].[order] ([O_ID], [Item], [Quantity], [Price], [C_ID], [Place]) VALUES (555, N'Speaker', 4, 3000, 1, N'Mira road')
INSERT [dbo].[order] ([O_ID], [Item], [Quantity], [Price], [C_ID], [Place]) VALUES (666, N'Pendrive', 2, 1500, 6, N'Mira road')
INSERT [dbo].[order] ([O_ID], [Item], [Quantity], [Price], [C_ID], [Place]) VALUES (777, N'USB', 4, 5000, 6, N'Shivar garden')
GO
SET IDENTITY_INSERT [dbo].[Picnic] ON 

INSERT [dbo].[Picnic] ([PicId], [StdId]) VALUES (1, 1)
INSERT [dbo].[Picnic] ([PicId], [StdId]) VALUES (2, 2)
INSERT [dbo].[Picnic] ([PicId], [StdId]) VALUES (3, 7)
INSERT [dbo].[Picnic] ([PicId], [StdId]) VALUES (4, 9)
INSERT [dbo].[Picnic] ([PicId], [StdId]) VALUES (5, 10)
SET IDENTITY_INSERT [dbo].[Picnic] OFF
GO
INSERT [dbo].[student] ([StdId], [Name], [Standard], [Address], [age]) VALUES (101, N'Neha', 12, N'Bhayendar,Mumbai', NULL)
INSERT [dbo].[student] ([StdId], [Name], [Standard], [Address], [age]) VALUES (102, N'Riya', 12, N'Mira road,Mumbai', NULL)
INSERT [dbo].[student] ([StdId], [Name], [Standard], [Address], [age]) VALUES (103, N'Aman', 12, N'Kandevali,Mumbai', NULL)
INSERT [dbo].[student] ([StdId], [Name], [Standard], [Address], [age]) VALUES (104, N'Noor', 12, N'Mumbai', NULL)
INSERT [dbo].[student] ([StdId], [Name], [Standard], [Address], [age]) VALUES (105, N'Zeba', 12, N'Mumbai', NULL)
INSERT [dbo].[student] ([StdId], [Name], [Standard], [Address], [age]) VALUES (106, N'Kulsoom', 12, N'Mumbai', NULL)
GO
SET IDENTITY_INSERT [dbo].[Student_Details] ON 

INSERT [dbo].[Student_Details] ([Id], [Name], [Gender], [Class], [Fees]) VALUES (1, N'Bashat', N'Female', 15, 54000)
INSERT [dbo].[Student_Details] ([Id], [Name], [Gender], [Class], [Fees]) VALUES (2, N'Ali', N'Male', 14, 44000)
INSERT [dbo].[Student_Details] ([Id], [Name], [Gender], [Class], [Fees]) VALUES (3, N'Maheen', N'Female', 4, 34000)
INSERT [dbo].[Student_Details] ([Id], [Name], [Gender], [Class], [Fees]) VALUES (4, N'Hasnain', N'Male', 12, 52000)
INSERT [dbo].[Student_Details] ([Id], [Name], [Gender], [Class], [Fees]) VALUES (5, N'Amna', N'Female', 10, 22000)
INSERT [dbo].[Student_Details] ([Id], [Name], [Gender], [Class], [Fees]) VALUES (6, N'Arbaaz', N'Male', 12, 32000)
INSERT [dbo].[Student_Details] ([Id], [Name], [Gender], [Class], [Fees]) VALUES (8, N'Manal', N'Female', 14, 40000)
INSERT [dbo].[Student_Details] ([Id], [Name], [Gender], [Class], [Fees]) VALUES (9, N'Manas', N'Male', 8, 20000)
INSERT [dbo].[Student_Details] ([Id], [Name], [Gender], [Class], [Fees]) VALUES (11, N'Manas', N'Male', 8, 20000)
INSERT [dbo].[Student_Details] ([Id], [Name], [Gender], [Class], [Fees]) VALUES (12, N'Moona', N'female', 9, 21000)
INSERT [dbo].[Student_Details] ([Id], [Name], [Gender], [Class], [Fees]) VALUES (13, N'Vikas', N'Male', 15, 29000)
SET IDENTITY_INSERT [dbo].[Student_Details] OFF
GO
SET IDENTITY_INSERT [dbo].[Student_Info] ON 

INSERT [dbo].[Student_Info] ([Id], [Name], [Gender], [Class], [Fees]) VALUES (1, N'Bashat', N'Female', 15, 54000)
INSERT [dbo].[Student_Info] ([Id], [Name], [Gender], [Class], [Fees]) VALUES (2, N'Ali', N'Male', 14, 44000)
INSERT [dbo].[Student_Info] ([Id], [Name], [Gender], [Class], [Fees]) VALUES (3, N'Maheen', N'Female', 4, 34000)
INSERT [dbo].[Student_Info] ([Id], [Name], [Gender], [Class], [Fees]) VALUES (4, N'Hasnain', N'Male', 12, 52000)
INSERT [dbo].[Student_Info] ([Id], [Name], [Gender], [Class], [Fees]) VALUES (5, N'Amna', N'Female', 10, 22000)
INSERT [dbo].[Student_Info] ([Id], [Name], [Gender], [Class], [Fees]) VALUES (6, N'Arbaaz', N'Male', 12, 32000)
INSERT [dbo].[Student_Info] ([Id], [Name], [Gender], [Class], [Fees]) VALUES (8, N'Manal', N'Female', 14, 40000)
INSERT [dbo].[Student_Info] ([Id], [Name], [Gender], [Class], [Fees]) VALUES (9, N'Manas', N'Male', 8, 20000)
INSERT [dbo].[Student_Info] ([Id], [Name], [Gender], [Class], [Fees]) VALUES (11, N'Manas', N'Male', 8, 20000)
INSERT [dbo].[Student_Info] ([Id], [Name], [Gender], [Class], [Fees]) VALUES (12, N'Moona', N'female', 9, 21000)
INSERT [dbo].[Student_Info] ([Id], [Name], [Gender], [Class], [Fees]) VALUES (13, N'Vikas', N'Male', 15, 29000)
SET IDENTITY_INSERT [dbo].[Student_Info] OFF
GO
INSERT [dbo].[Student_Log] ([Id], [Name], [InsertedDate]) VALUES (8, N'Manal', CAST(N'2025-04-15T18:04:36.020' AS DateTime))
INSERT [dbo].[Student_Log] ([Id], [Name], [InsertedDate]) VALUES (9, N'Manas', CAST(N'2025-04-16T10:32:44.363' AS DateTime))
INSERT [dbo].[Student_Log] ([Id], [Name], [InsertedDate]) VALUES (10, N'Manas', CAST(N'2025-04-16T10:53:09.263' AS DateTime))
INSERT [dbo].[Student_Log] ([Id], [Name], [InsertedDate]) VALUES (11, N'Manas', CAST(N'2025-04-16T12:08:24.003' AS DateTime))
INSERT [dbo].[Student_Log] ([Id], [Name], [InsertedDate]) VALUES (12, N'Moona', CAST(N'2025-04-16T12:14:45.720' AS DateTime))
INSERT [dbo].[Student_Log] ([Id], [Name], [InsertedDate]) VALUES (13, N'Meena', CAST(N'2025-04-16T12:22:43.853' AS DateTime))
INSERT [dbo].[Student_Log] ([Id], [Name], [InsertedDate]) VALUES (14, N'Meena', CAST(N'2025-04-16T12:27:10.467' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Student_Log1] ON 

INSERT [dbo].[Student_Log1] ([Id], [Info]) VALUES (1, N'Student with id : 12is added atApr 16 2025 12:14PM')
INSERT [dbo].[Student_Log1] ([Id], [Info]) VALUES (2, N'Student with id : 1is added atApr 16 2025 12:14PM')
INSERT [dbo].[Student_Log1] ([Id], [Info]) VALUES (3, N'  Student   with   id :  13  is  added  at  Apr 16 2025 12:22PM')
INSERT [dbo].[Student_Log1] ([Id], [Info]) VALUES (4, N'Student with id : 3is added atApr 16 2025 12:22PM')
INSERT [dbo].[Student_Log1] ([Id], [Info]) VALUES (5, N'  Student   with   id :  14  is  added  at  Apr 16 2025 12:27PM')
INSERT [dbo].[Student_Log1] ([Id], [Info]) VALUES (6, N'Student with id : 5is added atApr 16 2025 12:27PM')
SET IDENTITY_INSERT [dbo].[Student_Log1] OFF
GO
INSERT [dbo].[Student_marks] ([RollNo], [Name], [Science], [Math], [Eng]) VALUES (501, N'Maheen', 89, 78, 97)
INSERT [dbo].[Student_marks] ([RollNo], [Name], [Science], [Math], [Eng]) VALUES (502, N'Mehjabeen', 98, 68, 67)
INSERT [dbo].[Student_marks] ([RollNo], [Name], [Science], [Math], [Eng]) VALUES (503, N'Mysha', 82, 70, 77)
INSERT [dbo].[Student_marks] ([RollNo], [Name], [Science], [Math], [Eng]) VALUES (504, N'Myra', 81, 69, 987)
INSERT [dbo].[Student_marks] ([RollNo], [Name], [Science], [Math], [Eng]) VALUES (505, N'Moona', 85, 85, 69)
GO
INSERT [dbo].[Students] ([RollNo], [StudentName]) VALUES (101, N'Roohi')
INSERT [dbo].[Students] ([RollNo], [StudentName]) VALUES (102, N'Rooni')
INSERT [dbo].[Students] ([RollNo], [StudentName]) VALUES (103, N'Pooja')
GO
SET IDENTITY_INSERT [dbo].[Students1] ON 

INSERT [dbo].[Students1] ([StdId]) VALUES (1)
INSERT [dbo].[Students1] ([StdId]) VALUES (2)
INSERT [dbo].[Students1] ([StdId]) VALUES (3)
INSERT [dbo].[Students1] ([StdId]) VALUES (4)
INSERT [dbo].[Students1] ([StdId]) VALUES (5)
INSERT [dbo].[Students1] ([StdId]) VALUES (6)
INSERT [dbo].[Students1] ([StdId]) VALUES (7)
INSERT [dbo].[Students1] ([StdId]) VALUES (8)
INSERT [dbo].[Students1] ([StdId]) VALUES (9)
INSERT [dbo].[Students1] ([StdId]) VALUES (10)
SET IDENTITY_INSERT [dbo].[Students1] OFF
GO
INSERT [dbo].[Tb1_Customer] ([Id], [Name], [Gender], [City], [ContactNo]) VALUES (101, N'Bashat Parween', N'Female', N'Mumbai', 987654321)
INSERT [dbo].[Tb1_Customer] ([Id], [Name], [Gender], [City], [ContactNo]) VALUES (102, N'Ayaan Alam', N'Male', N'Muscat', 654732898)
INSERT [dbo].[Tb1_Customer] ([Id], [Name], [Gender], [City], [ContactNo]) VALUES (103, N'Nigar Alam', N'Female', N'Bihar', 987654322)
INSERT [dbo].[Tb1_Customer] ([Id], [Name], [Gender], [City], [ContactNo]) VALUES (104, N'Arslan Khan', N'Male', N'Delhi', 987654323)
INSERT [dbo].[Tb1_Customer] ([Id], [Name], [Gender], [City], [ContactNo]) VALUES (105, N'Zeba Nousheen', N'Female', N'Lucknow', 987654324)
GO
INSERT [dbo].[Teacher] ([TeacherId], [Name], [Address], [salary], [StdId]) VALUES (201, N'Neha', N'Bhayendar,Mumbai', 100000, 101)
INSERT [dbo].[Teacher] ([TeacherId], [Name], [Address], [salary], [StdId]) VALUES (202, N'Riya', N'Mira road,Mumbai', 20000, 102)
INSERT [dbo].[Teacher] ([TeacherId], [Name], [Address], [salary], [StdId]) VALUES (204, N'Neha', N'Bhayendar,Mumbai', 100000, 101)
INSERT [dbo].[Teacher] ([TeacherId], [Name], [Address], [salary], [StdId]) VALUES (205, N'Riya', N'Mira road,Mumbai', 20000, 102)
INSERT [dbo].[Teacher] ([TeacherId], [Name], [Address], [salary], [StdId]) VALUES (206, N'Pooja', N'Kandevali,Mumbai', 300000, 103)
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_emp_fullname]    Script Date: 23-04-2025 15:11:06 ******/
CREATE NONCLUSTERED INDEX [idx_emp_fullname] ON [dbo].[Employees]
(
	[FullName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_EmployeeID]    Script Date: 23-04-2025 15:11:06 ******/
CREATE NONCLUSTERED INDEX [idx_EmployeeID] ON [dbo].[Employees]
(
	[RegId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_EmployeeIDName]    Script Date: 23-04-2025 15:11:06 ******/
CREATE NONCLUSTERED INDEX [idx_EmployeeIDName] ON [dbo].[Employees]
(
	[RegId] ASC,
	[FullName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_unique_email]    Script Date: 23-04-2025 15:11:06 ******/
CREATE UNIQUE NONCLUSTERED INDEX [idx_unique_email] ON [dbo].[Employees]
(
	[EmailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ__UserProf__1788CCADA7373E2E]    Script Date: 23-04-2025 15:11:06 ******/
ALTER TABLE [dbo].[UserProfiles] ADD UNIQUE NONCLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Division]  WITH CHECK ADD FOREIGN KEY([StdId])
REFERENCES [dbo].[student] ([StdId])
GO
ALTER TABLE [dbo].[Division]  WITH CHECK ADD FOREIGN KEY([TeacherId])
REFERENCES [dbo].[Teacher] ([TeacherId])
GO
ALTER TABLE [dbo].[Employee1]  WITH CHECK ADD FOREIGN KEY([DeptID])
REFERENCES [dbo].[Department1] ([DeptID])
GO
ALTER TABLE [dbo].[order]  WITH CHECK ADD FOREIGN KEY([C_ID])
REFERENCES [dbo].[Customers] ([C_ID])
GO
ALTER TABLE [dbo].[Picnic]  WITH CHECK ADD FOREIGN KEY([StdId])
REFERENCES [dbo].[Students1] ([StdId])
GO
ALTER TABLE [dbo].[StudentCourses]  WITH CHECK ADD FOREIGN KEY([CourseID])
REFERENCES [dbo].[Courses] ([CourseID])
GO
ALTER TABLE [dbo].[StudentCourses]  WITH CHECK ADD FOREIGN KEY([StudentID])
REFERENCES [dbo].[Students2] ([StudentID])
GO
ALTER TABLE [dbo].[UserProfiles]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GO
/****** Object:  StoredProcedure [dbo].[spGetEmployee]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spGetEmployee]
as
begin
CREATE TABLE #EmpDetails
(name VARCHAR(25),Gender VARCHAR(25) )  

--drop table  #EmpDetails

 
    INSERT INTO #EmpDetails (Name, Gender)
    SELECT Name, Gender
    FROM Employee_details;
	
Select * from  #EmpDetails

end
GO
/****** Object:  StoredProcedure [dbo].[spGetEmployee1]    Script Date: 23-04-2025 15:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[spGetEmployee1]
as
begin
select Name,Gender from Employee_details;
end
GO
