USE ITI

--1.Create a view that displays student full name, course name if the student has a grade more than 50. 

CREATE VIEW vstud
AS
	SELECT St_Fname+' '+St_Lname AS [full name], c.Crs_Name
	FROM Student s INNER JOIN Stud_Course st
		ON s.St_Id = st.St_Id
	INNER JOIN Course c
		ON st.Crs_Id = c.Crs_Id
	WHERE st.Grade > 50;

SELECT * FROM vstud;
----------------------------------------
--2.Create an Encrypted view that displays manager names and the topics they teach. 

CREATE VIEW vmanager
WITH ENCRYPTION
AS
	SELECT i.Ins_Name AS [manager name], t.Top_Name AS topic
	FROM Department d INNER JOIN Instructor i
		ON i.Ins_Id = d.Dept_Manager
	INNER JOIN Ins_Course ins
		ON i.Ins_Id = ins.Ins_Id
	INNER JOIN Course c
		ON ins.Crs_Id = c.Crs_Id
	INNER JOIN Topic t
		ON c.Top_Id = t.Top_Id;

SELECT * FROM vmanager;
------------------------------------------------
--3.Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department 

CREATE VIEW vinst
AS
	SELECT i.Ins_Name AS [Instructor name], d.Dept_Name AS [Department name]
	FROM Instructor i INNER JOIN Department d
		ON i.Ins_Id = d.Dept_Manager
	WHERE d.Dept_Name IN ('SD','java')
WITH CHECK OPTION;

SELECT * FROM vinst;
------------------------------------------------
/*4.Create a view “V1” that displays student data for student who lives in Alex or Cairo. 
Note: Prevent the users to run the following query 
Update V1 set st_address=’tanta’
Where st_address=’alex’;*/

CREATE VIEW v1
AS
	SELECT * 
	FROM Student
	WHERE St_Address IN ('Alex', 'Cairo')
WITH CHECK OPTION;

SELECT * FROM v1;

UPDATE v1
SET St_Address='Tanta'
WHERE St_Address = 'Alex';
------------------------------------------------
--5.Create a view that will display the project name and the number of employees work on it. “Use Company DB”
USE Company_SD;
GO

CREATE VIEW vproj
AS
	SELECT p.Pname, COUNT(w.ESSn) AS [number of employee]
	FROM Project p INNER JOIN Works_for w
		ON p.Pnumber = w.Pno
	INNER JOIN Employee e
		ON w.ESSn = e.SSN
	GROUP BY p.Pname;

SELECT * FROM vproj;
------------------------------------------------
--6.Create index on column (Hiredate) that allow u to cluster the data in table Department. What will happen?

USE ITI;
GO

CREATE CLUSTERED INDEX ind_hiredate ON department(manager_hiredate);

--(cannot use clustered cause the table have primary key and already one clustered index)


------------------------------------------------
--7.Create index that allow u to enter unique ages in student table. What will happen? 

CREATE UNIQUE INDEX unique_age ON student(ST_age);

--(cannot use unique index as there are duplicated value in age)

------------------------------------------------
--8.Using Merge statement between the following two tables [User ID, Transaction Amount]

MERGE INTO last_transactions AS t
USING daily_transactions AS s
	ON t.id = s.id
WHEN MATCHED THEN
UPDATE SET t.amount = s.amount
WHEN NOT MATCHED BY TARGET THEN
INSERT (id, amount)
VALUES (s.id, s.amount)
WHEN NOT MATCHED BY SOURCE THEN
DELETE;
------------------------------------------------