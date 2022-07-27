/*
 * advanced SQL Topics
 */


-- Create your own function
-- can help with performing same tasks repeatedly
-- you may not be allowed to create functions - depends on your database permissions

-- omni USER cannot CREATE FUNCTIONS 
-- functions are attached to databases


/*
1. use the keyword CREATE [or REPLACE if replacing a function] * to start creating the function
2. give your function a name - percent_change
3. specify the arguments of your function and their datatypes
4. specify the datatype of the result
5. write the code for the function
6. additional things - specify the language eg SQL
7. immutable means cannot be changed
 */ 

--this is the code to create a FUNCTION (percent_change)
CREATE OR REPLACE FUNCTION 
percent_change(new_value NUMERIC, old_value NUMERIC, decimals INT DEFAULT 2)
RETURNS NUMERIC AS 
   'SELECT ROUND(100 * (new_value - old_value) / old_value, decimals);'
LANGUAGE SQL
IMMUTABLE
RETURNS NULL ON NULL INPUT;

-- test drive of function

SELECT 
percent_change(50, 40),
percent_change(100, 99, 4);

-- Legal salaries ARE increasing BY $1000 NEXT YEAR 
-- show the percent change for each employee in Legal

SELECT 
id,
first_name,
last_name,
salary + 1000 AS new_salary,
percent_change(salary+1000, salary, 2)
FROM employees 
WHERE department = 'Legal'
ORDER BY percent_change DESC NULLS LAST;











/*
 * Investigating Query Performance
 * 
 * [EXPLAIN / ANALYZE]
 * 
 * maybe a query is taking a surprisingly lng time to run
 * 
 * Interview questions (how would i speed up a slow running query?)
 * Answer is usually with an INDEX, tho do an EXPLAIN ANALYZE first to check
 */

-- get me a table of department average salaries for employees working in germamy france italy or spaim

EXPLAIN ANALYZE 
SELECT department, avg(salary)
FROM employees 
WHERE country IN ('Germany', 'France', 'Italy', 'Spain')
GROUP BY department 
ORDER BY avg(salary);


-- How could we speed up this query?

-- Index columns!

-- what index columns do is behind the scenes they provide a quick (lookup-y) way
-- of finding rows using an index column

--EG searching a phone book for david currie

-- 1. start at the start and go through each page until we find david currie
--  look at all the a's, all the b's and most of the c's until we find david, c 
-- (sequential scan) DEFAULT BEHAVIOUR

-- 2. better way is to use an index and notice surname starts with a C
-- go directly to C and start there
-- (INDEX scan)

--lets use employess indexed table

-- this was created with employees and indexes by country

EXPLAIN ANALYZE 
SELECT department, avg(salary)
FROM employees_indexed 
WHERE country IN ('Germany', 'France', 'Italy', 'Spain')
GROUP BY department 
ORDER BY avg(salary);

-- drawbacks to index
-- storage(less problems these days)
-- slows down other crud operations (insert, update, delete) since indexes need to be updated

-- Think of an index as a helpful librarian - may offer helpful advice but dont always have to take the advice


-- CTE - common table expressions

--We can create temporary tables before the start of our query and access them like tables in the DATABASE 

/*
 * find all the employees in the Legal department who earn less than the mean salary of people in that same department
 * 
 */

SELECT 
FROM 
WHERE
GROUP BY 
HAVING 
ORDER BY 
LIMIT 

-- subqueries too

SELECT * 
FROM employees
WHERE department = 'Legal' AND salary < (
										SELECT avg(salary)
										FROM employees 
										WHERE department = 'Legal');

/*
 * common table expressions allow you to specifiy this temporary table 
 * created in our subquery as table in the database
 */

WITH dep_average AS ( -- makes a TABLE CALLED dep_average
	SELECT avg(salary) AS avg_salary
	FROM employees 
	WHERE department = 'Legal'
	) 
SELECT *
FROM employees 
WHERE department = 'Legal' AND salary < (
		SELECT avg_salary
		FROM dep_average); -- REFERENCES our above TABLE here
-- dep_average only exists inside this query	
	

/* 
 * find all employees in legal who earn less than the mean salary and work fewer than the mean fte hours
 */
-- with subqueries
SELECT *
FROM employees 
WHERE department = 'Legal' AND salary < (
		SELECT avg(salary)
		FROM employees
		WHERE department = 'Legal'
		) AND fte_hours < (
		SELECT avg(fte_hours)
		FROM employees 
		WHERE department = 'Legal');

		
-- with cte
	
--	essentially this IS SELECT * FROM employees WHERE (CONDITION 1 FROM NEW table) AND (condition 2 from new table)
	
	

WITH dep_averages AS ( -- makes a NEW TABLE WITH the averages OF salary AND fte_hours
SELECT 	avg(salary) AS avg_salary,
		avg(fte_hours) AS avg_fte
FROM employees 
WHERE department = 'Legal'
)
SELECT * -- main query now USING the above VALUES IN the WHERE condition
FROM employees 
WHERE department = 'Legal' AND salary < (
		SELECT avg_salary
		FROM dep_averages
) AND fte_hours < (
		SELECT avg_fte
		FROM dep_averages);
		
		
		
-- above adidtional from calssroom notes
/*
 * Find all the employees in Legal who earn
 * less than the mean salary and work fewer
 * than the mean fte hours
 */

-- 1. find the mean salary
-- 2. find the mean fte hours
-- 3. plug into WHERE


	
	
	
	
	
	
	
	
/* 
 * get a table with each employees 
 * - first_name
 * - last-name
 * department,
 * country
 * salary 
 * and a comparison of their salary vs that of the country they work in
 * and the department they work in
 */		
		
/*
 * first | last| dep | country | salary | sal vs dep | sal vs country
 * 
 * employee salary / department saverage
 * employees salary / country average
 */	
		
-- 1. GET the average salary FOR EACH department
-- 2. GET the average salary FOR EACH country
-- 3. 2 joins	
-- 4. using these average values calculate each employees ratio (SELECT)
		
/*
 * first get
 * first | last| dep | country | salary | department average salary | country average salary
 */
		

WITH dep_avgs AS ( -- CREATE TEMPORARY TABLE CALLED DEP_AVGS calculated average BY department
	SELECT 
		department,
		avg(salary) AS avg_salary_dept
FROM employees 
GROUP BY department
),
	country_avgs AS ( -- CREATE TEMPORARY TABLE CALLED country_avgs calclates avg per country
	SELECT 
		country,
		avg(salary) AS avg_salary_country
	FROM employees 
	GROUP BY country
	)
SELECT  -- main query
	e.first_name, 
	e.last_name, 
	e.department, 
	e.country, 
	e.salary,
	round(e.salary / dep_a.avg_salary_dept, 2) AS average_compared_department, 
	round(e.salary / c_a.avg_salary_country, 2) AS average_compared_country
FROM employees AS e 
INNER JOIN dep_avgs AS dep_a 
ON e.department = dep_a.department
INNER JOIN country_avgs AS c_a 
ON e.country = c_a.country;

		
		
		
		
		
		
/*
 * Window Functions
 * 
 * Allow group operations by row - equivalent to R group by followed by mutate
 */		
		
/*
 * show for each employee their salary togther with the minimum and 
 * maximum salaries of employees in their department
 */

-- window functions : OVER

SELECT 
	first_name ,
	last_name ,
	salary ,
	department,
	min(salary) OVER (PARTITION BY department),
	max(salary) OVER (PARTITION BY department)
FROM employees;

-- common tables

WITH dep_avgs AS (
SELECT 
	department,
	min(salary) AS min_salary,
	max(salary) AS max_salary
FROM employees 
GROUP BY department
)
SELECT 
	e.first_name,
	e.last_name,
	e.salary,
	e.department,
	dep_a.min_salary,
	dep_a.max_salary
FROM employees AS e
INNER JOIN dep_avgs AS dep_a
ON e.department = dep_a.department;


































		
