/*1.Create a cursor for Employee table that increases Employee salary by 10% 
if Salary <3000 and increases it by 20% if Salary >=3000. Use company DB*/

USE Company_SD
GO

DECLARE c1 cursor 
FOR	SELECT salary
	FROM Employee
FOR update
DECLARE @sal int
OPEN c1
FETCH c1 INTO @sal
WHILE @@FETCH_STATUS =0
BEGIN
	IF @sal >= 3000
		UPDATE Employee
			SET Salary = salary * 1.20
		WHERE current of c1
	ELSE
		UPDATE Employee
			SET salary = Salary * 1.10
		WHERE current of c1
		
	FETCH c1 INTO @sal		
END
CLOSE c1
DEALLOCATE c1;
--------------------------------------------------------
--2.Display Department name with its manager name using cursor. Use ITI DB

USE ITI
GO

DECLARE c1 cursor
FOR SELECT d.Dept_Name, i.Ins_Name
	FROM Department d INNER JOIN Instructor i
		ON d.Dept_Manager = i.Ins_Id
FOR read only

DECLARE @dname varchar(20), @mname varchar(20)
OPEN c1
FETCH c1 INTO @dname, @mname
WHILE @@FETCH_STATUS =0
BEGIN
	SELECT @dname'department name', @mname 'manager name'
	FETCH c1 INTO @dname, @mname
END
CLOSE c1
DEALLOCATE c1;
--------------------------------------------------------
--3.Try to display all students first name in one cell separated by comma. Using Cursor 

DECLARE c1 cursor
FOR SELECT St_Fname
	FROM Student
FOR read only
DECLARE @name varchar(20), @allnames varchar(300)
OPEN c1
FETCH c1 INTO @name
WHILE @@FETCH_STATUS =0
BEGIN 
	SET @allnames = CONCAT(@allnames,', ',@name)
	FETCH c1 INTO @name
END
SELECT @allnames
CLOSE c1
DEALLOCATE c1;
--------------------------------------------------------
--4.Create full, differential Backup for SD DB.

backup database SD
to disk ='D:\ITI-DataBase\Course\Backup DB\SD_DB.bak'

backup database SD
to disk ='D:\ITI-DataBase\Course\Backup DB\SD_DB DIFF.bak'
with differential;
--------------------------------------------------------

