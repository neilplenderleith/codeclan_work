

-- Find the number of employess within each dept of the corporation

SELECT 
	department,
	count(id) AS num_employees
FROM employees
GROUP BY department
ORDER BY count(id);
-- Anything in the group by can be in the select


-- how many employees in each country

SELECT 
	country,
	count(id) AS num_employees
FROM employees
GROUP BY country
ORDER BY count(id) DESC ;


-- how many employees in each country and department

SELECT 
	country,
	department,
	count(id) AS num_employees
FROM employees
GROUP BY country, department
ORDER BY country;


-- how many employees in each department work either 0.25 or 0.5 fte hours

SELECT 
department,
fte_hours,
count(id) AS num_employees
FROM employees 
WHERE fte_hours BETWEEN 0.25 AND 0.5 -- could even say fte_hours IN (0.25,0.5)
GROUP BY fte_hours, department;

-- Alternative from the notes - slightly different
SELECT 
  department, 
  COUNT(id) AS num_fte_quarter_half 
FROM employees 
WHERE fte_hours BETWEEN 0.25 AND 0.5 
GROUP BY department;


-- See how NULL affects counts
-- Gotcha counts can exist without a group by if no other column is present

SELECT count(id), -- IF IN doubt use the PRIMARY key
count(first_name), -- count DOES NOT INCLUDE NULLS
count(*) -- BIG GOTCHA - this can count NULL VALUES IN lines
FROM employees;



-- longest serving employee in each department
-- NOW() gives todays date (FOR THE SERVER)

SELECT 
department,
first_name,
last_name,
round(EXTRACT(DAY FROM NOW() - MIN(start_date))/365) AS time_served
-- now() - start_date AS time_served
FROM employees
GROUP BY department, first_name, last_name
ORDER BY department, time_served DESC NULLS LAST;



-- ORDER OF EXECUTION
--1	FROM
--2	WHERE
--3	GROUP BY
--4	HAVING
--5	SELECT
--6	ORDER BY
--7	LIMIT

1. "How many employees in each department are enrolled in the pension scheme?"

2. "Perform a breakdown by country of the number of employees that do not have a stored first name."

SELECT 
department,
count(id) AS pension_enrolled
FROM employees 
WHERE pension_enrol IS TRUE 
GROUP BY  department;

SELECT 
country,
count(id) AS first_name_null
FROM employees
WHERE first_name IS NULL 
GROUP BY country;



-- show departments in whihch at least 40 employees work fte of 0.25 or 0.5

SELECT 
department,
count(id)
FROM employees 
WHERE fte_hours IN (0.25, 0.5)
GROUP BY department
HAVING count(id) >= 40 -- ONLY WORKs WITH aggregates

--SHOW ANY countries IN which the minimum salary among pension enrolled IS less than 21000 dollars

SELECT 
country,
min(salary)
FROM employees 
WHERE pension_enrol IS TRUE 
GROUP by country 
HAVING min(salary) < 21000;
-- note order by is usually similar to the group by

-- This is another way to do it - from clsswork
SELECT 
country,
min(salary),
department
FROM employees 
WHERE pension_enrol IS TRUE 
GROUP by country, department 
HAVING min(salary) < 21000
ORDER BY min(salary), department;


Show any departments in which the earliest start date amongst grade 1 employees is prior to 1991

SELECT 
department,
min(start_date) AS earliest_start
FROM employees 
WHERE grade = 1
GROUP BY department 
HAVING min(start_date) < '1991-01-01';






























