create database Koffee;
Use Koffee;

Create table Koffee (
Id int Primary key identity,
EmailId nvarchar(200) unique,
Date dateTime default Getdate()
);

Create Procedure GetAllRecords
As
Begin
Select * from Koffee;
End;

Execute GetAllRecords;
 
Create Procedure InsertRecords
@EmailId nvarchar(200),
@Date datetime = NULL
As
Begin 
SET NOCOUNT ON;
Insert Into Koffee(EmailId,Date) Values
(@EmailId,ISNULL(@Date,GETDATE()));
End;

Execute InsertRecords @EmailId = 'piya@gmail.com';

Create Procedure UpdateRecords
@Id int,
@EmailId nvarchar(200),
@Date datetime = NULL
As
Begin
Update Koffee
Set EmailId = @EmailId,
Date = ISNULL(@Date, GetDate())
Where Id = @Id
End;

Execute UpdateRecords @Id = 3, @EmailId = 'zeba@gmail.com';

Alter procedure SP_CheckEmail
@EmailId nvarchar(255)
As
begin 
Select * from Koffee
Where EmailId=@EmailId;
End;

Exec SP_CheckEmail @EmailId = 'bashat@gmail.com';

CREATE TABLE Reservations (
    ReservationId INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    ReservationDate DATE NOT NULL,
    ReservationTime TIME NOT NULL,
    PersonCount INT NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE()
);

CREATE PROCEDURE SP_CreateReservation
    @Name NVARCHAR(100),
    @Email NVARCHAR(100),
    @ReservationDate DATE,
    @ReservationTime TIME,
    @PersonCount INT = 1  -- Default value is 1 if not provided
AS
BEGIN
    INSERT INTO Reservations (Name, Email, ReservationDate, ReservationTime, PersonCount)
    VALUES (@Name, @Email, @ReservationDate, @ReservationTime, @PersonCount)
END;
EXEC SP_CreateReservation 
    @Name = 'Bashat Parween', 
    @Email = 'bashat@gmail.com', 
    @ReservationDate = '2025-06-10', 
    @ReservationTime = '19:00', 
    @PersonCount = 4;

CREATE TABLE ContactMessages (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100),
    Email NVARCHAR(100),
    Subject NVARCHAR(200),
    Message NVARCHAR(MAX),
    SubmittedAt DATETIME DEFAULT GETDATE()
);

CREATE PROCEDURE SP_InsertContactMessage
    @Name NVARCHAR(100),
    @Email NVARCHAR(100),
    @Subject NVARCHAR(200),
    @Message NVARCHAR(MAX)
AS
BEGIN
    INSERT INTO ContactMessages (Name, Email, Subject, Message)
    VALUES (@Name, @Email, @Subject, @Message)
END;


