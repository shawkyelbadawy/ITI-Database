/*1.Create a stored procedure without parameters to show
the number of students per department name.[use ITI DB] */

USE ITI
GO

CREATE procedure stud
AS
	SELECT COUNT(*) AS num_of_stud ,d.Dept_Name
	FROM Student s INNER JOIN Department d
		ON s.Dept_Id = d.Dept_Id
	GROUP BY Dept_Name

stud;
--OR
EXECUTE stud;
--------------------------------------------------------
/*2.Create a stored procedure that will check for the # of employees in the project p100  if they are more
than 3 print message to the user “'The number of employees in the project p100 is 3 or more'”
if they are less display a message to the user “'The following employees work for the project p100'”
in addition to the first name and last name of each one. [Company DB] */

USE Company_SD
GO

CREATE proc proj
AS
	DECLARE @countemp int
	SELECT @countemp = COUNT(*) FROM Works_for WHERE Pno = 100
	IF @countemp >=3
		SELECT 'The number of employees in the project p100 is'+ CAST(@countemp AS varchar(5))
	ELSE 
	begin
		SELECT 'The following employees work for the project p100'
		UNION ALL
		SELECT Fname+' '+Lname AS [Full name ]
		FROM Employee e INNER JOIN Works_for w
			ON e.SSN = w.ESSn
		INNER JOIN Project p
			ON w.Pno = p.Pnumber
		WHERE p.Pnumber = 100
	end

proj;
	
--------------------------------------------------------
/*3.Create a stored procedure that will be used in case there is an old employee has left the project 
and a new one become instead of him. The procedure should take 3 parameters 
(old Emp. number, new Emp. number and the project number) and it will be used to update works_on table.[Company DB]*/

CREATE proc updateproj @oldemp int, @newemp int, @projno int
AS
	update Works_for
	set ESSn = @newemp
	FROM Employee e INNER JOIN Works_for w
		ON e.SSN = w.ESSn
	WHERE e.SSN = @oldemp AND Pno = @projno

updateproj 669955,11111,400;
--------------------------------------------------------
/*4.add column budget in project table and insert any draft values in it then 
then Create an Audit table with the following structure 
ProjectNo 	UserName 	ModifiedDate 	Budget_Old 	Budget_New 
p2 	Dbo 	2008-01-31	95000 	200000 

This table will be used to audit the update trials on the Budget column (Project table, Company DB)
Example:
If a user updated the budget column then the project number, user name that made that update,the date of
the modification and the value of the old and the new budget will be inserted into the Audit table
Note: This process will take place only if the user updated the budget column */

CREATE table audit(
pno int,
user_name varchar(30),
modified_date date,
budget_old int,
budget_new int
);

CREATE trigger t1
ON project
AFTER update
AS
	IF update(budget)
	BEGIN
		DECLARE @old int, @new int, @pno int

		SELECT @old = budget FROM deleted
		SELECT @new = budget FROM inserted
		SELECT @pno = pnumber FROM Project WHERE budget = @new
		INSERT INTO audit
		VALUES(@pno, SUSER_NAME(), GETDATE(), @old, @new)
	END

UPDATE Project
	SET budget =0000
WHERE Pnumber = 700;


SELECT * FROM audit;
--------------------------------------------------------
/*5.Create a trigger to prevent anyone from inserting a new record in the Department table [ITI DB]
“Print a message for user to tell him that he can’t insert a new record in that table” */

USE ITI
GO

CREATE trigger t2
ON department
INSTEAD OF INSERT
AS
	SELECT 'you can’t insert a new record in that table';

INSERT INTO Department (Dept_Id, Dept_Name)
VALUES (15, 'production'); 
--------------------------------------------------------
--6.Create a trigger that prevents the insertion Process for Employee table in March [Company DB].

USE Company_SD
GO

--with after 
CREATE trigger t3
ON employee
AFTER INSERT
AS
	IF month(GETDATE())=3
	BEGIN
		SELECT 'cant insert in march'
		ROLLBACK
	END;

INSERT INTO Employee (Fname, SSN)
VALUES('amr', 5555);


--with instead of 
CREATE trigger t4
ON employee
INSTEAD OF INSERT
AS
	IF MONTH(GETDATE()) != 3
		INSERT INTO Employee SELECT * from inserted
	ELSE 
		SELECT 'no insertion in march'
;

INSERT INTO Employee (Fname, SSN)
VALUES('amr', 5555);
--------------------------------------------------------	
/*7.Create a trigger on student table after insert to add Row in Student Audit table
(Server User Name , Date, Note) where note will be “[username] Insert New Row with Key=[Key Value] in table [table name]”
Server User Name		Date		Note */

use ITI
GO 

CREATE table studentaudit (
server_user_name varchar(30),
data date,
note varchar(128)
);

CREATE trigger t5
ON student
AFTER insert
AS
BEGIN
	DECLARE @username varchar(30) =suser_name(), @key int, @note varchar(128), @tablename varchar(20) = 'student'
	SELECT @key = st_id FROM inserted
	SET @note = SUSER_NAME() + ' Insert New Row with Key= '+CAST(@key AS varchar(10))+ 'in table '+@tablename
	INSERT INTO studentaudit
	VALUES(@username, GETDATE(), @note)
END;


INSERT INTO Student(St_Id, St_Fname)
VALUES(100,'awad');

SELECT * FROM studentaudit;
--------------------------------------------------------
/*8.Create a trigger on student table instead of delete to add Row in Student Audit table
(Server User Name, Date, Note) where note will be“ try to delete Row with Key=[Key Value]”*/

CREATE trigger t6
ON student 
INSTEAD OF delete
AS
	BEGIN
	DECLARE @user varchar(30) =suser_name(), @k int,@n varchar(128)
	SELECT @k = st_id FROM deleted
	SET @n = SUSER_NAME() + 'try to delete Row with Key= ' + CAST(@k AS varchar(10))
	INSERT INTO studentaudit
	VALUES (@user, GETDATE(), @n)
	END;

DELETE FROM Student
WHERE St_Id =100;

SELECT * FROM studentaudit;
--------------------------------------------------------
/*9.Display all the data from the Employee table (HumanResources Schema) 
As an XML document “Use XML Raw”. “Use Adventure works DB” 
A)	Elements
B)	Attributes*/

USE AdventureWorks2012
GO

--A/ 
SELECT * FROM HumanResources.Employee
FOR XML RAW('student');

--B/

SELECT * FROM HumanResources.Employee
FOR XML RAW('student'),elements;
--------------------------------------------------------
/*10.Display Each Department Name with its instructors. “Use ITI DB”
A)	Use XML Auto
B)	Use XML Path*/

USE ITI
GO

--A/
SELECT * FROM Department
FOR XML AUTO,elements;

--B/
SELECT * FROM Department
FOR XML PATH('department');
--------------------------------------------------------
/*11.Use the following variable to create a new table “customers” inside the company DB.
 Use OpenXML
declare @docs xml ='<customers>
              <customer FirstName="Bob" Zipcode="91126">
                     <order ID="12221">Laptop</order>
              </customer>
              <customer FirstName="Judy" Zipcode="23235">
                     <order ID="12221">Workstation</order>
              </customer>
              <customer FirstName="Howard" Zipcode="20009">
                     <order ID="3331122">Laptop</order>
              </customer>
              <customer FirstName="Mary" Zipcode="12345">
                     <order ID="555555">Server</order>
              </customer>
       </customers>' */


USE Company_SD
GO

DECLARE @docs xml ='<customers>
              <customer FirstName="Bob" Zipcode="91126">
                     <order ID="12221">Laptop</order>
              </customer>
              <customer FirstName="Judy" Zipcode="23235">
                     <order ID="12221">Workstation</order>
              </customer>
              <customer FirstName="Howard" Zipcode="20009">
                     <order ID="3331122">Laptop</order>
              </customer>
              <customer FirstName="Mary" Zipcode="12345">
                     <order ID="555555">Server</order>
              </customer>
       </customers>'

DECLARE @hdocs int

EXEC sp_xml_preparedocument @hdocs OUTPUT, @docs

SELECT * INTO customers
FROM openxml (@hdocs, '//customer')
WITH (customer_name varchar(50) '@FirstName',
		zipcode int '@Zipcode',
		orderid int 'order/@ID',
		product varchar(50) 'order' )

EXEC sp_xml_removedocument @hdocs

SELECT * FROM customers
--------------------------------------------------------
DISABLE TRIGGER ALL ON DATABASE;
ENABLE TRIGGER ALL ON DATABASE;
