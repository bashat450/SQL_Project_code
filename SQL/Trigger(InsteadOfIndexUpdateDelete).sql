Use Bashat_Test10;
create table Tb1_Customer(Id int primary key, Name varchar(50), Gender varchar(20), City varchar(50), ContactNo int);
insert into Tb1_Customer values(101, 'Bashat Parween', 'Female', 'Mumbai', 987654321);
insert into Tb1_Customer values(102, 'Ayaan Alam', 'Male', 'Muscat', 654732898);
insert into Tb1_Customer values(103, 'Nigar Alam', 'Female', 'Bihar', 987654322);
insert into Tb1_Customer values(104, 'Arslan Khan', 'Male', 'Delhi', 987654323);
insert into Tb1_Customer values(105, 'Zeba Nousheen', 'Female', 'Lucknow', 987654324);
insert into Tb1_Customer values(106, 'Alhaan Khan', 'Male', 'Aligarh', 987654325);
/*
--- Print instead of insert quiry = alert message
You are not allowed to insert data in this table !!!
(1 row affected)   === but not insert
*/
create trigger tr_Insert
on Tb1_Customer
instead of insert
as
begin
	print 'You are not allowed to insert data in this table !!!'
end
--**** drop insert trigger
drop trigger tr_Insert;

--- Not Update the value
create trigger tr_Update
on Tb1_Customer
instead of Update
as
begin
	print 'You are not allowed to update data in this table !!!';
end
 
Update Tb1_Customer set Name = 'Mysha' where Id = 105;
--**** drop Update trigger
drop trigger tr_Update; 

create trigger tr_Delete
on Tb1_Customer
instead of Delete
as
begin
	print 'You are not allowed to delete data in this table !!!';
end

delete from Tb1_Customer where id = 105;
--**** drop Drop trigger
drop trigger tr_Delete; 


create table Customer_Audit_table 
(
Audit_Id int primary key identity,
Audit_info varchar(max)
);
--- No (instead of insert) available in same table
--Someone tries to insert data in customer table at in (Customer_Audit_table)
create trigger tr_Cus_Insert
on Tb1_Customer
instead of insert
as
begin
	insert into Customer_Audit_table  values('Someone tries to insert data in customer table at : ' 
	+ cast(getdate() as nvarchar(50)));
end


create trigger tr_Cus_Update
on Tb1_Customer
instead of Update
as
begin
	insert into Customer_Audit_table  values('Someone tries to Update data in customer table at : '
	+ cast(getdate() as nvarchar(50)));
end
Update Tb1_Customer set Name = 'Mysha' where Id = 105;



create trigger tr_Cus_Delete
on Tb1_Customer
instead of Delete
as
begin
	insert into Customer_Audit_table  values('Someone tries to Delete data in customer table at : '
	+ cast(getdate() as nvarchar(50)));
end
Delete from Tb1_Customer  where Id = 105;


select * from Tb1_Customer;
select * from Customer_Audit_table;
