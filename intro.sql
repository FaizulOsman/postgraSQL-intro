-- ################## 31-1 (Create/Delete 2 Column with Relation) ##################

-- Department Table
-- Each Department has many employee
CREATE TABLE Department(
    deptID SERIAL PRIMARY KEY,
    deptName VARCHAR(50)
);

INSERT INTO Department VALUES (1, 'IT');

DELETE FROM Department WHERE deptID = 1;

SELECT * FROM department;



-- Employee Table
-- Each Employee belongs to a department
CREATE TABLE Employee(
    empID SERIAL PRIMARY KEY,
    empName VARCHAR(50) NOT NULL,
    departmentID INT,
    CONSTRAINT fk_constraint_dept
        FOREIGN KEY (departmentID)
        REFERENCES Department(deptID)
);

INSERT INTO Employee VALUES (1, 'Abul', 1);

DELETE FROM Employee WHERE departmentID = 1;

SELECT * FROM employee;



-- ################## 31-2 (Insert/Update/Delete Multiple Data From Table) ##################
CREATE TABLE courses(
    course_id SERIAL NOT NULL,
    course_name VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    publication_date DATE
);

INSERT INTO courses (course_name, description, publication_date)
VALUES 
    ('PostgreSQL for Developers', 'A complete PostgreSQL for Developers', '2020-07-13'),
    ('PostgreSQL Administration', 'A PostgreSQL Guide for Developers', NULL),
    ('PostgreSQL High Performance', NULL, NULL),
    ('PostgreSQL BootCamp', 'Learn PostgreSQL Via BootCamp', '2013-07-11'),
    ('Mastering PostgreSQL', 'Mastering PostgreSQL in 21 Days', '2012-06-30');

UPDATE courses SET
    course_name = 'PostgreSQL For Advance',
    description = 'Complete PostgreSQL Guideline'
    WHERE course_id = 18;

UPDATE courses SET
    course_name = 'Advance',
    description = 'Complete Guideline'
    WHERE course_id > 2 AND course_id < 5;

DELETE FROM courses WHERE course_id = 3 OR course_id = 5;

SELECT * FROM courses;


-- ################## 31-3 (Different Types of Filtering and Get Data) ##################
CREATE TABLE IF NOT EXISTS departments (
    deptID SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS employees (
    empID SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    salary INTEGER NOT NULL,
    joining_date DATE NOT NULL,
    deptID INTEGER NOT NULL,
    CONSTRAINT fk_deptID
        FOREIGN KEY(deptID)
        REFERENCES departments(deptID)
);

-- Professional way to get data (Don't use * to get all)
SELECT email, name, joining_date FROM employees;

-- It will show every data only 1 time (Duplicate data will show 1 time)
SELECT DISTINCT name FROM employees;

-- Filter data with condition
SELECT * FROM employees WHERE salary > 50000 AND salary < 60000;

-- Not equal (<>)
SELECT * FROM employees WHERE email <> "oliver.watson@example.com";



-- ################## 31-4 (Filter data by Limit and Offset) ##################

-- Get Data By Name With Ascending/Descending order
SELECT * FROM employees ORDER BY name DESC;

-- limit 10 Offset 0 = first 10 data
-- limit 10 Offset 1 = data 11 t0 20
SELECT * FROM employees ORDER BY name ASC LIMIT 10 OFFSET 0;

-- Get data highest salary
SELECT * FROM employees ORDER BY salary DESC LIMIT 1;

-- Get data by third highest salary
SELECT * FROM employees ORDER BY salary DESC LIMIT 1 OFFSET 2;



-- ################## 31-5 (Search data in PostgreSQL) ##################

-- Get data by empID = (2, 3, 5)
SELECT * FROM employees WHERE empID IN (2, 3, 5);

-- Get data without empID = (2, 3, 5)
SELECT * FROM employees WHERE empID NOT IN (2, 3, 5);

-- Get data by where salary range (40000 - 50000)
SELECT * FROM employees WHERE salary BETWEEN 40000 AND 50000;

-- Search data (Case sensitive)
SELECT * FROM employees WHERE name LIKE '%ily%';    -- Find like include (Emily, Lily)
SELECT * FROM employees WHERE name LIKE 'Emily%';   -- Which will start by Emily
SELECT * FROM employees WHERE name LIKE '__ily%';   -- Third position (Emily)
SELECT * FROM employees WHERE name LIKE 'E%y';      -- Start with E end with y
SELECT * FROM employees WHERE deptID IS null;



-- ################## 31-6 (Inner Join - Get a table from multiple table) ##################
CREATE TABLE department(
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE employee(
    employee_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    department_id INT,
    job_role VARCHAR(100),
    manager_id INT,
    FOREIGN KEY (department_id) REFERENCES department(department_id)
);

-- Inner Join (Left-Right both table matter)
SELECT *
FROM employee
INNER JOIN department ON department.department_id = employee.department_id;



-- ################## 31-7 (Different Types of Join) ##################
-- Left Join (Left table priority)
SELECT *
FROM employee
LEFT JOIN department ON department.department_id = employee.department_id;

-- Right Join (Right table priority)
SELECT *
FROM employee
RIGHT JOIN department ON department.department_id = employee.department_id;

-- Full Join (Left/Right both table priority)
SELECT *
FROM employee
FULL JOIN department ON department.department_id = employee.department_id;

-- Natural Join
SELECT *
FROM employee
NATURAL JOIN department;

-- Cross Join (6*15=90 output)
SELECT *
FROM employee
CROSS JOIN department;



-- ################## 31-8 (Aggregate Function) ##################

-- Get Average/Min/Max of a column
SELECT AVG(salary) FROM employees;
SELECT MIN(salary) as Minimum FROM employees;
SELECT MAX(salary) as Maximum FROM employees;
SELECT SUM(salary) as Sum FROM employees;


-- Show Average of every data by deptID
SELECT deptID, AVG(salary) FROM employees GROUP BY deptID;

-- Show deptID, deptName, sum, count and Average of every data by deptID
SELECT d.name, AVG(e.salary), SUM(e.salary), COUNT(*) from employees AS e
FULL JOIN departments AS d on e.deptID = d.deptID
GROUP BY d.name;

-- Filtering in GROUP BY (Using HAVING)
SELECT d.name, AVG(e.salary), SUM(e.salary), COUNT(*) from employees AS e
FULL JOIN departments AS d on e.deptID = d.deptID
GROUP BY d.name HAVING AVG(e.salary) > 60000;



