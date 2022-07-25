/*
 * Manipulating Returned Data
 * 
 * Specifying column aliases using AS
 * us the DISTINCT function
 * use some aggregate functions
 * sort records
 * limit the number of records returned 
*
*/

-- we can manipulate the data that is returned by a query BY 
-- altering the SELECT STATEMENT 

SELECT 
	id,
	first_name,
	last_name
	FROM employees 
	WHERE department = 'Accounting';
	
-- Column Aliases

-- can we get a list of all employees by a list of their first name and last name combined ito one field(column)
-- called full_name 

SELECT 
	concat('Hello', ' ', 'there!');
	
SELECT 
	first_name,
	last_name,
	concat(first_name, ' ', last_name) AS full_name
	FROM employees ;	

-- Task: Add a WHERE clause to the query above to filter out any rows that don’t have both a first and second name.

SELECT 
	first_name,
	last_name,
	concat(first_name, ' ', last_name) AS full_name
FROM employees 
WHERE (first_name IS NOT NULL) AND (last_name IS NOT NULL);

-- alises are good because theyre more informative than the default (this means what you call the new column name after doing the concat) here it is full_name

-- The companys problem

-- our DATABASE might be out of date. we should have 6 depts in the corp. How many departments do employees belong to in the database 

SELECT DISTINCT (department)
FROM employees; 

-- all the different (unique) values from the department column

/*
 * Aggregate Functions
 */

-- How many employees started work for omni corp in 2001

SELECT 
	count(*) AS started_in_2001
FROM employees
WHERE start_date BETWEEN '2001-01-01' AND '2001-12-31';

-- returns number of rows in the output (ie how many rows pass the where criteria)
-- after the AS is the name of the new COLUMN 

/*
 * other aggregates:
 * 
 * SUM() sum of a column
 * AVG() mean of a column
 * MIN() minimum of a column
 * MAX() maximum of a column
 * 
 */

-- Task - 10 mins
-- Design queries using aggregate functions and what you have learned so far to answer the following questions:
-- 1. “What are the maximum and minimum salaries of all employees?”
-- 2. “What is the average salary of employees in the Human Resources department?”
-- 3. “How much does the corporation spend on the salaries of employees hired in 2018?”

SELECT 	
	Max(salary) AS maximum_salary,
	min(salary) AS minimum_salary
	FROM employees;

SELECT 
	avg(salary) AS average_salary
	FROM employees
	WHERE department = 'Human Resources';

SELECT 
	sum(salary) AS total_salary_2018
	FROM employees
	WHERE start_date BETWEEN '2018-01-01' AND '2018-12-31';

/*
 * 
 * Sorting the results
*/

-- ORDER BY

-- sorts the return of a query either - DESC, or ASC
-- thing to note ORDER BY comes after WHERE

-- Get me a table of the employees details for the employee who earsn the minimum salary across omni corp

SELECT *
FROM employees 
WHERE salary IS NOT NULL 
ORDER BY salary ASC
LIMIT 1;

-- LIMIT the query result with LIMIT

-- maximum value for the salary column
SELECT *
FROM employees 
WHERE salary IS NOT NULL 
ORDER BY salary DESC
LIMIT 1;

-- If we want ot put NULLS at the end of the sorted list use NULLS LAST

SELECT *
FROM employees 
ORDER BY salary DESC NULLS LAST
LIMIT 1;


/*
 * we can perform multi-level sorts (sorts on multiple columns)
 */

-- get me a table with employee details, ordered by full time equivalent hours (highest first) and then alphabetically by last name 

SELECT *
FROM employees 
ORDER BY 
	fte_hours DESC NULLS LAST,
	last_name ASC NULLS LAST;


--Task - 5 mins
--Write queries to answer the following questions using the operators introduced in this section.
--1. “Get the details of the longest-serving employee of the corporation.”
--2. “Get the details of the highest paid employee of the corporation in Libya.”

SELECT *
FROM employees 
ORDER BY start_date ASC NULLS LAST 
LIMIT 1;

SELECT *
FROM employees 
WHERE country = 'Libya'
ORDER BY salary DESC NULLS LAST 
LIMIT 1;

-- A notes on ties - ties can happen when ORDERING 
-- eg two employees started on the same date 
-- LIMIT 1 would just return 1 row when there might be 2

-- write a first query to fin the max in a COLUMN 
-- use this result in the where clause of a second query to find all rows with that value 


-- get me a table of all employees who work the alphabeticall first country

SELECT 
	country 
FROM employees 
ORDER BY country
LIMIT 1;
-- ge tthe country first

-- then sleect the employeees

SELECT *
FROM employees 
WHERE country = 'Afghanistan';


--- check notes for order of execution week3, day1

SELECT 
id,
first_name,
last_name,
	concat(first_name, ' ', last_name) AS full_name
	FROM employees 
	WHERE full_name LIKE 'A%';
-- doesnt run as full name doesnt exist to do a where function on


SELECT 
id,
first_name,
last_name,
	concat(first_name, ' ', last_name) AS full_name
	FROM employees 
	WHERE concat(first_name, ' ', last_name) LIKE 'A%';
-- as SQL order of operation != order of execution (SELECT) happens later than it looks like SEE NOTES










