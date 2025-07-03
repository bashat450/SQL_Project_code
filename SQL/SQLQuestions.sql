Use BashatParween;
Select * from [dbo].[Courses];
create table Student3
(
StId int primary key identity(201,1),
Firstname varchar(50),
LastName varchar(50), 
GPA decimal(5,2),
Enrollmentdate DateTime, 
Major varchar(50)
); 


create table Program
(
St_Ref_Id int primary key,
ProgramName varchar(100),
ProgramStartDate DateTime
);

create table ScholarShip
(
St_Ref_Id int,
SSAmount int,
SSDate DateTime
Foreign key(St_Ref_Id) References Program(St_Ref_Id)
);


insert into Student3 values
('Shivansh', 'Mahajan', 8.79, GETDATE(), 'Computer Science'),
('Umesh', 'Sharma', 8.44, GETDATE(), 'Mathematics'),
('Navleen', 'Kaur', 5.6, GETDATE(), 'Biology'),
('Rakesh', 'Sharma', 9.2, GETDATE(), 'Chemistry'),
('Radha', 'Sharma', 7.85, GETDATE(), 'Physics'),
('Kush', 'Kumar', 9.56, GETDATE(), 'History'),
('Prem', 'Chopra', 9.78, GETDATE(), 'English'),
('Pankaj', 'Vata', 7, GETDATE(), 'Mathematics');

insert into Program values
(201, 'Computer Science', GETDATE()),
(202, 'Mathematics', GETDATE()),
(208, 'Mathematics', GETDATE()),
(205, 'Physics', GETDATE()),
(204, 'Chemistry', GETDATE()),
(207, 'Phychology', GETDATE()),
(206, 'History', GETDATE()),
(203, 'Biology', GETDATE());

insert into ScholarShip values
(201, 5000, GETDATE()),
(202, 4500, GETDATE()),
(203, 3000, GETDATE()),
(204, 4000, GETDATE());

Select * from Student3;
Select * from Program;
Select * from ScholarShip;


---1. Write a SQL query to fetch "FIRST_NAME" from the Student table in
---upper case and use ALIAS name as STUDENT_NAME.
Select Upper(FirstName) as [First Name],
LOWER(LastName) as [Last Name]
from Student3; 

--2.Write a SQL query to fetch unique values of MAJOR Subjects from Student table.
Select Distinct Upper(Major) as [Student Profession] 
from Student3 order by Upper(Major) asc;
--    or
Select Upper(Major) from Student3 Group By(Major) order by Upper(Major) asc;

--3. Write a SQL query to print the first 3 characters of FIRST_NAME from Student table.
select SUBSTRING(FirstName, 1,3) as Student_name
from Student3
order by Firstname asc;

--4. Write a SQL query to find the position of alphabet ('a') int the first name column 'Shivansh' from Student table.
SELECT CHARINDEX('a', FirstName) AS PositionOfA
FROM Student3
WHERE FirstName = 'Shivansh';
--        //
select CharIndex('a', LastName) as Position_Of_A
from Student3
where LastName = 'Mahajan';

--5. Write a SQL query that fetches the unique values of MAJOR Subjects from Student table and print its length.
Select Major as Student_Profession,
Len(Major) as Total_Length 
from Student3 
Group By(Major)
order by Major asc;

--6. Write a SQL query to print FIRST_NAME from the Student table after replacing 'a' with 'A'.
select Replace(FirstName, 'a','A') as [Replace small *a* to Capital *A* ] 
from Student3;

--7. Write a SQL query to print the FIRST_NAME and LAST_NAME from Student table into single column COMPLETE_NAME.
select Concat(FirstName, ' ', LastName) as Full_Name from Student3;

--8. Write a SQL query to print all Student details from Student table order by FIRST_NAME Ascending and MAJOR Subject descending .
Select *
from Student3 
Order By FirstName asc, Major desc;

--9. Write a SQL query to print details of the Students with the FIRST_NAME as 'Prem' and 'Shivansh' from Student table.
Select * from Student3 where StId In(201,207);
Select * from Student3 where Firstname In('Prem','Shivansh');

--10.Write a SQL query to print details of the Students excluding FIRST_NAME as 'Prem' and 'Shivansh' from Student table.
Select * from Student3 where StId Not In(201,207);
Select * from Student3 where Firstname Not In('Prem','Shivansh');

--11.Write a SQL query to print details of the Students whose FIRST_NAME ends with 'a'.
select * from Student3 where FirstName Like '%a' ;

--12.Write an SQL query to print details of the Students whose FIRST_NAME ends with ‘a’ and contains five alphabets.
select * from Student3
Where FirstName Like '____a';

--13.Write an SQL query to print details of the Students whose GPA lies between 9.00 and 9.99.
Select * from Student3 where GPA Between 9.00 and 9.99 ;

--14. Write an SQL query to fetch the count of Students having Major Subject ‘Computer Science’.
Select Major, Count(*) as Total_Count
from Student3
where Major = 'Computer Science'
Group by Major ;

--15. Write an SQL query to fetch Students full names with GPA >= 8.5 and <= 9.5.
select Concat(FirstName, ' ', LastName) as Full_name, GPA
From Student3 Where GPA Between 8.5 and 9.5; 

--16. Write an SQL query to fetch the no. of Students for each MAJOR subject in the descending order.
select Major, Count(Major) as Total_Student_Who_Choose
from Student3 
Group By Major
Order by Count(Major) desc;

--17.Display the details of students who have received scholarships, including their names, scholarship amounts, and scholarship dates.
select s.FirstName, s.LastName , ss.* 
From Student3 s
Join
ScholarShip ss
On s.StId = ss.St_Ref_Id;

--18. Write an SQL query to show only odd rows from Student table.
select * from Student3 where StId % 2 != 0;

----19. Write an SQL query to show only even rows from Student table.
select * from Student3 where StId % 2 = 0;

--20. List all students and their scholarship amounts if they have received any. If a student has not received a scholarship, display NULL for the scholarship details.
Select s.*, ss.SSAmount From Student3 s
Left Join
ScholarShip ss
On s.StId = ss.St_Ref_Id;


--21. Write an SQL query to show the top n (say 5) records of Student table order by descending GPA.
select  Top 5(GPA) from Student3 
Order by GPA desc;

--22. Write an SQL query to determine the nth (say n=5) highest GPA from a table.
select * From Student3
Order By GPA desc
Offset 4 rows Fetch next 1 rows Only ;

--23. Write an SQL query to determine the 5th highest GPA without using LIMIT keyword.
Select * from Student3 s1
Where 4 = (Select Count(Distinct (s2.GPA))
From Student3 s2
Where s2.GPA >= s1.GPA
);

--24. Write an SQL query to fetch the list of Students with the same GPA.
select * from Student3
Where GPA IN
(
select GPA from Student3
Group By GPA
Having Count(*) > 1
);

SELECT GPA, COUNT(*) AS CountGPA
FROM Student3
GROUP BY GPA
ORDER BY CountGPA DESC;

--25. Write an SQL query to show the second highest GPA from a Student table using sub-query.
Select Max(GPA) From Student3
Where GPA Not In (select Max(GPA) from student3);

--26. Write an SQL query to show one row twice in results from a table.
select * from Student3       --Use BashatParween;
Union All
Select * from Student3;

--27. Write an SQL query to list STUDENT_ID who does not get Scholarship.
select s.StId from Student3 s
Left join
ScholarShip ss 
On s.StId = ss.St_Ref_Id
where ss.St_Ref_Id IS Null;

--28. Write an SQL query to fetch the first 50% records from a table.
Select Top(Select Count(*)/2 From Student3)
* From Student3;

--29. Write an SQL query to fetch the MAJOR subject that have less than 4 people in it.
select Major, Count(Major) as major_Count from Student3
Group By Major
Having Count(Major) < 4;

--30. Write an SQL query to show all MAJOR subject along with the number of people in there.
select Major, Count(major) as All_Major From Student3
Group By Major;

--31. Write an SQL query to show the last record from a table.
select * from Student3 
where StId = (Select Max(StId) from Student3);
     --Or
Select Top 1 *
From Student3
Order By StId Desc;

--32. Write an SQL query to fetch the first row of a table.
select Top 1 * From Student3
Order By StId asc;
    --or
select * from Student3 Where StId = (Select Min(StId) From Student3);

--33. Write an SQL query to fetch the last five records from a table.
Select Top 5 * from Student3
Order By StId Desc;
  --OR
select * from 
(Select Top 5 * from Student3 
Order By StId desc)
As subquery
Order By StId;

--34. Write an SQL query to fetch three max GPA from a table using co-related subquery.
select Top 3 * from Student3
Order By GPA desc;
--OR
select * From Student3 s1--Distinct is used to avoid Duplicate GPA
Where (Select Count(Distinct s2.GPA) From Student3 s2 
where s2.GPA > s1.GPA) < 3 ;

--35. Write an SQL query to fetch three min GPA from a table using Correlated subquery.
select * From Student3 s1
Where (
Select Count(Distinct s2.GPA)
From Student3 s2
Where s2.GPA < s1.GPA
) < 3;

--36. Write an SQL query to fetch nth max GPA from a table.
select * from Student3 s1
Where (
select Count(Distinct s2.GPA) 
From Student3 s2
Where s2.GPA > s1.GPA
) = 4 ;     --5th max 

--37. Write an SQL query to fetch MAJOR subjects along with the max GPA in each of these MAJOR subjects.
Select Major, Max(GPA) as MaxGpa From Student3
Group by Major
Order By Max(GPA) desc;

--38. Write an SQL query to fetch the names of Students who has highest GPA.
select FirstName, GPA From Student3
Where GPA = ( select Max(GPA) From Student3);

--39. Write an SQL query to show the current date and time.
select GetDate() as [Current_Date];

--40. Write a query to create a new table which consists of data and structure copied from the other table (say Student) or clone the table named Student.
select * into CloneTable From Student3;

--41. Write an SQL query to update the GPA of all the students in 'Computer Science' MAJOR subject to 7.5.
Update Student3 set GPA = 7.5 where major = 'Computer SCience';
select * From Student3 
where Major = 'Computer Science';

--42. Write an SQL query to find the average GPA for each major.
Select Major, Avg(GPA) as [Avg Of GPA] From Student3
Group By Major ;

--43. Write an SQL query to show the top 3 students with the highest GPA.
select Top 3 * From Student3
Order By GPA DESC;

--44. Write an SQL query to find the number of students in each major who have a GPA greater than 7.5.
Select Major, Count(StId) as Tota_High_GPA
From Student3 
Where GPA > 7.5 
Group by Major;

--45. Write an SQL query to find the students who have the same GPA as 'Shivansh Mahajan'.
Select * From Student3
Where GPA = (Select GPA From Student3
Where FirstName = 'Shivansh' 
And LastName = 'Mahajan'
);

