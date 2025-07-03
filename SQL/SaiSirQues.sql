Use BashatParween;
drop table Students1;
drop table Picnic;
create table Students1(StdId int Primary key identity);
insert into Students1 default values;
insert into Students1 default values;
insert into Students1 default values;
insert into Students1 default values;
insert into Students1 default values;
insert into Students1 default values;
insert into Students1 default values;
insert into Students1 default values;
insert into Students1 default values;
insert into Students1 default values;

 select * from Students1;

create table Picnic(PicId int Primary key identity ,
StdId int Foreign key references Students1(StdId));
select * from Picnic;
insert into Picnic(StdId) values(1),(2),(7),(9),(10);

--? Option 1: Using LEFT JOIN and WHERE IS NULL
--we’re picking only the students who don’t have a picnic record.
SELECT s.StdId
FROM Students1 s
LEFT JOIN Picnic p ON s.StdId = p.StdId
WHERE p.StdId IS NULL;   --filters the result to only those rows where there's no matching record in the Picnic table


--? Option 2: Using NOT IN
SELECT StdId 
FROM Students1 
WHERE StdId NOT IN (SELECT StdId FROM Picnic);


-- ? Option 3: Using NOT EXISTS
SELECT s.StdId
FROM Students1 s
WHERE NOT EXISTS (
    SELECT s.StdId           --1 
    FROM Picnic p 
    WHERE p.StdId = s.StdId
);
