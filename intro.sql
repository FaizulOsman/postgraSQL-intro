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



-- ################## 31-9 (Practice) ##################

-- TASK 3: Now Write a SQL Query to retrieve the student name course name, and credits for all enrolled courses.
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    age INT,
    gender VARCHAR(50)
);

CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50),
    credits INT
);

CREATE TABLE enrollment (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT
);

INSERT INTO students (student_id, student_name, age, gender) VALUES
    (1, 'John Doe', 20, 'Male'),
    (2, 'Jane Smith', 22, 'Female'),
    (3, 'Michael Johnson', 21, 'Male');

INSERT INTO courses (course_id, course_name, credits) VALUES
    (101, 'Mathematics', 3),
    (102, 'Computer Science', 4),
    (103, 'History', 3);

INSERT INTO enrollment (enrollment_id, student_id, course_id) VALUES
    (1, 1, 101),  -- John Doe enrolled in Mathematics
    (2, 1, 102),  -- John Doe enrolled in Computer Science
    (3, 2, 101),  -- Jane Smith enrolled in Mathematics
    (4, 3, 103);  -- Michael Johnson enrolled in History


-- SOLUTION:
SELECT s.student_name, c.course_name, c.credits
FROM students AS s
JOIN enrollment AS e ON s.student_id = e.student_id
JOIN courses AS c ON e.course_id = c.course_id;



-- TASK 4: Write an SQL query to retrieve the department name and the average salary of employees working in each department. Sort the result by the average salary in descending order.
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department_id INT
);

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50)
);

CREATE TABLE salaries (
    emp_id INT,
    salary DECIMAL(10, 2)
);

INSERT INTO employees (emp_id, emp_name, department_id) VALUES
    (1, 'John Doe', 101),
    (2, 'Jane Smith', 102),
    (3, 'Michael Johnson', 103),
    (4, 'Emily Williams', 101);

INSERT INTO departments (department_id, department_name) VALUES
    (101, 'Marketing'),
    (102, 'Finance'),
    (103, 'Engineering');

INSERT INTO salaries (emp_id, salary) VALUES
    (1, 55000.00),
    (2, 62000.50),
    (3, 71000.75),
    (4, 59000.25);

-- SOLUTION:
SELECT d.department_name, AVG(s.salary)
FROM departments AS d
JOIN employees AS e ON e.department_id = d.department_id
JOIN salaries AS s ON s.emp_id = e.emp_id
GROUP BY d.department_name
ORDER BY avg(salary) DESC;




-- TASK 5: Write an SQL query to find the total sales amount for each month along with the number of orders in that month
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2)
);

INSERT INTO orders (order_id, customer_id, order_date, total_amount) VALUES
    (101, 101, '2023-01-01', 250.00),
    (102, 2, '2023-01-02', 185.00),
    (103, 1, '2023-02-03', 500.00),
    (104, 3, '2023-02-04', 1200.00),
    (105, 2, '2023-03-05', 99.00);

-- SOLUTION:
SELECT TO_CHAR(order_date, 'Month') AS month, AVG(total_amount ), COUNT(*)
FROM orders
GROUP BY month;



-- ################## 31-10 (Sub Queries) ##################
SELECT * FROM employees WHERE salary IN (
    SELECT salary from employees WHERE name LIKE '%a%'
);

-- Retrieve data where (salary > avg(salary))
SELECT * FROM employees WHERE salary > (
    SELECT AVG(salary) FROM employees
);

-- Show avg salary for every email
SELECT email, (
    SELECT AVG(salary) FROM employees
) FROM employees;

-- Get avg salary and deptID
SELECT deptID, avgSalary FROM (
    SELECT deptID, AVG(salary) AS avgSalary FROM employees GROUP BY deptID
) AS tempTables;




-- ################## 31-11 (Views) ##################
-- Create/Save view for "get month, avg, count from orders"
CREATE VIEW order_view
AS
SELECT TO_CHAR(order_date, 'Month') AS month, AVG(total_amount ), COUNT(*)
FROM orders
GROUP BY month;

-- See saved view
SELECT * FROM order_view;