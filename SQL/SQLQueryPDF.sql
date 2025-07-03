select * from Employees;
select * from department;
insert into Employees values('Tanveer Shaikh', 44000,'India','tanveeralam@gmail.com', GETDATE(), 3);
insert into Employees values('Neha Pandey', 74000,'India','pandey@gmail.com', GETDATE(), 5);


-- remove duplicate rows
--get unique values
select distinct FirstName, LastName from Employee;

-- remove duplicate column
select e.*, d.depName from Employees as e
inner join 
Department as d
on d.DepId = e.RegId;

-- 2days datas
SELECT *
FROM Employees
WHERE CAST(CurrentDate AS DATE) >= CAST(GETDATE() - 14 AS DATE);

/*
-- ****************************STUFF() Function in SQL Server
STUFF deletes a part of a string and inserts another string at a specified position.
***
Deletes 5 characters starting from position 6 (World)
Inserts 'SQL' in its place
*/
SELECT STUFF('HelloWorld', 6, 5, 'SQL') as [After using Stuff];
-- Output: HelloSQL

/*
 ********************REPLACE() Function in SQL Server
 REPLACE replaces all occurrences of a substring within a string with another substring.
 Replaces all instances of 'SQL' with 'Data'
*/

SELECT REPLACE('Welcome to SQL World', 'SQL', 'Data') as [After Removing SQL];
-- Output: Welcome to Data World


-- Aggregate function
--If same value in Both columns then **Group By*** Merge similar value and Print in Alphabetical order
-- Print total salary
select FullName, Country, SUM(Salary) as [Total salary]
from Employees
Group By FullName, Country ;
select * from Employees;


--- ******************         One to one relationship     *************
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    UserName VARCHAR(50)
);
CREATE TABLE UserProfiles (
    ProfileID INT PRIMARY KEY,
    UserID INT UNIQUE,  -- Must be UNIQUE to enforce one-to-one
    Bio VARCHAR(255),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
/*
***************           One-to-Many Relationship   *************
                      Example: Department and Employee
     One Department has many Employees
Each Employee belongs to one Department
*/
CREATE TABLE Department1 (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(100)
);

CREATE TABLE Employee1 (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(100),
    DeptID INT,  -- Foreign Key
    FOREIGN KEY (DeptID) REFERENCES Department1(DeptID)
);



/*                                    	Many-to-Many 
     Example: Students & Courses
A student can enroll in many courses
A course can have many students

--StudentCourses links the two tables.
You can store multiple entries for the same student or course.
E.g., StudentID = 1 can be linked to CourseID = 101, 102
*/
CREATE TABLE Students2 (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(100)
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100)
);

CREATE TABLE StudentCourses (
    StudentID INT,
    CourseID INT,
    PRIMARY KEY (StudentID, CourseID),  -- Composite key
    FOREIGN KEY (StudentID) REFERENCES Students2(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

/*                                           Normalization in SQL Server
✅ Eliminate data redundancy
✅ Ensure data integrity
✅ Improve data efficiency
                                    🔹 1NF – First Normal Form
	No repeating groups or arrays.
	Ram :-  Math
	Ram :-  Science

                                    🔹 2NF – Second Normal Form
No partial dependency (i.e., no attribute depends on part of a composite primary key)
                                   🔹 3NF – Third Normal Form
    Must be in 2NF


	                                                    Before Normalization:
		  StudentID | Name  | Course     | Instructor
           --------------------------------------------
           1         | John  | SQL        | Mr. Shah
           1         | John  | Java       | Mr. Mehta

                                                         After Normalization:
                     Students Table:    [🔹 1NF – First Normal Form]
					 StudentID | Name
                     -------------------
                      1         | John

                                       Courses Table:      [🔹 2NF – Second Normal Form]
					CourseID | Course     | Instructor
                       -------------------------------
                     101      | SQL        | Mr. Shah
                     102      | Java       | Mr. Mehta
 
                                          StudentCourses Table:  [🔹 3NF – Third Normal Form]
         StudentID | CourseID
          ---------------------
           1         | 101
           1         | 102

*/



/*                                            🔹 1. UNION
                 Combines results from two SELECT queries and removes duplicates.
				 Columns must be of same data type and count.




				 SELECT City FROM Customers
                   UNION
                  SELECT City FROM Suppliers;
 */
 /*                                 🔹 2. UNION All
                 Combines results from two SELECT queries and not removes duplicates.
				 Columns must be of same data type and count.  
SELECT City FROM Customers
   UNION All
SELECT City FROM Suppliers;				 

*/
/*                                🔹 3. INTERSECT
              Returns only the rows that exist in both queries (i.e., the common values).
			   Columns must be of same data type and count. 
SELECT City FROM Customers
  Intersect
SELECT City FROM Suppliers;
*/
/*                             🔹 4. EXCEPT (SQL Server's version of MINUS)
   ⚠️ In SQL Server, there is no MINUS keyword – instead, use EXCEPT.
   Returns rows from the first query that are not in the second.

SELECT City FROM Customers
EXCEPT
SELECT City FROM Suppliers;

📌 Shows cities that are in Customers but not in Suppliers
*/


/*                            Temporary Table [Temp table]
✅ Stores data temporarily during a session or procedure
✅ Is automatically deleted when the session ends (for local temp tables)
✅ Is often used to store intermediate results for processing

                               Type   |      Syntax |         Scope
                           Local Temp  |    #TempTable |    Only visible to the current session
                           Global Temp |    ##TempTable | Visible to all sessions (until all sessions using it are closed)

🛠 Why Use Temporary Tables?
To simplify complex queries

For intermediate calculations

To improve performance by breaking large queries

To test and manipulate data temporarily

📌 Quick Notes:
Temp tables are stored in tempdb.

You can add indexes, constraints, and use joins with temp tables just like regular tables.
*/
CREATE TABLE #EmployeeTemp (
    EmpID INT,
    EmpName VARCHAR(100),
    Salary DECIMAL(10, 2)
);
INSERT INTO #EmployeeTemp (EmpID, EmpName, Salary)
VALUES (1, 'Senvaj', 50000),
       (2, 'Aarya', 60000);
 SELECT * FROM #EmployeeTemp;
 --DROP TABLE #EmployeeTemp;

