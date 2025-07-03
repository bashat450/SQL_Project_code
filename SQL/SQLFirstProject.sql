Use Bashat_Test10

create database Bashat_Test10;
create table student (StdId int primary key, Name varchar(50), Standard int, Address varchar(150));
insert into student (StdId, Name, Standard, Address) Values
(101, 'Neha', 12, 'Bhayendar,Mumbai'),
(102, 'Riya', 12, 'Mira road,Mumbai'),
(103, 'Pooja', 12, 'Kandevali,Mumbai');
select * from student;
create table Teacher(TeacherId int primary key, Name varchar(50), Address varchar(200), salary int, StdId int);
insert into Teacher (TeacherId, Name, Address, salary, StdId) values
(201, 'Neha','Bhayendar,Mumbai',100000,101),
(202, 'Riya','Mira road,Mumbai',20000,102),
(203, 'Pooja','Kandevali,Mumbai',300000,103);
select * from Teacher;
Update student set name='Aman' where StdId = 103;
Alter table student Add age int;
delete from Teacher where TeacherId=203;
insert into Teacher (TeacherId, Name, Address, salary, StdId) values
(204, 'Neha','Bhayendar,Mumbai',100000,101),
(205, 'Riya','Mira road,Mumbai',20000,102),
(206, 'Pooja','Kandevali,Mumbai',300000,103);

insert into student (StdId, Name, Standard, Address) Values
(104, 'Noor', 12, 'Mumbai'),
(105, 'Zeba', 12, 'Mumbai'),
(106, 'Kulsoom', 12, 'Mumbai');
alter table student drop age;
create table Division(divId int primary key identity, divName varchar(100), StdId int,TeacherId int, Foreign key(StdId) References student(StdId),
Foreign key(TeacherId) References Teacher(TeacherId));

select * from student;
select * from Division;

insert into Division(divName, StdId, TeacherId) Values 
('A',104,201),('B',105,202),
('C',106,204),('D',101,205),('E',102,206);


