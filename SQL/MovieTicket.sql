Create database MovieTickets;
Use MovieTickets;
CREATE TABLE Users (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Password NVARCHAR(100) NOT NULL
);
Insert into Users Values('bashat@gmail.com','bashat123');

ALTER TABLE Users ADD Name NVARCHAR(100);
Update Users Set Name = 'Neha Pandey' Where Id = 2;

Create procedure SP_GetDetails
@Email nvarchar(100),
@Password nvarchar(100)
As
Begin
Select * from Users
where Email = @Email and Password = @Password
End;

Execute SP_GetDetails
@Email = 'bashat@gmail.com',
@Password = 'bashat123';

Alter procedure SP_InsertDetails
@Email nvarchar(100),
@Password nvarchar(100),
@Name nvarchar(100)
As
Begin
Insert Into Users(Email,Password,Name) Values
(@Email , @Password, @Name)
End;

Execute SP_InsertDetails 
'piya@gmail.com','piya123','Piya Agarwal';

Create procedure SP_GetAllDetails
As
Begin 
Select * from Users;
End;

Execute SP_GetAllDetails;