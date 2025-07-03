use Bashat_Test10;
create table Employees(
RegId int Primary key identity, 
FullName varchar(50) , 
Salary int not null , 
Country varchar(100) , 
EmailId nvarchar(80),  
CurrentDate DateTime
);
select * from Employees;
insert into Employees values
('Bashat Parween',94000,'India','bashat@gmail.com', Getdate()),
('Tanveer Shaikh',34000,'India','tanveer@gmail.com', Getdate()),
('Arif Khan',44000,'India','arif@gmail.com', Getdate()),
('Narayan Pandey',54000,'India','narayan@gmail.com', Getdate()),
('Neha Pandey',64000,'India','neha@gmail.com', Getdate());

insert into Employees values
('Nikita Joshi',94000,'India','nikita@gmail.com', Getdate(),4),
('Reem Shaikh',34000,'India','reem@gmail.com', Getdate(), 4);

select FullName,salary from Employees where RegId = 1 or RegId = 2;

Create table Department(
DepId int primary key ,
DepName varchar(50) not null);
select * from Department;

 --   ON DELETE SET NULL =	If the parent row is deleted, the FK in child rows becomes NULL.
 --    ON UPDATE CASCADE   =  If the parent key is updated, the child keys are also updated.
alter table Department ADD CONSTRAINT FK_EMPDEP Foreign key(DepId) references Employees(DepId)
 ON DELETE SET NULL 	
 ON UPDATE CASCADE;  
 
 insert into Department(DepId,DepName) values 
 (6,'Developer');
 select * from Department;
 select * from Employees;


--      *************Sub queries*************
-- Scalar Subquery = [Returns a single value (one row, one column)].
SELECT FullName, Salary
FROM Employees
WHERE Salary > (
    SELECT AVG(Salary) FROM Employees
);

-- Row Subquery = [Returns a single row with multiple columns].
SELECT *
FROM Employees
WHERE RegId = (SELECT RegId FROM Employees WHERE RegId = 1)
  AND FullName = (SELECT FullName FROM Employees WHERE RegId = 1);

-- Table Subquery = [Returns multiple rows/columns, usually used with IN, EXISTS, or joined as a derived table].
--       Using IN 
SELECT FullName
FROM Employees
WHERE RegId IN (
    SELECT RegId FROM Department WHERE Country = 'India'
);
--          Using EXISTS
SELECT FullName
FROM Employees e
WHERE EXISTS (
    SELECT 1
    FROM Department d
    WHERE e.RegId = d.DepId AND d.DepName = 'HR'
);
-- Subquery in FROM clause (Derived Table / Inline View):
SELECT RegId, AVG(Salary) AS AvgSalary
FROM (
    SELECT RegId, Salary
    FROM Employees
) AS Sub
GROUP BY RegId;


select FullName,Salary from Employees 
where DepId = 
(select DepId from Department 
where DepName = 'Admin' );

--             ****************Max salary****************
select * from Employees where Salary = (select Max(Salary) from Employees);
-- Using Order By Maximim number
select TOP 3 * from Employees Order By Salary desc; 
-- Using Order By Maximim number
select TOP 3 * from Employees Order By Salary Asc; 



--                ****Joins**********   Simple Joins
select Employees.FullName, Employees.Salary,Department.DepName 
from Employees,Department where Employees.RegId = Department.DepId;

--    Inner Joins
select e.FullName, e.Salary,d.DepName 
from Employees e Inner join Department d ON e.RegId = d.DepId;
-- Left Joins
select e.FullName, e.Salary,d.DepName 
from Employees e Left join Department d ON e.RegId = d.DepId;
--Right Joins
select e.FullName, e.Salary,d.DepName 
from Employees e Right join Department d ON e.RegId = d.DepId;

-- Full Joins
select e.FullName, e.Salary,d.DepName 
from Employees e Left join Department d ON e.RegId = d.DepId
Union
select e.FullName, e.Salary,d.DepName 
from Employees e Right join Department d ON e.RegId = d.DepId;
--Full outer join
select e.FullName, e.Salary,d.DepName 
from Employees e Full Outer join Department d ON e.RegId = d.DepId;
-- Cross Join
select e.FullName,d.DepName 
from Employees e cross join Department d;

select * from Employees;
CREATE INDEX idx_EmployeeID
ON Employees(RegID);

CREATE INDEX idx_EmployeeIDName
ON Employees(RegID,FullName);

EXEC sp_helpindex 'Employees';
--Select unique records from a table by using DISTINCT keyword.
select Distinct FullName,salary, EmailId from Employees;