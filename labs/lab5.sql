USE ITI

--1.Retrieve number of students who have a value in their age. 

SELECT * 
FROM Student
WHERE St_Age IS NOT NULL;

-----------------------------------
--2.Get all instructors Names without repetition

SELECT DISTINCT Ins_Name
FROM Instructor;
-----------------------------------
--3.Display student with the following Format (use isNull function)

SELECT St_Id AS [student id], ISNULL(St_Fname,'')+' '+ISNULL(st_lname, '') AS [student fullname]
,Dept_Name AS [department name]
FROM Student s INNER JOIN Department d
ON s.Dept_Id = d.Dept_Id;
-----------------------------------
/*4.Display instructor Name and Department Name 
Note: display all the instructors if they are attached to a department or not*/

SELECT Ins_Name, Dept_Name
FROM Instructor i LEFT JOIN Department d
ON i.Dept_Id = d.Dept_Id;
-----------------------------------
--5.Display student full name and the name of the course he is taking For only courses which have a grade 

SELECT CONCAT(st_fname,' ', St_Lname) AS [full name], c.Crs_Name
FROM Student s INNER JOIN Stud_Course st
ON s.St_Id = st.St_Id
INNER JOIN Course c 
ON st.Crs_Id = c.Crs_Id;
-----------------------------------
--6.Display number of courses for each topic name

SELECT t.Top_Name, COUNT(c.crs_id) AS [num of courses]
FROM Course c INNER JOIN Topic t
ON c.Top_Id = t.Top_Id
GROUP BY t.Top_Name;
-----------------------------------
--7.Display max and min salary for instructors

SELECT MAX(salary) AS max_salary, MIN(salary) AS min_salary
FROM Instructor;
-----------------------------------
--8.Display instructors who have salaries less than the average salary of all instructors.

SELECT *
FROM Instructor
WHERE Salary < (SELECT AVG(salary) FROM Instructor);
-----------------------------------
--9.Display the Department name that contains the instructor who receives the minimum salary.

SELECT Dept_Name
FROM Department d
INNER JOIN Instructor i ON i.Dept_Id = d.Dept_Id
WHERE Salary = (select MIN(salary) from Instructor);
----------------------------------------------------
--10.Select max two salaries in instructor table. 

SELECT TOP(2) salary, DENSE_RANK() OVER (ORDER BY salary DESC) AS ranked_salary
FROM Instructor;
------------------------------------
--11.Select instructor name and his salary but if there is no salary display instructor bonus.“use one of coalesce Function”

SELECT Ins_Name, COALESCE(CONVERT(varchar(10),salary),'bouns')
FROM Instructor;
-------------------------------------
--12.Select Average Salary for instructors 

SELECT AVG(ISNULL(salary,0)) AS avg_salary
FROM Instructor;
------------------------------------
--13.Select Student first name and the data of his supervisor 

SELECT s.St_Fname, st.*
FROM Student s
INNER JOIN Student st ON st.St_Id =s.St_super;
------------------------------------
--14.Write a query to select the highest two salaries in Each Department for instructors who have salaries.“using one of Ranking Functions”

					--DENSE_RANK()
SELECT *
FROM (
		SELECT  *,
		DENSE_RANK() OVER(PARTITION BY dept_id ORDER BY salary DESC) AS ranked_salary
		FROM Instructor) AS newtable
WHERE ranked_salary <=2;

					--ROW_NUMBER()
SELECT *
FROM (
		SELECT  *,
		ROW_NUMBER() OVER(PARTITION BY dept_id ORDER BY salary DESC) AS ranked_salary
		FROM Instructor) AS newtable
WHERE ranked_salary <=2;
------------------------------------
--15.Write a query to select a random  student from each department.  “using one of Ranking Functions”

SELECT *
FROM (
		SELECT  *,
		ROW_NUMBER() OVER(PARTITION BY dept_id ORDER BY NEWID()) AS x
		FROM Student) AS newtable
WHERE x =1;
------------------------------------------------------------------------------------------------------------

USE AdventureWorks2012

/*1.Display the SalesOrderID, ShipDate of the SalesOrderHeader table (Sales schema)
to designate SalesOrders that occurred within the period ‘7/28/2002’ and ‘7/29/2014’*/

SELECT SalesOrderID, ShipDate
FROM sales.SalesOrderHeader
WHERE OrderDate BETWEEN '7/28/2002' AND '7/29/2014'

-------------------------------------------------
--2.Display only Products(Production schema) with a StandardCost below $110.00 (show ProductID, Name only)

SELECT ProductID, Name
FROM Production.Product
WHERE StandardCost < 110;
-------------------------------------------------
--3.Display ProductID, Name if its weight is unknown

SELECT ProductID, Name
FROM Production.Product
WHERE Weight IS NULL;
-------------------------------------------------
--4.Display all Products with a Silver, Black, or Red Color

SELECT *
FROM Production.Product
WHERE Color IN ('Silver', 'Black', 'Red');
-------------------------------------------------
--5.Display any Product with a Name starting with the letter B

SELECT *
FROM Production.Product
WHERE name LIKE 'b%';
-------------------------------------------------
--6.Run the following Query

UPDATE Production.ProductDescription
SET Description = 'Chromoly steel_High of defects'
WHERE ProductDescriptionID = 3;

--Then write a query that displays any Product description with underscore value in its description.

SELECT *
FROM Production.ProductDescription
WHERE Description LIKE '%[_]%';
-------------------------------------------------
--7.Calculate sum of TotalDue for each OrderDate in Sales.SalesOrderHeader table for the period between  '7/1/2001' and '7/31/2014'

SELECT SUM(TotalDue) AS total_due, OrderDate
FROM Sales.SalesOrderHeader
GROUP BY OrderDate
HAVING OrderDate BETWEEN '7/1/2001' AND '7/31/2014';
-------------------------------------------------
--8.Display the Employees HireDate (note no repeated values are allowed)

SELECT DISTINCT HireDate
FROM HumanResources.Employee;
-------------------------------------------------
--9.Calculate the average of the unique ListPrices in the Product table

SELECT AVG(DISTINCT ListPrice)
FROM Production.Product
-------------------------------------------------
/*10.Display the Product Name and its ListPrice within the values of 100 and 120 the list
should has the following format "The [product name] is only! [List price]" 
(the list will be sorted according to its ListPrice value)*/

SELECT CONCAT( 'The ', Name, ' is Only! ',ListPrice)
FROM Production.Product
WHERE ListPrice BETWEEN 100 AND 120
ORDER BY ListPrice;
-------------------------------------------------
--11.	

/*a)Transfer the rowguid ,Name, SalesPersonID, Demographics from Sales.Store table in anewly created
table named [store_Archive]Note: Check your database to see the new table and how many rows in it?*/

SELECT rowguid, Name, SalesPersonID INTO store_Archive
FROM Sales.Store

--b)Try the previous query but without transferring the data? 

SELECT rowguid, Name, SalesPersonID INTO store_Archive1
FROM Sales.Store
WHERE 1>2
