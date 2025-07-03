Use Bashat_Test10;

create table MyDepartment
(
Id int primary key, 
Dept_Name varchar(50)
);

insert into MyDepartment values(2,'HR');
insert into MyDepartment values(3,'Accounts');
insert into MyDepartment values(1,'Administration');
insert into MyDepartment values(4,'Counselling');
insert into MyDepartment values(5,'Managements');
insert into MyDepartment values(6,'HR');

select * from MyDepartment;


create table MyEmployees(Emp_Id int primary key, Emp_name varchar(50), Gender varchar(20), Salary int, City varchar(50));
insert into MyEmployees values(100, 'Bashat Parween', 'Female', 25000, 'Hyderabad');
insert into MyEmployees values(101, 'Ayeza Akhtar', 'Female', 35000, 'Alhabad');
insert into MyEmployees values(102, 'Ayaan Alam', 'Male', 22000, 'Aligarh');
insert into MyEmployees values(103, 'Arslaan Khan', 'Male', 34000, 'Lucknow');
insert into MyEmployees values(104, 'Maheen Akhtar', 'Female', 56000, 'Gandhi Nangar');
insert into MyEmployees values(105, 'Perwaiz Alam', 'Male', 58000, 'Delhi');
UPDATE MyEmployees SET Dept_Id = 2 where Emp_Id = 100;
UPDATE MyEmployees SET Dept_Id = 1 where Emp_Id = 101;
UPDATE MyEmployees SET Dept_Id = 3 where Emp_Id = 102;
UPDATE MyEmployees SET Dept_Id = 4 where Emp_Id = 103;
UPDATE MyEmployees SET Dept_Id = 5 where Emp_Id = 104;
UPDATE MyEmployees SET Dept_Id = 6 where Emp_Id = 105;

select * from MyEmployees;
/*

View is a Virtual Table.
***View can be used as a Mechanism to implement ROW and COLUMN level Security
*** In view you can handle What customer see and wan't see.
---- You can control
*/


--- Merge Both Table // Print Both Table
Alter view vw_ForEmployees
As
select * from MyEmployees as E
inner join MyDepartment as D
on D.Id = E.Dept_Id;

select * from vw_ForEmployees;
--*******************************************************
--Dept_Id  And Id (One Column is Hide(Id))
create view vw_ForEmployee1
As
select A.*, B.Dept_Name from MyEmployees as A
inner join MyDepartment as B
on B.Id = A.Dept_Id;

select * from vw_ForEmployees;
select * from vw_ForEmployee1;

create view  vw_ForEmployees2
As
select A.Emp_Id, A.Emp_Name, A.Gender, A.City, A.Dept_Id, B.Dept_Name
from MyEmployees as A
inner join 
MyDepartment as B
on B.Id = A.Dept_Id;

select * from vw_ForEmployees2;
select * from vw_ForEmployee1;
--*****************************************************************
--- Print Rows
create view vw_ForEmployees3
As
select A.*, B.Dept_Name from MyEmployees as A
inner join MyDepartment as B
on B.Id = A.Dept_Id
where Dept_Name = 'HR';

select * from vw_ForEmployees3;
--- Print Rows 
create view vw_ForEmployees4
As
select A.*, B.Dept_Name from MyEmployees as A
inner join MyDepartment as B
on B.Id = A.Dept_Id
where Dept_Name = 'HR' or Dept_Name = 'Accounts';

select * from vw_ForEmployees4;
-- table Structure
sp_helptext vw_ForEmployees4;
--Calling My Employees table
create view vw_ForMyEmployees
as
select * from MyEmployees;
select * from vw_ForMyEmployees;

insert into vw_ForMyEmployees values(113, 'Areeb', 'Male',35000, 'Hyderabad', 3);
update vw_ForMyEmployees set Emp_name = 'Sufiyan' where Emp_Id = 113;