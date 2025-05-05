/*1.	Create the following tables with all the required information and load the
required data as specified in each table using insert statements[at least two rows]
1-Create it by code
2-Create a new user data type named loc with the following Criteria:
•	nchar(2)
•	default:NY 
•	create a rule for this Datatype :values in (NY,DS,KW)) and associate it to the location column */

CREATE table Department
(
DeptNO varchar(10) primary key,
DeptName varchar(20),
Location varchar(20)
);

sp_addtype Loc,'nchar(2)';

CREATE default d1 as 'NY';

create rule r1 as @x in ('NY','DS','KW');
 
 SP_bindrule r1, loc;
 SP_bindefault d1, loc;

 alter table department
 alter column location loc;

 insert into Department
 values (
 'd1','research','NY'),
 ('d2','accounting','DS'),
 ('d3','marketing','KW');

 -------------------------------------------------------------
 
 /*2.1-Create it by code
2-PK constraint on EmpNo
3-FK constraint on DeptNo
4-Unique constraint on Salary
5-EmpFname, EmpLname don’t accept null values
6-Create a rule on Salary column to ensure that it is less than 6000 */

create table employee
(
empno int primary key,
fname varchar(20) not null,
lname varchar(20) not null,
deptno varchar(10),
salary money unique,
constraint c1 foreign key (deptno) references department(deptno)
);
create rule r2 as @x < 6000
sp_bindrule r2, 'employee.salary'

INSERT INTO employee
VALUES 
(25348, 'mathew','smith','d3',2500),
(10102,'ann','jones','d3',3000);
-------------------------------------------------------------------------
--(Testing Referential Integrity)

--1-Add new employee with EmpNo =11111 In the works_on table [what will happen]

--(won't work)
INSERT INTO works_on
VALUES (11111,'p2','Clerk','2012.2.1')
------------------------------------------------
--2-Change the employee number 10102  to 11111  in the works on table [what will happen]

--(won't work)
update works_on
SET empno = 11111
WHERE empno = 10102
---------------------------
--3-Modify the employee number 10102 in the employeetable to 22222. [what will happen]

--(won't work)
UPDATE employee
SET empno = 22222
WHERE empno = 10102
----------------------------
--4-Delete the employee with id 10102

--(won't work)
DELETE employee
WHERE empno = 10102
-------------------------
--Table modification
--1-Add  TelephoneNumber column to the employee table[programmatically]

ALTER TABLE employee
ADD telephonenumber int;
-----------------------------
--2-drop this column[programmatically]

ALTER TABLE employee
DROP COLUMN telephonenumber;
------------------------------
/*2.Create the following schema and transfer the following tables to it 
a.	Company Schema 
i.	Department table (Programmatically)*/

CREATE SCHEMA company;
ALTER SCHEMA company transfer department;
-------------------------------------------------
/*b.	Human Resource Schema
i.	  Employee table (Programmatically)*/

CREATE schema HumanResources;
ALTER schema HumanResources transfer employee;
-------------------------------------------------
--3.Write query to display the constraints for the Employee table.

SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS;

-------------------------------------------------
/*4.Create Synonym for table Employee as Emp and then run the following queries and describe the results
a.	Select * from Employee
b.	Select * from [Human Resource].Employee
c.	Select * from Emp
d.	Select * from [Human Resource].Emp*/

CREATE synonym emp for humanresources.employee;

SELECT * FRom employee;		----(won't work)
Select * from HumanResource.Employee;		----(won't work)
Select * from Emp;		--(will work)
Select * from HumanResource.Emp;		----(won't work)
-----------------------------------------------------------
--5.Increase the budget of the project where the manager number is 10102 by 10%.

UPDATE company.project
SET budget = budget+ (budget*.1)
FROM company.project p INNER JOIN works_on w
ON p.projectno = w.projectno
WHERE w.empno = 10102;
-------------------------------------------------
--6.Change the name of the department for which the employee named James works.The new department name is Sales.

UPDATE company.Department
SET DeptName= 'sales'
FROM company.Department d INNER JOIN emp e
ON d.DeptNO = e.deptno
WHERE e.fname = 'james';
-------------------------------------------------
--7.Change the enter date for the projects for those employees who work 
--in project p1 and belong to department ‘Sales’. The new date is 12.12.2007.

UPDATE works_on
SET enter_data = '12/12/2007'
FROM works_on w INNER JOIN emp e
ON w.empno = e.empno
INNER JOIN company.Department d
ON e.deptno = d.DeptNO
WHERE w.projectno = 'p1' AND d.DeptName = 'sales';
----------------------------------------------------------
--8.Delete the information in the works_on table for all employees who work for the department located in KW.

DELETE FROM works_on 
FROM works_on w INNER JOIN emp e
ON w.empno = e.empno
INNER JOIN company.Department d
ON e.deptno = d.DeptNO
WHERE d.Location = 'KW';
----------------------------------------------------------
