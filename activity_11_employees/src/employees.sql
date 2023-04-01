-- CS3810: Principles of Database Systems
-- Instructor: Thyago Mota
-- Description: The employees database

-- TODO: create database employees
CREATE DATABASE employees;
\c employees

-- TODO: create table departments
CREATE TABLE departments(
    code VARCHAR(10) PRIMARY KEY NOT NULL,
    "desc" VARCHAR(100) NOT NULL
);

-- TODO: populate table departments
INSERT INTO departments VALUES 
    ('HR', 'Human Resources'),
    ('IT', 'Information Technology'),
    ('SL', 'Sales');

-- TODO: create table employees
CREATE TABLE Employees (
  id   SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  sal  DECIMAL(8, 2) NOT NULL,
  deptCode CHAR(2),
  FOREIGN KEY (deptCode) REFERENCES Departments ( code )
);

INSERT INTO employees(name,sal,deptCode) VALUES
('Sam Mai Tai',50000, 'HR'),
('James Brandy',55000,'HR'),
('Whisky Strauss',60000,'HR'),
('Romeo Curacau',65000,'IT'),
('Jose Caipirinha',65000,'IT'),
('Tony Gin and Tonic',80000,'SL'),
('Debby Derby',85000,'MK'),
('Morbid Mojito',150000,NULL);

-- TODO: populate table Employees
SELECT * FROM employees;


-- TODO: a) list all rows in Departments.
SELECT * FROM departments;

-- TODO: b) list only the codes in Departments.
SELECT code FROM departments;

-- TODO: c) list all rows in Employees.
SELECT * FROM employees;

-- TODO: d) list only the names in Employees in alphabetical order.
SELECT name FROM employees ORDER BY name;
-- we can do 
SELECT name FROM employees ORDER BY 1;

-- TODO: e) list only the names and salaries in Employees, from the highest to the lowest salary.
SELECT name, sal FROM employees ORDER BY 2 DESC;

-- TODO: f) list the cartesian product of Employees and Departments.
SELECT * FROM employees
CROSS JOIN
Departments;

-- TODO: g) do the natural join of Employees and Departments; the result should be exactly the same as the cartesian product; do you know why?
SELECT * FROM employees
NATURAL JOIN
Departments;
Because there are no common attributes

-- TODO: i) do an equi join of Employees and Departments matching the rows by Employees.deptCode and Departments.code (hint: use JOIN and the ON clause).
-- equijoin (theta join using equality)
SELECT * FROM employees A, departments B 
WHERE A.deptCode = B.code;
-- equijoin
SELECT * FROM Employees A 
INNER JOIN Departments B 
ON A.deptCode = B.code;

-- TODO: j) same as previous query but project name and salary of the employees plus the description of their departments.
SELECT A.name, A.sal, B.desc FROM Employees A NATURAL JOIN Departments B WHERE A.deptCode = B.code;
-- TODO: k) same as previous query but only the employees that earn less than 60000.
SELECT A.name, A.sal, B.desc FROM Employees A NATURAL JOIN Departments B WHERE A.deptCode = B.code AND A.sal < 60000;

-- TODO: l) same as query ‘i’  but only the employees that earn more than ‘Jose Caipirinha’.
SELECT name, sal, "desc" AS description FROM Employees A 
INNER JOIN Departments B 
ON A.deptCode = B.code AND A.sal > (SELECT sal FROM Employees A WHERE A.name = 'Jose Caipirinha');

-- TODO: m) list the left outer join of Employees and Departments (use the ON clause to match by department code); how does the result of this query differs from query ‘i’?
SELECT * FROM Employees A 
LEFT JOIN Departments B
 ON A.deptCode = B.code;
-- TODO: n) from query ‘m’, how would you do the left anti-join?
SELECT * FROM Employees A 
LEFT JOIN Departments B 
ON A.deptCode = B.code 
WHERE B.code IS NULL;

-- TODO: o) show the number of employees per department.
SELECT deptCode, COUNT(*) AS Total FROM Employees GROUP BY 1;

-- IF YOU want to show the department that do not have employees as well 
SELECT "desc", COUNT(A.deptCode) AS total 
FROM Employees A 
RIGHT JOIN Departments B 
ON A.deptCode = B.code 
GROUP BY B.code;

-- TODO: p) same as query ‘o’ but I want to see the description of each department (not just their codes).
SELECT * FROM Employees A 
FULL JOIN Departments B 
ON A.deptCode = B.code;
