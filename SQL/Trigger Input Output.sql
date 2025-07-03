use Bashat_Test10;
Create table Student_Details(
Id int primary key identity,
Name varchar(50) not null,
Gender varchar(20) not null,
Class int ,
Fees int);
insert into Student_Details values ('Bashat','Female',15,54000);
insert into Student_Details values ('Ali','Male',14,44000);
insert into Student_Details values ('Maheen','Female',04,34000);
insert into Student_Details values ('Hasnain','Male',12,52000);
insert into Student_Details values ('Amna','Female',10,22000);
insert into Student_Details values ('Arbaaz','Male',12,32000);
insert into Student_Details values ('Zyna','Female',13,42000);
insert into Student_Details values ('Manal','Female',14,40000);
insert into Student_Details values ('Manas','Male',08,20000);
insert into Student_Details values ('Moona','female',09,21000);
insert into Student_Details values ('Meena','female',15,29000);
/*
a trigger is a special type of stored procedure that automatically executes 
(or "fires") in response to certain events on a particular table or view.

-- Types of Triggers in SQL Server:
      1) AFTER Triggers (also called FOR Triggers)

Fired after the triggering SQL operation (INSERT, UPDATE, DELETE).

Commonly used to enforce business rules or update audit tables.

      2) INSTEAD OF Triggers

Fired instead of the triggering SQL operation.

Often used on views or when you want to customize the behavior of INSERT/UPDATE/DELETE.

     3) DDL Triggers (Data Definition Language)

Fired in response to schema-level events like CREATE, ALTER, DROP.

Used for tasks like auditing changes to the database structure.

    4) LOGON Triggers

Fired when a user logs into SQL Server.

Can be used for controlling login behavior or logging connection activity.


*/

CREATE TABLE Student_Log1 (
    Id INT Primary key identity,
    Info VARCHAR(max)
)
select * from Student_Log1;
select * from Student_Details;
/*
Trigger when inserted values
*/
create trigger trGetStudent
on Student_Details
after insert
as
begin
print 'One Row is inserted right now...';
end
--   Trigger when inserted values
create trigger trGetStudent1
on Student_Details
after insert
as
begin
print 'One Row is inserted right now...';
end
--   Trigger when inserted values
create trigger trGetStudent2
on Student_Details
after insert
as
begin
print 'One Row is inserted right now...';
end

--- Trigger only inserted values on that time...
alter trigger trGetStudent
on Student_Details
after insert
as
begin 
select * from inserted
end
/*
      If you use ALTER keyword Table also exist
      If you insert values in Student_Details 
      It can also put in Student_Log [automatically store in Student_Log)
 */
ALTER TRIGGER trGetStudent2
ON Student_Details
AFTER INSERT
AS
BEGIN
    INSERT INTO Student_Log (Id, Name, InsertedDate)
    SELECT Id, Name, GETDATE()
    FROM inserted
END

--- Trigger after Deleted the Table
---show deleted row
create TRIGGER trGetStudent3
on Student_Details
After delete
AS
BEGIN
select * from deleted
end

create TRIGGER trGetStudent4
on Student_Details
After delete
AS
BEGIN
select * from deleted
end
---show deleted row
delete from Student_Details where Id = 14;
/*
-- Double trigger
i) first trigger Student_Details
ii) second Student
*/
create trigger trGetStudentInsert1
on Student_Details
after insert
as
begin
Declare @id int
Select @id = Id from inserted
insert into Student_Log1
values('Student with id : '+cast(@id as varchar(50))+ ' is added at ' +cast(GETDATE() as varchar(50)));
end
/* Create variable    and give it a value and print
Store value in Student table
and
also Fetch in StudentLog1 table with a variable 
*/
create trigger trGetStudentInsert1
on Student_Details
after insert
as
begin
Declare @id int
Select @id = Id from inserted
insert into Student_Log1
values('Student with id : '+cast(@id as varchar(50))+ 'is added at ' +cast(GETDATE() as varchar(50)));
end

----  Some changes
alter trigger trGetStudentInsert1
on Student_Details
after insert
as
begin
Declare @id int
Select @id = Id from inserted
insert into Student_Log1
values('  Student   with   id :  '+cast(@id as varchar(50))+ '  is  added  at  ' +cast(GETDATE() as varchar(50)));
end

--Update Trigger means (One table delete and one table create)
create trigger trGetStudentUpdate
on Student_Details
after update
as 
begin
select * from inserted
select * from deleted
end

update Student_Details set Name = 'Vikas', Gender = 'Male' where id = 13;

sp_helptext trGetStudentUpdate;
select * from Student_Details;
select * from Student_Log;
select * from Student_Log1;


