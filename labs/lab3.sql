USE Company_SD

--1/ Display the Department id, name and id and the name of its manager.

SELECT Dnum ,Dname, MGRSSN, Fname 
FROM Departments AS D
INNER JOIN employee AS E
ON E.SSN = MGRSSN ;
--------------------------------------

--2/ Display the name of the departments and the name of the projects under its control.

SELECT Dname, Pname
FROM Departments AS d
LEFT JOIN Project AS p
ON d.Dnum = p.Dnum;
--------------------------------------
--3/ Display the full data about all the dependence associated with the name of the employee they depend on him/her.

SELECT d.*, e.Fname
FROM Dependent AS d
LEFT JOIN Employee AS e
ON d.ESSN = e.SSN;
---------------------------------------
--4/ Display the Id, name and location of the projects in Cairo or Alex city.

SELECT Pnumber, Pname, Plocation
FROM Project
WHERE City = 'cairo' OR City = 'alex';
---------------------------------------
--5/ Display the Projects full data of the projects with a name starts with "a" letter.

SELECT *
FROM Project
WHERE Pname LIKE 'a%';
---------------------------------------
--6/ display all the employees in department 30 whose salary from 1000 to 2000 LE monthly

SELECT *
FROM Employee
WHERE Dno = 30
AND Salary BETWEEN 1000 AND 2000;
---------------------------------------
--7/ Retrieve the names of all employees in department 10 who works more than or equal10 hours per week on "AL Rabwah" project.

SELECT Fname
FROM Employee AS e
INNER JOIN Works_for AS w
ON e.SSN = w.ESSn
INNER JOIN Project AS p
ON w.Pno = p.Pnumber
WHERE Dno = 10
AND Hours >= 10 
AND Pname = 'AL RABWAH';
-------------------------------------
--8/ Find the names of the employees who directly supervised with Kamel Mohamed.

SELECT x.fname +' ' + x.lname AS fullname
FROM Employee x
INNER JOIN Employee y
on y.SSN = x.Superssn
WHERE y.Fname = 'kamel' AND y.Lname = 'mohamed';

      /* (ANOTHER QUERY WITH TWO STEPS)*/

SELECT SSN
FROM Employee
WHERE fname ='kamel';

SELECT fname +' '+ Lname
FROM Employee
where Superssn = 223344;
-----------------------------------------------
--9/ Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name.

SELECT Fname, Pname
FROM Employee e
LEFT JOIN Works_for w
ON e.SSN = w.ESSn
LEFT JOIN Project p
ON w.Pno = p.Pnumber
ORDER BY Pname;
---------------------------------------
/*10/ For each project located in Cairo City , find the project number, 
the controlling department name ,the department manager last name ,address and birthdate.*/

SELECT Pnumber, Dname, Lname, Address, Bdate
FROM Project p
LEFT JOIN Departments d
ON p.Dnum = d.Dnum
LEFT JOIN Employee e
ON e.SSN = d.MGRSSN
WHERE City = 'cairo';
---------------------------------------
--11/ Display All Data of the mangers.

SELECT e.*
FROM Departments d
INNER JOIN Employee e
ON d.MGRSSN = e.SSN;
----------------------------------------
--12/ Display All Employees data and the data of their dependents even if they have no dependents

SELECT *
FROM Employee e
LEFT JOIN Dependent d
ON e.SSN = d.ESSN
------------------------------------------

									   --(  DML  )


/*1.	Insert your personal data to the employee table as a new employee
in department number 30, SSN = 102672, Superssn = 112233, salary=3000.*/

INSERT INTO Employee 
VALUES ('Shawky', 'Elbadawy', 102672,'7/8/2001', 'cairo', 'M', 3000, 112233, 30);
------------------------------------------------------------------------------------
/*2.	Insert another employee with personal data your friend as new employee 
in department number 30, SSN = 102660, but don’t enter any value for salary or manager number to him.*/

INSERT INTO Employee
VALUES ('Amir', 'Helmy', 102660, '4/16/1998', 'cairo', 'M', NULL, NULL, 30);
------------------------------------------------------------------------------------
--3.	Upgrade your salary by 20 % of its last value.

UPDATE Employee
SET Salary = Salary + (Salary*.2)
WHERE SSN = 102672;
------------------------------------------------------------------------------------