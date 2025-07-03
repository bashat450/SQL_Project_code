CREATE TABLE [dbo].[Teacher](
	[Id] [int] Primary key,
	[Name] [varchar](100));

Insert Into [dbo].[Teacher] Values (501,'Mysha'),(502,'Myra'),(503,'Zyna'),(504,'Amna'),(505,'Manal');
ALTER TABLE Teacher ADD ImagePath VARCHAR(255);
UPDATE Teacher SET ImagePath = '"~\Images\1_Std.jpg"' WHERE Id = 501;
UPDATE Teacher SET ImagePath = '~/Images/2_Std.jpg' WHERE Id = 502;
UPDATE Teacher SET ImagePath = '~/Images/3_Std.jpg' WHERE Id = 503;
UPDATE Teacher SET ImagePath = '~/Images/4_Std.jpg' WHERE Id = 504;
UPDATE Teacher SET ImagePath = '~/Images/5_Std.jpg' WHERE Id = 505;

ALTER TABLE Teacher ADD PdfPath VARCHAR(255);

UPDATE Teacher SET PdfPath = '"~\PDFs\1.pdf"' WHERE Id = 501;
UPDATE Teacher SET PdfPath = '"~\PDFs\2.pdf"' WHERE Id = 502;
UPDATE Teacher SET PdfPath = '"~\PDFs\3.pdf"' WHERE Id = 503;
UPDATE Teacher SET PdfPath = '"~\PDFs\4.pdf"' WHERE Id = 504;
UPDATE Teacher SET PdfPath = '"~\PDFs\5.pdf"' WHERE Id = 505;

GO
Create Procedure [dbo].[AllTeachersDetail_SP]
As
Begin
Select * from Teacher;
End;

-- Insert New Records
Create PROCEDURE [dbo].[InsertRecords_SP]
@Id int,
@Name varchar(100),
@ImagePath varchar(255),
@PdfPath varchar(255)
AS
BEGIN
    INSERT INTO Teacher(Id, Name, ImagePath, PdfPath)
    VALUES(@Id, @Name, @ImagePath, @PdfPath)
END;

-- Update current records
Create PROCEDURE [dbo].[UpdateRecords_SP]
@Id int,
@Name varchar(100),
@ImagePath varchar(255),
@PdfPath varchar(255)
AS
BEGIN
    UPDATE Teacher SET Name = @Name, ImagePath = @ImagePath, PdfPath = @PdfPath
    WHERE Id = @Id
END;

-- Delete Some Records
GO
Create Procedure [dbo].[DeleteRecord_SP]
@Id int
As
Begin
Delete from Teacher where Id = @Id;
End;