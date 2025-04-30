--DQL

/*1.Display (Using Union Function)
a.The name and the gender of the dependence that is gender is Female and depending on Female Employee.*/

SELECT Dependent_name AS name, d.sex
FROM Dependent d
INNER JOIN Employee e
ON d.ESSN = e.SSN
WHERE d.Sex = 'F' AND e.Sex = 'F'
UNION
SELECT Fname AS Dame, e.Sex
FROM Employee e
INNER JOIN Dependent d
ON e.SSN = d.ESSN
WHERE e.Sex = 'F' AND d.Sex = 'F';

---------------------------------------------
--b.And the male dependence that depends on Male Employee.

SELECT Dependent_name AS name, d.sex
FROM Dependent d
INNER JOIN Employee e
ON d.ESSN = e.SSN
WHERE d.Sex = 'M' AND e.Sex = 'M'
UNION
SELECT Fname AS name, e.Sex
FROM Employee e
INNER JOIN Dependent d
ON e.SSN = d.ESSN
WHERE e.Sex = 'M' AND d.Sex = 'M';
---------------------------------------------
--2.For each project, list the project name and the total hours per week (for all employees) spent on that project.

SELECT Pname, SUM(w.Hours) 
FROM Project p
LEFT JOIN Works_for w
ON p.Pnumber = w.Pno
GROUP BY Pname;
---------------------------------------------
--3.Display the data of the department which has the smallest number ofemployee ID over all department.

SELECT *
FROM Departments
WHERE dnum IN (SELECT TOP 1 dno
			  FROM Employee
			  GROUP BY dno
			  ORDER BY COUNT(ssn));
---------------------------------------------
--4.For each department, retrieve the department name and the maximum, minimum and average salary of its employees.

SELECT Dname, MAX(e.salary) AS max_salary, MIN(e.salary) AS min_salary,
AVG(e.salary) AS avg_salary
FROM Departments d
INNER JOIN Employee e
ON d.Dnum = e.Dno
GROUP BY Dname;
---------------------------------------------
--5.List the last name of all managers who have no dependents.

SELECT x.Lname 
FROM Employee x
INNER JOIN Employee y
ON y.SSN = x.Superssn
WHERE x.Superssn NOT IN (SELECT ESSN FROM Dependent);

---------------------------------------------
/*6.For each department- if its average salary is less than 
the average salary of all employees- display its number, name and number of its employees.*/

SELECT Dnum, Dname, COUNT(SSN) AS employee_num
FROM Departments d INNER JOIN Employee e ON d.Dnum = e.Dno
GROUP BY Dnum, Dname
HAVING AVG(Salary) < (SELECT AVG(salary) FROM Employee);
---------------------------------------------
/*7.display a list of employees and the projects they are working on ordered by
department and within each department, ordered alphabetically by last name, first name.*/

SELECT Fname, Lname,Pname
FROM Employee e
INNER JOIN Works_for w ON e.SSN = w.ESSn
INNER JOIN Project p ON w.Pno = p.Pnumber
ORDER BY e.Dno, Lname, Fname;
---------------------------------------------
8/Try to get the max 2 salaries using subquery

SELECT MAX(salary) AS first_salary,
	(SELECT MAX(salary)
	 FROM Employee
	 WHERE Salary NOT in (SELECT MAX(Salary)
	 FROM Employee)) AS second_salary
FROM Employee;

			--- DENSE_RANK()

WITH salaries AS (
	SELECT salary,
			DENSE_RANK() OVER (ORDER BY salary DESC ) AS salary_rank
	FROM Employee
)

SELECT 
	MAX(CASE WHEN salary_rank =1 THEN salary END) AS first_salary,
	MAX(CASE WHEN salary_rank =2 THEN salary END) AS second_salary
FROM salaries;
---------------------------------------------
--9.Get the full name of employees that is similar to any dependent name

SELECT CONCAT(e.Fname,' ', e.Lname) AS FullName 
FROM Employee e,Dependent d
WHERE e.Fname LIKE CONCAT('%', d.Dependent_name, '%')
OR e.Lname like CONCAT('%', d.Dependent_name, '%');
---------------------------------------------
--10.Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30% 

UPDATE Employee 
SET Salary = Salary+ Salary *.3
FROM employee e
INNER JOIN Works_for w ON e.SSN = w.ESSn
INNER JOIN Project p ON w.Pno = p.Pnumber
WHERE p.Pname = 'al rabwah';
---------------------------------------------
--11.Display the employee number and name if at least one of them have dependents (use exists keyword) self-study.

SELECT SSN, Fname
FROM Employee e
WHERE EXISTS (
			  SELECT 1
			  FROM Dependent d
			  WHERE e.SSN = d.ESSN);
-----------------------------------------------------------------------------------------------------------------------------------

				--DHL

/*1.In the department table insert new department called "DEPT IT" , with id 100,
employee with SSN = 112233 as a manager for this department. The start date for this manager is '1-11-2006'*/

INSERT INTO Departments
VALUES('DEPT ID', 100, 112233, '11/1/2006')
---------------------------------------------
/*2.Do what is required if you know that : Mrs.Noha Mohamed(SSN=968574) moved to be the manager of the new department (id = 100),
and they give you(your SSN =102672) her position (Dept. 20 manager) */

a.	First try to update her record in the department table
b.	Update your record to be department 20 manager.
c.	Update the data of employee number=102660 to be in your teamwork (he will be supervised by you) (your SSN =102672)

a/
UPDATE Departments
SET MGRSSN = 968574
WHERE Dnum =100

b/
UPDATE Departments SET MGRSSN = 102672 WHERE Dnum = 20

c/
UPDATE Employee
SET Superssn = 102672
WHERE SSN = 102660
---------------------------------------------
/*3.Unfortunately the company ended the contract with Mr. Kamel Mohamed (SSN=223344)
so try to delete his data from your database in case you know that you will be temporarily in his position.
Hint: (Check if Mr. Kamel has dependents, works as a department manager, 
supervises any employees or works in any projects and handle these cases).*/

			----check---

SELECT * from Employee where SSN =223344;
select * from Works_for where ESSn = 223344;
select * from Employee where Superssn = 223344;
select * from Dependent where ESSN = 223344;
select * from Departments where MGRSSN = 223344;
		  ---------

UPDATE Employee SET Superssn = 102672 WHERE Superssn = 223344;
UPDATE Departments SET MGRSSN = 102672 WHERE MGRSSN = 223344;
DELETE FROM Dependent WHERE ESSN = 223344;
DELETE FROM Works_for WHERE ESSn = 223344;
DELETE FROM Employee WHERE ssn = 223344;
------------------------------------------------------------------------------------------