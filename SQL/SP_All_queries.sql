Use COLLEGE;
CREATE TABLE Students (
    RollNo INT PRIMARY KEY identity, 
    Name NVARCHAR(100),
    City NVARCHAR(100),
	State NVARCHAR(100),
	Fees int,
    JoiningDate DateTime
);
Insert into students(Name, City, State, Fees, JoiningDate) values
('Bashat Parween',  'Mira road', 'Mumbai', 74000, GetDate()),
('Arif Choudry ',  'Nalla Sopara', 'Mumbai', 54000, GetDate()),
('Tanveer Sheikh',  'Malad', 'Mumbai', 44000, GetDate()),
('Narayan Pandey ', 'Bhayendar', 'Mumbai', 64000, GetDate()),
('Pooja Dubey ',  'Virar', 'Mumbai', 84000, GetDate());

Select * from students;

Select * from [dbo].[Students];

Use College;
Select * from [dbo].[Students];

-- Get All Details
Create Procedure GetAllStudentsDetails_SP
As
Begin
Select * From Students;
End
Go

Execute GetAllStudentsDetails_SP;

                       -- Insert Values in Students tables using Sp   [dbo].[InsertValuesInStudents_SP]
Create Proc InsertValuesInStudents_SP
@Name varchar(100),
@City varchar(100),
@State varchar(100),
@Fees int,
@JoiningDate DateTime
As
Begin
Insert into Students(Name, City, State, Fees, JoiningDate) 
Values
(@Name, @City, @State, @Fees, @JoiningDate);
End;
Go
 --Insert valus
Execute InsertValuesInStudents_SP 
@Name = 'Ayeza', 
@City = 'Simri BakhtiyarPur', 
@State = 'Bihar', 
@Fees = 6700, 
@JoiningDate = '2025-05-05';

-- Display All Details
Execute GetAllStudentsDetails_SP;

-- Update Students Values using SP
Create Procedure UpadateStudentValues_SP
@RollNo int,
@Name varchar(100), 
@City varchar(100), 
@State varchar(100), 
@Fees int, 
@JoiningDate DateTime
AS
Begin
Update Students
Set
Name = @Name,
City = @City,
State = @State,
Fees = @Fees,
JoiningDate = @JoiningDate
Where RollNo = @RollNo;
End;
Go

                                                --Execute Update Values
Execute UpadateStudentValues_SP
@RollNo = 2,
@Name = 'Myra',
@City = 'Vasai Road',
@State = 'UP',
@Fees = 56000,
@JoiningDate = '2025-04-05';

-- Display All Details
Execute GetAllStudentsDetails_SP;


-- Delete Student Values in SP
Create Procedure DeleteStudentValues_SP
@RollNo int
As
Begin
Delete From Students Where RollNo = @RollNo;
End;
Go

--call Delete values
Execute DeleteStudentValues_SP @RollNo = 5;

-- Display All Details
Execute GetAllStudentsDetails_SP;