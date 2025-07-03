Use Bashat_Test10;
create table Customers(C_ID int primary key identity, Name varchar(50) not null, Address varchar(max), City varchar(50));
insert into Customers values 
('Neha', 'Flora No:8','Mumbai'),
('Zeba', 'Flora No:5','Delhi'),
('Riya', 'Flora No:3','Mumbai'),
('Piya', 'Flora No:2','Lucknow'),
('Ziya', 'Flora No:9','Delhi');
Insert into Customers values ('Ruhi','Flora No:1', 'Lucknow');

create table [order]
(
O_ID int primary key,
Item varchar(50),
Quantity int ,
Price int ,
C_ID int Foreign key references Customers(C_ID)
);

Insert into [order] values 
(111,'Hardisk',2,500,3),
(222,'Ram',1,500,3),
(333,'Keyboard',3,500,2),
(444,'Mouse',2,500,3),
(555,'Speaker',4,500,1),
(666,'Pendrive',1,500,6);
Insert into [order] values (777,'USB',2,500,6);
alter table [order]
ADD Place varchar(50);

Update [order] set Price = 2500 where O_ID = 222;
Update [order] set Price = 850 where O_ID = 333;
Update [order] set Price = 500 where O_ID = 444;
Update [order] set Price = 3000 where O_ID = 555;
Update [order] set Price = 1500 where O_ID = 666;
Update [order] set Price = 5000 where O_ID = 777;

Update [order] set Quantity = 5 where O_ID = 222;
Update [order] set Quantity = 7 where O_ID = 333;
Update [order] set Quantity = 2 where O_ID = 444;
Update [order] set Quantity = 4 where O_ID = 555;
Update [order] set Quantity = 2 where O_ID = 666;
Update [order] set Quantity = 4 where O_ID = 777;

Update [order] set Place = 'Mira road' where O_ID = 111;
Update [order] set Place = 'Naya Nagar' where O_ID = 222;
Update [order] set Place = 'Ganga Complex' where O_ID = 333;
Update [order] set Place = 'Shivar garden' where O_ID = 444;
Update [order] set Place = 'Mira road' where O_ID = 555;
Update [order] set Place = 'Mira road' where O_ID = 666;
Update [order] set Place = 'Shivar garden' where O_ID = 777;

-- Aggregate Functions = calculation on set of values and
--  return a single values...
select sum(Price) as Total_Price_Of_Customer_Items from [order] ;
select max(Price) as Maximum_Price_in_Today from [order];
select min(Price) as Minimum_Price_in_Today from [order];
select avg(Price) as Avg_Price_of_Today from [order];
select count(Price) as Total_Customers_in_Today from [order];
--Single Parameter
-- **********************************Group by**************************
--    Used to group rows that have the same values in specific columns into summary rows.
--    It is typically use Aggregate Functions ...COUNT()/AVG()/AVG()/MAX()/MIN()
select Place, sum(Price) as [Total Price According to Place] from [order]
group by Place;
--Using Having Clauses with Group by Grouping
select Place, sum(Price) as [Total Price According to Place] from [order]
group by Place
having Place in ('Naya nagar');

select Place, sum(Price) as [Total Price According to Place] from [order]
group by Place
having sum(Price) > 2500 ;
--Using Where Clauses with Group by Grouping
select Place, sum(Price) as [Total Price According to Place] from [order]
where Place in ('Naya nagar')
group by Place;
-- multiple parameter
select O_ID, Place, sum(Price) as [Total Price According to Place] 
from [order]
group by O_ID,Place;
--        **************** Having CLAUSE****************
--        Filter groups of records created by GROUP BY clause.
--       Having Filters groups after aggregation.
--     (Where) Filters rows before grouping.  
--    Using Having and Where clause with Group by Grouping
select Place, sum(Price) as Total_Price 
from [order] where Place in ('Mira road','Naya nagar','Shivar garden')
group by Place
having sum(Price) >= 2500;

-- Using Where / Not in clause with Group by Grouping 
select Item, sum(Price) as [Total Price] from [order]
where Item not in ('Hardisk')
group by Item;

select Item, sum(Price) as [Total Price] from [order]
where Item not in ('Hardisk')
group by Item  
having sum(Price) > 1000;
--     ************** Cube  //RollUp************
-- Using [Cube by] =  CUBE gives all possible combinations of subtotals, including the grand total.
-- Use IS NULL to detect subtotal/grand total rows if needed in filtering.
--  Often used in reporting and OLAP (Online Analytical Processing) scenarios.
--       Grand total   ---- Aggregator operator
select Item, Place, sum(Price) as [Total Price] 
from [order]
group by cube(Item,Place);              -- Use BashatParween;
-- With Cube // Cube are same
select Item, Place, sum(Price) as [Total Price] 
from [order]
group by Item,Place with cube;
----RollUP
-- using Hierarcal order
select Item, Place, sum(Price) as [Total Price] 
from [order]
group by rollup (Item,Place);
---With Rollup after parameter
select Item, Place, sum(Price) as [Total Price] 
from [order]
group by Item,Place with rollup;




select * from Customers;
select * from [order]; 