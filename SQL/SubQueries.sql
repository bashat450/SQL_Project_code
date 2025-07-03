Use BashatParween;
select * from MyEmployees;

select * from MyDepartment;
/* Sub-quiries divided into two categories
i) Scalar SubQuiries :- > , >= , < , <=, !=
ii) MultiValued SubQuiries :- In, Any & All

-- self-Contained SUBQUIRIES
*/
select e.Emp_Id,e.Emp_name,e.City from MyEmployees as e
where Emp_Id in
(select Emp_Id from MyEmployees where City = 'Hyderabad');

-- Using Sub-quiries Single Table and Order clause
select * from MyEmployees
where Emp_Id in
(select Emp_Id from MyEmployees where Salary > 30000)
order by Emp_name asc;

select * from MyEmployees
where Emp_Id in
(select Emp_Id from MyEmployees where Gender = 'Male');

select * from MyEmployees
--update MyEmployees set Salary = Salary + 2000
where Emp_Id in
(select Emp_Id from MyEmployees where City = 'Hyderabad');

select * from MyEmployees
where salary in
(select max(Salary) from MyEmployees);
--Error Because we don't use Aggregate function
select * from MyEmployees
where Salary = min(salary);

-- Using Sub-quiries in two tables
select * from MyEmployees
where Dept_Id in
(select Id from MyDepartment where Dept_Name = 'Accounts');

-------CO-RELATED SUBQUIRIES
-- If you call only inner sub-quiry it take error
--- select all code and execute output is outer sub-quiry
select * from MyEmployees as e
where e.Dept_Id in
(select d.Id from MyDepartment as d where e.Gender = 'Female');

select * from MyEmployees as e
where e.Dept_Id in
(select d.Id from MyDepartment as d where e.Salary > 3000)
order by Salary asc;

-- ii) MultiValued SubQuiries :- In, Any & All
select * from MyEmployees
where Salary in
(select Salary from MyEmployees where Emp_name = 'Ayeza Akhtar' Or Emp_name = 'Arslaan Khan');

select * from MyEmployees
where Salary  < Any
(select Salary from MyEmployees where Emp_name = 'Ayeza Akhtar' Or Emp_name = 'Arslaan Khan');

select * from MyEmployees
where Salary  < All
(select Salary from MyEmployees where Emp_name = 'Ayeza Akhtar' Or Emp_name = 'Arslaan Khan');

