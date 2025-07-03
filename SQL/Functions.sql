Use Bashat_Test10;
Go
-- Adding two number 
create function AddDigit(@num1 int, @num2 int)
returns int
As
Begin
Declare @result int;
set @result = @num1 + @num2;
return @result
END

select dbo.AddDigit(78,194) As Adding_Two_Number;

create table Employee(
Id int primary key identity, 
FirstName varchar(50) not null, 
LastName varchar(50), 
Salary int not null);
insert into Employee values('Mysha','Alam',23000);
insert into Employee values('Zyna','Alam',33000);
insert into Employee values('Amna','Khan',21000);

create table  Departments(
DepId int primary key  identity,
D_Name varchar(50));
insert into Departments values ('Admin');
insert into Departments values ('HR');
insert into Departments values ('Management');

select * from Departments;

create table Student_marks
(
RollNo int primary key,
Name varchar(50),
Science int,
Math int,
Eng int
);
alter table Student_marks Add  Average decimal ;
alter table dbo.Student_marks drop column Average ;
insert into Student_marks values(501, 'Maheen',89, 78, 97);
insert into Student_marks values(502, 'Mehjabeen',98, 68, 67);
insert into Student_marks values(503, 'Mysha',82, 70, 77);
insert into Student_marks values(504, 'Myra',81, 69, 987);
insert into Student_marks values(505, 'Moona',85, 85, 69);



create table Students
(
RollNo int Primary key,
StudentName varchar(50) );
Insert into Students values(101,'Roohi');
Insert into Students values(102,'Rooni');
Insert into Students values(103,'Pooja');
/*
User-defined Functions (UDFs) are routines that accept parameters, 
perform an action (such as a complex calculation), 
and return the result of that action as a value.
*/

/*
1. Scalar Functions
---Returns a single value (like int, varchar, etc.)
---Can be used anywhere an expression is valid (e.g., SELECT, WHERE, etc.)
*/
--take Total Student Marks
create function GetTotal(@Rollno int)
returns int
As
Begin
Declare @result int;
select @result = (Science) + (Math) + (Eng)
from Student_marks where RollNo = @Rollno;
return @result
end

select * ,dbo.GetTotal(RollNo) as [Total Student Marks] from Student_marks;
select * from Student_marks;


--take Total Student Marks
create function GetAvg(@Rollno int)
returns int
As
Begin
Declare @result int;
select @result = ((Science) + (Math) + (Eng))/3 
from Student_marks where RollNo = @Rollno;
return @result
end

select * ,dbo.GetAvg(RollNo) as [Average Of Student Marks] from Student_marks;


CREATE FUNCTION dbo.GetFullName
(
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50)
)
RETURNS VARCHAR(100)
AS
BEGIN
    RETURN (@FirstName + ' ' + @LastName)
END

SELECT dbo.GetFullName('Aman', 'Aftab') AS FullName;

/*
2. Inline Table-Valued Functions
---Returns a table.
---Body contains a single SELECT statement (no BEGIN...END block).
-- return (-----);
*/
create function GetStudentResult(@total int)
returns TABLE 
As
return
(
select * from Student_marks
where ((Science) + (Math) + (Eng)) > @total
);
Go
select * from dbo.GetStudentResult(150)

------
CREATE FUNCTION dbo.GetDept
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
select * from dbo.GetDept(1);

---****************************************************
ALTER FUNCTION dbo.GetAllStudents
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
    @DepName   VARCHAR(50),
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
select * from dbo.GetAllStudents(501);
-----------------------************************************
------------------------------------------


select * from Student_marks;
select * from Employee;
select * from Departments;


Go
create function GetAllStudent1
(
@RollNo int
)
returns @MarkSheet 
Table
(
stName  VARCHAR(50), 
RollNo  INT,
Science INT,
Math    INT,
Eng     INT,
Average DECIMAL(4,2)
)
As
Begin
-- pull name+marks and compute average in one go
DECLARE 
@percentage  DECIMAL(4,2);
DECLARE  @stName varchar(100);
select @stName = StudentName 
from Students
where RollNo = @RollNo
insert into @MarkSheet 
(
stName , RollNo , Eng , Math , Science , Average
)
select @stName , RollNo , Science , Math , Eng , @Average
from Student_marks where RollNo = @RollNo
return
end
Create FUNCTION GetAllStudent2
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
select * from dbo.GetAllStudent2(502);
