Use BashatParween;

/*
An index in SQL Server is a database object that helps speed up the retrieval of rows from a table.
Think of it like an index in a book — instead of reading every page, you go directly to the page number listed.
**Improve query performance.
**Reduce the amount of data SQL Server needs to scan.
**Useful for searching, filtering, sorting, and joining operations.
*/
select * from Employees;
--CLUSTERED INDEX  --With Clustered Index on ID:  [ 1 | 2 | 3 | 4 | 5 ]
--Automatically created on the primary key unless specified otherwise.

CREATE CLUSTERED INDEX idx_Employee_Reg_id
ON Employees (RegId);

/*
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,  -- This will automatically create a CLUSTERED INDEX
    Name NVARCHAR(100),
    Age INT
);
*/

                               --View Indexes on a Table
--? Option 1: Using sp_helpindex
EXEC sp_helpindex 'Employees';
DROP INDEX idx_Employee_Reg_id ON Students;


/*
******************Non-Clustered Index
You can create multiple non-clustered indexes on a table.
Useful for searching, filtering, and joining on non-primary key columns.
*/
CREATE NONCLUSTERED INDEX idx_emp_fullname
ON Employees (FullName);


---************Unique Index
--Ensures that no duplicate values are entered in the column(s).
CREATE UNIQUE INDEX idx_unique_email
ON Employees (EmailId);



sp_helpindex 'Employees';


