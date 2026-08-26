-- ============================================================
-- COMPLETE SQL PRACTICE - BEGINNER TO ADVANCED
-- MySQL
-- ============================================================


-- ============================================================
-- 1. CREATE DATABASE
-- ============================================================

CREATE DATABASE company_db;

USE company_db;


-- ============================================================
-- 2. CREATE TABLES
-- ============================================================

CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL
);


CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    age INT,
    salary DECIMAL(10,2),
    department_id INT,
    joining_date DATE,

    FOREIGN KEY (department_id)
    REFERENCES departments(department_id)
);


-- ============================================================
-- 3. INSERT DATA
-- ============================================================

INSERT INTO departments (department_name)
VALUES
('IT'),
('HR'),
('Finance'),
('Marketing');


INSERT INTO employees
(employee_name, email, age, salary, department_id, joining_date)
VALUES
('Nisha', 'nisha@gmail.com', 22, 35000, 1, '2025-01-10'),
('Rahul', 'rahul@gmail.com', 25, 45000, 1, '2024-06-15'),
('Priya', 'priya@gmail.com', 24, 40000, 2, '2025-02-20'),
('Arjun', 'arjun@gmail.com', 28, 60000, 3, '2023-08-10'),
('Sneha', 'sneha@gmail.com', 23, 38000, 4, '2025-03-05'),
('Kiran', 'kiran@gmail.com', 30, 70000, 1, '2022-11-01');


-- ============================================================
-- 4. SELECT - READ DATA
-- ============================================================

-- Show everything
SELECT * FROM employees;

-- Select specific columns
SELECT employee_name, salary
FROM employees;

SELECT employee_name, age, salary
FROM employees;


-- ============================================================
-- 5. DISTINCT
-- ============================================================

SELECT DISTINCT department_id
FROM employees;


-- ============================================================
-- 6. WHERE
-- ============================================================

-- Salary greater than 40000
SELECT *
FROM employees
WHERE salary > 40000;

-- Salary less than 50000
SELECT *
FROM employees
WHERE salary < 50000;

-- Salary equal to 40000
SELECT *
FROM employees
WHERE salary = 40000;

-- Age greater than 25
SELECT *
FROM employees
WHERE age > 25;


-- ============================================================
-- 7. AND / OR
-- ============================================================

SELECT *
FROM employees
WHERE age > 25
AND salary > 50000;


SELECT *
FROM employees
WHERE department_id = 1
OR department_id = 2;


-- ============================================================
-- 8. BETWEEN
-- ============================================================

SELECT *
FROM employees
WHERE salary BETWEEN 40000 AND 60000;


SELECT *
FROM employees
WHERE age BETWEEN 23 AND 28;


-- ============================================================
-- 9. IN
-- ============================================================

SELECT *
FROM employees
WHERE department_id IN (1, 2, 3);


-- ============================================================
-- 10. NOT IN
-- ============================================================

SELECT *
FROM employees
WHERE department_id NOT IN (1, 2);


-- ============================================================
-- 11. LIKE
-- ============================================================

-- Name starts with N
SELECT *
FROM employees
WHERE employee_name LIKE 'N%';


-- Name ends with a
SELECT *
FROM employees
WHERE employee_name LIKE '%a';


-- Name contains i
SELECT *
FROM employees
WHERE employee_name LIKE '%i%';


-- ============================================================
-- 12. ORDER BY
-- ============================================================

-- Lowest salary first
SELECT *
FROM employees
ORDER BY salary ASC;


-- Highest salary first
SELECT *
FROM employees
ORDER BY salary DESC;


-- Highest age first
SELECT *
FROM employees
ORDER BY age DESC;


-- ============================================================
-- 13. LIMIT
-- ============================================================

SELECT *
FROM employees
LIMIT 3;


-- Top 3 highest-paid employees
SELECT *
FROM employees
ORDER BY salary DESC
LIMIT 3;


-- ============================================================
-- 14. ALIAS
-- ============================================================

SELECT
    employee_name AS name,
    salary AS monthly_salary
FROM employees;


-- ============================================================
-- 15. COUNT
-- ============================================================

SELECT COUNT(*) AS total_employees
FROM employees;


-- ============================================================
-- 16. SUM
-- ============================================================

SELECT SUM(salary) AS total_salary
FROM employees;


-- ============================================================
-- 17. AVG
-- ============================================================

SELECT AVG(salary) AS average_salary
FROM employees;


-- ============================================================
-- 18. MAX
-- ============================================================

SELECT MAX(salary) AS highest_salary
FROM employees;


-- ============================================================
-- 19. MIN
-- ============================================================

SELECT MIN(salary) AS lowest_salary
FROM employees;


-- ============================================================
-- 20. GROUP BY
-- ============================================================

-- Number of employees in each department
SELECT
    department_id,
    COUNT(*) AS employee_count
FROM employees
GROUP BY department_id;


-- Total salary by department
SELECT
    department_id,
    SUM(salary) AS total_salary
FROM employees
GROUP BY department_id;


-- Average salary by department
SELECT
    department_id,
    AVG(salary) AS average_salary
FROM employees
GROUP BY department_id;


-- ============================================================
-- 21. HAVING
-- ============================================================

-- Departments with more than 1 employee
SELECT
    department_id,
    COUNT(*) AS employee_count
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 1;


-- Departments with average salary above 40000
SELECT
    department_id,
    AVG(salary) AS average_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 40000;


-- ============================================================
-- 22. INNER JOIN
-- ============================================================

SELECT
    e.employee_name,
    e.salary,
    d.department_name
FROM employees e
INNER JOIN departments d
ON e.department_id = d.department_id;


-- ============================================================
-- 23. LEFT JOIN
-- ============================================================

SELECT
    e.employee_name,
    e.salary,
    d.department_name
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id;


-- ============================================================
-- 24. RIGHT JOIN
-- ============================================================

SELECT
    e.employee_name,
    d.department_name
FROM employees e
RIGHT JOIN departments d
ON e.department_id = d.department_id;


-- ============================================================
-- 25. JOIN + WHERE
-- ============================================================

-- Employees working in IT
SELECT
    e.employee_name,
    e.salary,
    d.department_name
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
WHERE d.department_name = 'IT';


-- ============================================================
-- 26. JOIN + ORDER BY
-- ============================================================

SELECT
    e.employee_name,
    e.salary,
    d.department_name
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
ORDER BY e.salary DESC;


-- ============================================================
-- 27. FIND EMPLOYEES WITHOUT DEPARTMENT
-- ============================================================

SELECT e.*
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id
WHERE d.department_id IS NULL;


-- ============================================================
-- 28. NULL
-- ============================================================

SELECT *
FROM employees
WHERE email IS NULL;


SELECT *
FROM employees
WHERE email IS NOT NULL;


-- ============================================================
-- 29. CASE
-- ============================================================

SELECT
    employee_name,
    salary,

    CASE
        WHEN salary >= 60000 THEN 'High Salary'
        WHEN salary >= 40000 THEN 'Medium Salary'
        ELSE 'Low Salary'
    END AS salary_category

FROM employees;


-- ============================================================
-- 30. STRING FUNCTIONS
-- ============================================================

-- Uppercase
SELECT
    employee_name,
    UPPER(employee_name) AS uppercase_name
FROM employees;


-- Lowercase
SELECT
    employee_name,
    LOWER(employee_name) AS lowercase_name
FROM employees;


-- Name length
SELECT
    employee_name,
    LENGTH(employee_name) AS name_length
FROM employees;


-- Combine name and email
SELECT
    CONCAT(employee_name, ' - ', email) AS employee_details
FROM employees;


-- ============================================================
-- 31. DATE FUNCTIONS
-- ============================================================

-- Current date
SELECT CURDATE();


-- Current date and time
SELECT NOW();


-- Show joining year
SELECT
    employee_name,
    YEAR(joining_date) AS joining_year
FROM employees;


-- Show joining month
SELECT
    employee_name,
    MONTH(joining_date) AS joining_month
FROM employees;


-- Employees who joined after January 1, 2025
SELECT *
FROM employees
WHERE joining_date >= '2025-01-01';


-- ============================================================
-- 32. SUBQUERY
-- ============================================================

-- Employees earning more than average salary
SELECT *
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);


-- ============================================================
-- 33. HIGHEST SALARY
-- ============================================================

SELECT MAX(salary) AS highest_salary
FROM employees;


-- Employee with highest salary
SELECT *
FROM employees
WHERE salary = (
    SELECT MAX(salary)
    FROM employees
);


-- ============================================================
-- 34. SECOND HIGHEST SALARY
-- ============================================================

SELECT MAX(salary) AS second_highest_salary
FROM employees
WHERE salary < (
    SELECT MAX(salary)
    FROM employees
);


-- Another method
SELECT DISTINCT salary
FROM employees
ORDER BY salary DESC
LIMIT 1 OFFSET 1;


-- ============================================================
-- 35. THIRD HIGHEST SALARY
-- ============================================================

SELECT DISTINCT salary
FROM employees
ORDER BY salary DESC
LIMIT 1 OFFSET 2;


-- ============================================================
-- 36. CTE
-- ============================================================

WITH high_salary AS (

    SELECT *
    FROM employees
    WHERE salary > 40000

)

SELECT *
FROM high_salary;


-- CTE + GROUP BY
WITH department_salary AS (

    SELECT
        department_id,
        AVG(salary) AS average_salary

    FROM employees

    GROUP BY department_id

)

SELECT *
FROM department_salary
WHERE average_salary > 40000;


-- ============================================================
-- 37. ROW_NUMBER
-- ============================================================

SELECT
    employee_name,
    salary,

    ROW_NUMBER() OVER (
        ORDER BY salary DESC
    ) AS row_number

FROM employees;


-- ============================================================
-- 38. RANK
-- ============================================================

SELECT
    employee_name,
    salary,

    RANK() OVER (
        ORDER BY salary DESC
    ) AS salary_rank

FROM employees;


-- ============================================================
-- 39. DENSE_RANK
-- ============================================================

SELECT
    employee_name,
    salary,

    DENSE_RANK() OVER (
        ORDER BY salary DESC
    ) AS salary_rank

FROM employees;


-- ============================================================
-- 40. RANK WITHIN EACH DEPARTMENT
-- ============================================================

SELECT
    employee_name,
    department_id,
    salary,

    RANK() OVER (
        PARTITION BY department_id
        ORDER BY salary DESC
    ) AS department_rank

FROM employees;


-- ============================================================
-- 41. TOP 3 EMPLOYEES IN EACH DEPARTMENT
-- ============================================================

SELECT *
FROM (

    SELECT
        employee_name,
        department_id,
        salary,

        ROW_NUMBER() OVER (
            PARTITION BY department_id
            ORDER BY salary DESC
        ) AS rn

    FROM employees

) AS ranked_employees

WHERE rn <= 3;


-- ============================================================
-- 42. UPDATE
-- ============================================================

UPDATE employees
SET salary = 40000
WHERE employee_name = 'Nisha';


-- Check result
SELECT *
FROM employees
WHERE employee_name = 'Nisha';


-- ============================================================
-- 43. UPDATE MULTIPLE RECORDS
-- ============================================================

UPDATE employees
SET salary = salary + 5000
WHERE department_id = 1;


-- ============================================================
-- 44. DELETE
-- ============================================================

-- Example:
-- DELETE FROM employees
-- WHERE employee_name = 'Nisha';


-- ============================================================
-- 45. ALTER TABLE - ADD COLUMN
-- ============================================================

ALTER TABLE employees
ADD phone_number VARCHAR(15);


-- ============================================================
-- 46. ALTER TABLE - MODIFY COLUMN
-- ============================================================

ALTER TABLE employees
MODIFY phone_number VARCHAR(20);


-- ============================================================
-- 47. ALTER TABLE - DROP COLUMN
-- ============================================================

ALTER TABLE employees
DROP COLUMN phone_number;


-- ============================================================
-- 48. CREATE VIEW
-- ============================================================

CREATE VIEW employee_details AS

SELECT
    e.employee_id,
    e.employee_name,
    e.email,
    e.salary,
    d.department_name

FROM employees e

JOIN departments d
ON e.department_id = d.department_id;


-- Read the view
SELECT *
FROM employee_details;


-- ============================================================
-- 49. INDEX
-- ============================================================

CREATE INDEX idx_employee_email
ON employees(email);


-- Check indexes
SHOW INDEX FROM employees;


-- ============================================================
-- 50. TRANSACTION
-- ============================================================

START TRANSACTION;

UPDATE employees
SET salary = salary + 1000
WHERE department_id = 1;

-- If everything is correct:
COMMIT;

-- If something went wrong instead:
-- ROLLBACK;


-- ============================================================
-- 51. PRACTICAL DATA ANALYST QUERIES
-- ============================================================


-- Q1. Total employees
SELECT COUNT(*) AS total_employees
FROM employees;


-- Q2. Average salary
SELECT AVG(salary) AS average_salary
FROM employees;


-- Q3. Highest salary
SELECT MAX(salary) AS highest_salary
FROM employees;


-- Q4. Lowest salary
SELECT MIN(salary) AS lowest_salary
FROM employees;


-- Q5. Total salary
SELECT SUM(salary) AS total_salary
FROM employees;


-- Q6. Employees earning more than 50000
SELECT *
FROM employees
WHERE salary > 50000;


-- Q7. Employees earning between 40000 and 60000
SELECT *
FROM employees
WHERE salary BETWEEN 40000 AND 60000;


-- Q8. Employees whose name starts with A
SELECT *
FROM employees
WHERE employee_name LIKE 'A%';


-- Q9. Highest-paid employee
SELECT *
FROM employees
ORDER BY salary DESC
LIMIT 1;


-- Q10. Top 3 highest-paid employees
SELECT *
FROM employees
ORDER BY salary DESC
LIMIT 3;


-- Q11. Number of employees in each department
SELECT
    department_id,
    COUNT(*) AS employee_count
FROM employees
GROUP BY department_id;


-- Q12. Average salary by department
SELECT
    department_id,
    AVG(salary) AS average_salary
FROM employees
GROUP BY department_id;


-- Q13. Total salary by department
SELECT
    department_id,
    SUM(salary) AS total_salary
FROM employees
GROUP BY department_id;


-- Q14. Departments having more than 1 employee
SELECT
    department_id,
    COUNT(*) AS employee_count
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 1;


-- Q15. Employees earning above average
SELECT *
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);


-- Q16. Employee + department name
SELECT
    e.employee_name,
    d.department_name,
    e.salary
FROM employees e
JOIN departments d
ON e.department_id = d.department_id;


-- Q17. Highest salary in each department
SELECT
    department_id,
    MAX(salary) AS highest_salary
FROM employees
GROUP BY department_id;


-- Q18. Average salary in IT
SELECT AVG(e.salary) AS average_it_salary
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
WHERE d.department_name = 'IT';


-- Q19. Employees who joined in 2025
SELECT *
FROM employees
WHERE YEAR(joining_date) = 2025;


-- Q20. Employee salary ranking
SELECT
    employee_name,
    salary,
    RANK() OVER (
        ORDER BY salary DESC
    ) AS salary_rank
FROM employees;


-- ============================================================
-- 52. BASIC SQL INTERVIEW QUESTIONS
-- ============================================================


-- Find second highest salary
SELECT MAX(salary)
FROM employees
WHERE salary < (
    SELECT MAX(salary)
    FROM employees
);


-- Find employees with duplicate salaries
SELECT
    salary,
    COUNT(*) AS employee_count
FROM employees
GROUP BY salary
HAVING COUNT(*) > 1;


-- Find employees older than average age
SELECT *
FROM employees
WHERE age > (
    SELECT AVG(age)
    FROM employees
);


-- Find employees earning more than their department average
SELECT
    e.employee_name,
    e.department_id,
    e.salary
FROM employees e
WHERE e.salary > (

    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department_id = e.department_id

);


-- ============================================================
-- 53. FINAL CRUD EXAMPLE
-- ============================================================


-- CREATE
INSERT INTO employees
(employee_name, email, age, salary, department_id, joining_date)
VALUES
('Vijay', 'vijay@gmail.com', 26, 50000, 1, '2026-01-10');


-- READ
SELECT *
FROM employees
WHERE employee_name = 'Vijay';


-- UPDATE
UPDATE employees
SET salary = 55000
WHERE employee_name = 'Vijay';


-- READ AGAIN
SELECT *
FROM employees
WHERE employee_name = 'Vijay';


-- DELETE
DELETE FROM employees
WHERE employee_name = 'Vijay';


-- Confirm deletion
SELECT *
FROM employees
WHERE employee_name = 'Vijay';


-- ============================================================
-- END OF SQL PRACTICE
-- ============================================================
