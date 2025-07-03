Use BashatParween;

create table Employee_details(
Id int primary key identity , Name varchar(50), Gender varchar(20), salary int not null, City varchar(50));

insert into Employee_details values
('Ali','Male',45000,'Mumbai'),
('Neha','female',65000,'Chennai'),
('Riya','Female',55000,'Mumbai'),
('Ali','Male',75000,'Patna'),
('Armaan','Male',75000,'Patna'),
('Afzal','Male',95000,'Mumbai');

select * from Employee_details;
/*
-- ************* stored Procedure **************
-- Stored procedure is a set of SQL statements with an assigned name, 
-- which are stored in a relational database management system as a group,
-- so it can reuse and shared by multiple programs.  
*/
create procedure spGetEmployee
as
begin
select * from Employee_details;
end
Exec spGetEmployee;

--  Employee Details [Print all values]
create procedure spGetEmployeesDetails1
as
begin
select * from Employee_details;
end
-- Print Name and Gender Column
create procedure spGetEmployee1
as
begin
select Name,Gender from Employee_details;
end
--     put Single Parameter in SP
create proc spGetEmployeesByID
@id int
as
begin
select * from Employee_details where Id = @id
end
-- Put multiple parameter
create proc spGetEmployeesNAMEGENSAL
@name varchar(50),
@gender varchar(20),
@salary int
as
begin
select * from Employee_details where Name = @name and Gender = @gender and salary = @salary;
end
--  Employee Details [Print all values]
Exec spGetEmployeesDetails1;

-- Print Name and Gender Column
Exec spGetEmployee1;

--     Execute Single Parameter in SP
Execute spGetEmployeesByID  2;

-- Execute multiple parameter    Use BashatParween
exec spGetEmployeesNAMEGENSAL 'Afzal','Male',95000 ;

                                                      -- Insert Data
Alter procedure spInsertEmployeesDetails
@FullName varchar(50),
@Salary int,
@Country varchar(100),
@EmailId nvarchar(80),
@CurrentDate DateTime,
@DepId int,
@JobTitle varchar(100)
As
Begin
Insert Into Employees(FullName,Salary, Country, EmailId, CurrentDate, DepId, JobTitle) 
Values
(@FullName, @Salary, @Country, @EmailId, @CurrentDate, @DepId, @JobTitle);
End
Go

EXEC spInsertEmployeesDetails 
    @FullName = 'Hania Aamir',
    @Salary = 67000,
    @Country = 'Dehradhun',
    @EmailId = 'hania01@gmail.com',
    @CurrentDate = '2025-05-05',
    @DepId = 4,
    @JobTitle = 'Software Developer';


-- Update Values   // Alter
--         ALTER        only works if the procedure already exists.
alter proc spGetEmployeesDetails1
@id int,
@name varchar(50)
as 
begin
select Name, Salary from Employee_details where Id = @id and Name = @name;
end
exec spGetEmployeesDetails1 @id = 1,@name = 'Zeba';
/*
-- Hide Stored Procedure File
-- Db=>Bashat_Test10 > Programmability > Stored Procedures  >  dbo.spGetEmployeeHIDE
*/
create procedure spGetEmployeeHIDE
--with encryption
as                                       
begin
select * from Employee_details;
end
execute spGetEmployeeHIDE;

sp_helptext spGetEmployeesDetails1;

EXEC sp_depends 'spGetEmployeesDetails1';       --Use BashatParween


select * from Employee_details;


-- Output Parameter
create proc spGetEmployeesByGender
@Gender varchar(20),
@EmployeeCount int output
as
begin
select @EmployeeCount = Count(Id) from Employee_details
where Gender = @Gender
end
-- Declare OutPut variable
/*
Declare @TotalEmployee int
execute spGetEmployeesByGender 'male', @TotalEmployee output
select @TotalEmployee as Total_Male_Employee;
*/
Declare @TotalEmployee int
execute spGetEmployeesByGender 'Female', @TotalEmployee output
select @TotalEmployee as [Total female Employee];

