Use BashatParween;
--Provide data into one table to another
select * from [dbo].[Student_Details];
select * into Student_Info
from [dbo].[Student_Details];
go
Student_Info;


DBCC HELP('?');
GO


DBCC CHECKDB ('BashatParween') ;
GO
/*
Checks - There are no overlapping allocations (same page used by more than one object).
You're troubleshooting errors related to space, extents, or pages.
*/
DBCC CHECKALLOC;
GO
--1. NO_INFOMSGS — Suppress all “informational” messages:
DBCC CHECKDB ('BashatParween') WITH NO_INFOMSGS;
GO
--2. ALL_ERRORMSGS — Show all error messages (not just a summary):
DBCC CHECKDB ('BashatParween') WITH ALL_ERRORMSGS;
GO
/*
-- check the status of all trace flags currently enabled on your SQL Server instance.
-1 means: Show globally enabled trace flags (those affecting the whole SQL Server instance).
Without -1, it only shows trace flags enabled in the current session.*/
DBCC TRACESTATUS(-1);
Go
/* 
 the current session-level settings (also called user options) that are in effect for your SQL Server connection/session.
*/
DBCC USEROPTIONS
GO
/*
super useful when you want to monitor the size and usage of transaction log files in your databases.
a quick snapshot of all transaction log files, showing:
?How much space they take up
?How much of that space is used
?How much is still available
*/
DBCC SQLPERF('logspace');
GO

Use BashatParween
DBCC SHOWFILESTATS;
GO

Use master
DBCC SHOWFILESTATS;
GO

Use BashatParween
DBCC CHECKTABLE('[dbo].[Employees]');
GO

DBCC INPUTBUFFER(55);

/*                         ********    🔍 sp_who2
Shows all current connections/sessions to the SQL Server.

✅ Gives useful info like:

			SPID (Session Process ID)
			Status (Running, Sleeping, etc.)
			Login name
			Host name
			DB name
			Command being executed
			CPU time, Disk I/O, etc.
*/
                                   EXEC sp_who2;
/*               **********  🔍 sp_who2 'active'
🔸 What it does:
Filters the results to show only active processes (not idle).

Useful to spot long-running queries, blocked sessions, or high CPU/Disk I/O usage.
*/
                     EXEC sp_who2 'active';


----******how to find blocking?     //In    EXEC sp_who2    check  (Blk By) column 
SELECT 
    r.session_id AS BlockedSession,
    r.blocking_session_id AS BlockingSession,
    s.login_name,
    s.host_name,
    r.status,
    r.command,
    r.cpu_time,
    r.total_elapsed_time
FROM sys.dm_exec_requests r
JOIN sys.dm_exec_sessions s ON r.session_id = s.session_id
WHERE r.blocking_session_id <> 0;

/*
                       **********    🔍 Re-indexing in SQL Server
  Re-indexing is important for performance. Over time, indexes become 
    fragmented due to insert/update/delete operations.*/

--✅ Option 1: Rebuild Index (Drops and recreates index)
ALTER INDEX ALL ON [dbo].[Students2]
REBUILD;
--✅ Option 2: Reorganize Index (Defrags the index)
ALTER INDEX ALL ON [dbo].[Students2]
REORGANIZE;



/*           **********     🔍 SQL Server Agent?
✅ SQL Server Agent is a Windows service that allows you to automate and schedule tasks in SQL Server — such as:
		Backups
		Running stored procedures
		Rebuilding indexes
		Sending email alerts
		Monitoring jobs
		Data import/export

					************	🧩 Key Components of SQL Server Agent
	✅ Jobs
		A job is a collection of steps.
		Each step can run a SQL command, PowerShell script, SSIS package, etc.

	✅ Steps
		A step is a unit of work (e.g., run a stored procedure or script).

	✅ Schedules
		Defines when the job runs (daily, weekly, every 10 mins, etc.)

	✅ Alerts
		Triggers an action (like sending an email) when a specific condition is met (e.g., job failure, low disk space, error code).

	✅ Operators
		People or groups to be notified by email or pager in case of alerts.
*/
-- Create the job
EXEC msdb.dbo.sp_add_job 
    @job_name = N'Daily Backup Job';

-- Add a job step
EXEC msdb.dbo.sp_add_jobstep 
    @job_name = N'Daily Backup Job',
    @step_name = N'Backup Step',
    @subsystem = N'TSQL',
    @command = N'BACKUP DATABASE TestDB TO DISK = ''C:\Bashat_Parween\TestDB.bak'';',
    @database_name = N'BashatParween';

-- Add a schedule
EXEC msdb.dbo.sp_add_jobschedule 
    @job_name = N'Daily Backup Job',
    @name = N'Daily 1AM',
    @freq_type = 4,  -- Daily
	@freq_interval = 1, -- Important: run every 1 day
    @active_start_time = 010000; -- 1 AM

-- Add the job to the server
EXEC msdb.dbo.sp_add_jobserver 
    @job_name = N'Daily Backup Job';

/*
--                 🔍  Windows scheduler
✅ Steps to Schedule a SQL Job using Windows Task Scheduler
*/

/*    ***********  🔍 types System database in SQL? And their use?
                  ✅  Summary with Real-World Use Cases

   Database           	What It's Like	                Real Use
	master		🧠 Brain of SQL Server		Holds info about databases, logins, configurations.
	model		📋 Template					Customize defaults for all new databases.
	msdb		⏰ Scheduler/Planner	    Stores job schedules, backup history, alerts.
	tempdb		🗒️ Scratchpad	            Used for temporary storage (e.g., when sorting a large query).
	Resource	🛠️ System Library	        Internal use for system procedures and views.

*/

/*     ************* 🔍   How to find last SQL server restart time?
✅ Ways to Find Last SQL Server Restart Time
🔹 1. Using sys.dm_os_sys_info        */

SELECT sqlserver_start_time AS [SQL Server Restart Time]
FROM sys.dm_os_sys_info;

--🔹 2. Using tempdb Creation Time
SELECT create_date AS [SQL Server Restart Time]
FROM sys.databases
WHERE name = 'tempdb';

--🔹 3. Using Event Log (for Windows servers)
EXEC xp_readerrorlog 0, 1, N'SQL Server is starting';
EXEC xp_readerrorlog 0, 1, N'Server process ID is';

--How to find the duplicate command using group by and row numbering? 
--✅ 1. Using GROUP BY with HAVING
select * from Employees;
SELECT FullName, Country, COUNT(*) AS CountOfDuplicates
FROM Employees
GROUP BY FullName, Country
HAVING COUNT(*) > 1;

--✅ 2. Using ROW_NUMBER() to Get All Duplicate Rows
WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY FullName, Country ORDER BY RegId) AS rn
    FROM Employees
)
SELECT *
FROM CTE
WHERE rn > 1;
--Delete Duplicates with ROW_NUMBER()
WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY FullName, Country ORDER BY RegId) AS rn
    FROM Employees
)
DELETE FROM CTE WHERE rn > 1;

/*
---                    ********      🔍    what is use of row_number in sql
The ROW_NUMBER() function in SQL Server is a window function that assigns a unique, 
sequential integer (row number) to each row within a partition of a result set. 
The numbering of rows is based on the order specified by the ORDER BY clause.

1. Assigning a Unique Identifier to Each Row (Within Partitions)*/
SELECT RegId, FullName, Country,
       ROW_NUMBER() OVER (PARTITION BY FullName ORDER BY RegId) AS RowNum
FROM Employees;

/*         ***********   🔍  Difference between Store procedure and view?
         ⚖️ Summary Table:
        Feature |               Stored Procedure                    |            View
	 Definition |       A stored procedure is a precompiled SQL     |     A view is a virtual table
	                    statement or group of statements            |     created by a SELECT query
	Purpose     |  Execute SQL statements, modify data, handle logic|   Simplify data retrieval, present data 
	                                                                |    in a certain format
Can modify data?|    Yes, it can perform INSERT, UPDATE, DELETE     |  No (except for simple views on a single table)
Accepts parameters?|                   Yes                          |               No
Transaction management? | Yes, can handle BEGIN, COMMIT, ROLLBACK   |               No
Flexibility |        High, can perform complex operations and logic |     Low, mainly for querying data
Performance |           Optimized due to precompilation and caching |  Can cause performance issues with complex queries


*/

/*                   ******** 🔍 what is acid property?
The ACID properties are a set of principles that ensure the reliability and integrity of database transactions in
SQL Server and other relational database management systems (RDBMS). These properties are essential for ensuring that
database transactions are processed reliably, even in the event of system crashes, hardware failures, or power outages.

ACID Property Summary:

Property	Explanation
Atomicity	Ensures the transaction is fully completed or not executed at all (no partial transactions).
Consistency	Ensures that the database starts and ends in a valid state, adhering to defined rules (like constraints).
Isolation	Ensures that transactions are isolated from one another, preventing data inconsistencies during concurrent processing.
Durability	Ensures that once a transaction is committed, its changes are permanent and survive system failures.

*/
--i) Atomicity
BEGIN TRANSACTION;

UPDATE Account SET Balance = Balance - 100 WHERE AccountID = 1;
UPDATE Account SET Balance = Balance + 100 WHERE AccountID = 2;

-- If everything is fine, commit the transaction
COMMIT;

-- ii) Consistency
-- Example: A consistency check via a constraint
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    OrderTotal DECIMAL(10, 2) CHECK (OrderTotal >= 0)
);

-- iii) Isolation
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRANSACTION;
    -- Do some work here
COMMIT;

/*                 *******📘🔍 What is Collation in SQL Server?
✅ Collation refers to a set of rules that determine how data is sorted and compared, especially for 
character data (like strings). It affects things like:

Alphabetical order (e.g., whether A comes before a)
Case sensitivity (treating A and a as the same or different)
Accent sensitivity (treating é and e as the same or different)
Language-specific rules (sorting rules may differ between languages)

*/

/*         ************** 🔍Normalization = Data Organizing Technique
Normalization SQL Server (ya kisi bhi relational database) mein ek data organizing technique hai jiska main goal hota hai:

✅ Redundancy (duplicate data) kam karna
✅ Data integrity maintain karna
✅ Database ko efficient aur clean banana


###Normalization = Smart data design → Clean structure + Less duplication + Better relationships
*/
