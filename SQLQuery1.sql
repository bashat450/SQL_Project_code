Use [MovieBookingDB];

CREATE TABLE ContactMessages (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100),
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    Subject NVARCHAR(200),
    Message NVARCHAR(MAX),
    CreatedAt DATETIME DEFAULT GETDATE()
);
Insert Into ContactMessages(Name, Email, Phone, Subject, Message) Values 
('Bashat Parween','bashat@gmail.com','9876543221','Inquiry about movie booking',
'Hello, I would like to know more about the group booking offers for upcoming movies.');

Create Procedure GetAllDetails
As 
Begin
Select * from ContactMessages;
End;
Execute GetAllDetails;
	
CREATE PROCEDURE InsertContactMessage
    @Name NVARCHAR(100),
    @Email NVARCHAR(100),
    @Phone NVARCHAR(20),
    @Subject NVARCHAR(200),
    @Message NVARCHAR(MAX)
AS
BEGIN
    INSERT INTO ContactMessages (Name, Email, Phone, Subject, Message)
    VALUES (@Name, @Email, @Phone, @Subject, @Message)
END;
EXEC InsertContactMessage
    @Name = 'Senvaj Shaikh',
    @Email = 'senvaj@example.com',
    @Phone = '9876543210',
    @Subject = 'G-Clone Query',
    @Message = 'I would like to know how messages are stored and displayed in the G-Clone module.';
