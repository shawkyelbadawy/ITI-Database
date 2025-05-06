--1.Create a scalar function that takes date and returns Month name of that date.
CREATE FUNCTION getmonth(@d date)
RETURNS varchar(10)
begin
	RETURN month(@d)
end

SELECT dbo.getmonth(getdate())


SELECT dbo.getmonth('4-20-2024')
-----------------------------------------------------
--2.Create a multi-statements table-valued function that takes 2 integers and returns the values between them.

CREATE FUNCTION inbetween(@start int, @end int)
RETURNS @numbers TABLE (vals int)
AS
BEGIN 
	WHILE @start <= @end
	begin
		IF @start >= @end
		BREAK
		SET @start = @start +1
		INSERT INTO @numbers
		SELECT @start
	end
	RETURN
END;

SELECT * FROM inbetween(5,10);

SELECT * FROM inbetween(5,3);

SELECT * FROM inbetween(5,5);
------------------------------------------------------
--3.Create inline function that takes Student No and returns Department Name with Student full name.

CREATE FUNCTION getstud(@ID int)
RETURNS TABLE
AS
RETURN
	(
		select d.Dept_Name, St_Fname+' '+St_Lname AS fullname
		FROM Student s INNER JOIN Department d
		ON s.Dept_Id = d.Dept_Id
		WHERE s.St_Id = @ID
	);

SELECT * FROM getstud(10);

SELECT * FROM getstud(7);

SELECT * FROM getstud(3);
---------------------------------------------------------
/*4.Create a scalar function that takes Student ID and returns a message to user 
a.	If first name and Last name are null then display 'First name & last name are null'
b.	If First name is null then display 'first name is null'
c.	If Last name is null then display 'last name is null'
d.	Else display 'First name & last name are not null'*/

CREATE FUNCTION checkname(@no int)
RETURNS varchar(50)
BEGIN 
	DECLARE @msg varchar(50)
	SELECT @msg = CASE
	WHEN st_fname IS NULL AND st_lname IS NULL THEN 'first name & last name are null'
	WHEN st_fname IS NULL THEN 'first name is null'
	WHEN st_lname IS NULL THEN 'last name is null'
	ELSE 'first name & last name are not null'
	end
	FROM Student
	WHERE St_Id = @no
	RETURN @msg
end;

SELECT dbo.checkname(10);

SELECT dbo.checkname(13);

SELECT dbo.checkname(14);
-----------------------------------------------
/*5.Create inline function that takes integer which represents manager ID and
displays department name, Manager Name and hiring date*/

CREATE FUNCTION manager(@mgr_id int)
RETURNS TABLE AS RETURN 
	(SELECT i.Ins_Name AS manager_name, d.Dept_Name, d.Manager_hiredate
	FROM Instructor i INNER JOIN Department d
	ON i.Ins_Id = d.Dept_Manager
	WHERE d.Dept_Manager = @mgr_id );

SELECT * FROM manager(1);
------------------------------------------------
/*6.Create multi-statements table-valued function that takes a string
If string='first name' returns student first name
If string='last name' returns student last name 
If string='full name' returns Full Name from student table 
Note: Use “ISNULL” function*/

CREATE FUNCTION getname (@str varchar(10))
RETURNS @t TABLE (name varchar(20))
AS
BEGIN 
	IF @str = 'first name'
		INSERT INTO @t
		SELECT ISNULL(st_fname,'no name') 
		FROM student
	ELSE IF @str ='last name'
		INSERT INTO @t
		SELECT ISNULL(st_lname,'no name')
		FROM Student
	ELSE IF @str = 'full name'
		INSERT INTO @t
		SELECT ISNULL(st_fname+' '+st_lname,'no full name')
		FROM Student
	RETURN
END;

SELECT * FROM getname('first name');

SELECT * FROM getname('last name');

SELECT * FROM getname('full name');
---------------------------------------------
--7.Write a query that returns the Student No and Student first name without the last char

SELECT St_Id, substring(st_fname, 1, LEN(st_fname) -1)
FROM Student;
---------------------------------------------
--8.Wirte query to delete all grades for the students Located in SD Department 

update Stud_Course
set Grade= null
FROM Stud_Course st INNER JOIN Student s
ON st.St_Id = s.St_Id
INNER JOIN Department d
ON s.Dept_Id = d.Dept_Id
WHERE d.Dept_Name = 'SD';
------------------------------------------
