SELECT * 
FROM employees 
WHERE first_name = 'James';


SELECT *
FROM employees
WHERE country = 'Argentina' AND salary > 30000;

-- find employes id = 3

SELECT *
FROM employees 
WHERE id = 3;

/*
* Comparison operators
* != not equal to
* = equal to
* > greater than
* < less than
* <= less than or equal to
*
*/

-- find all employees who work 0.5 full time hours or MORE 

SELECT *
FROM employees
WHERE fte_hours >= 0.5;

/*
 * Task find all employees not based in brazil 
 */

SELECT *
FROM employees 
WHERE country != 'Brazil';

/*
 * AND and OR
 * 
 */

-- Find all employees in china who started working for omni corp in 2019

SELECT *
FROM employees 
WHERE country = 'China' AND (start_date >= '2019-01-01' AND start_date <= '2019-12-31');

-- Be wary of the order of the valuation

-- Find all the meployees in China who either started working for Omni corp from 2019 onwards or
-- are enrolled in the pension scheme

SELECT *
FROM employees 
WHERE country = 'China' AND (start_date >= '2019-01-01' OR pension_enrol = TRUE) ;


/*
 * BETWEEN, NOT and IN
 * 
 * let you specify a range of values
 */

-- find all employees who work between 0.25 and 0.5 hours inclusive

SELECT *
FROM employees
WHERE fte_hours BETWEEN 0.25 AND 0.5;

-- this means >= lower range and <= greater range

-- fina all employees who starte dworking for omni in years other than 2017

SELECT * 
FROM employees 
WHERE start_date NOT BETWEEN '2017-01-01' AND '2017-12-31';

-- Things to note BETWEEN is INCLUSIVE so includes the values stated

-- IN 

-- find all employess based in spain south africa ireland or germany

SELECT *
FROM employees 
WHERE country IN ('Spain', 'South Africa', 'Ireland', 'Germany')
-- Can negate by saying NOT IN
-- This is the same as the R %IN% operator


-- Task find all employess who started at omni in 2016 who work 0.5 fte hours or greater

SELECT * 
FROM employees 
WHERE (start_date BETWEEN '2016-01-01' AND '2016-12-31') AND fte_hours = '0.5';

/*
 * LIKE, wildcards, and regex
 */

/*
 * your manager comes to you and says :
 * I was talking with a colleague from greece last month i can tremember the ast name exactly 
 * but i think the surname began with 'Mc....' something or other can you find them
 */

SELECT *
FROM employees 
WHERE (country = 'Greece') AND (last_name LIKE 'Mc%');

/*
 * Wildcards
 * 
 * _ - matches a single character
 * % - matches zero or more characters
 * 
 * Can pop wildcards anywhere inside the pattern
 */


SELECT *
FROM employees
WHERE last_name LIKE '%ere%';
-- Find all employees with last names containing the phrase 'ere'

/*
 * LIKE is case sensitive
 */

SELECT *
FROM employees
WHERE last_name LIKE 'D%';

-- use ILIKE to be insensitive to upper and lowercase

 SELECT *
FROM employees
WHERE last_name ILIKE 'D%';


-- ~ to define a regex pattern match

-- Find all em,ployees for whom the second letter of their last name is 'r' or 's' and the third letter is 'a' or 'o'

SELECT *
FROM employees
WHERE last_name ~ '^.[rs][ao]';

-- ^ means the start of the string, . means any single character, [rs][ao] means an r or s followed by an a or an o
-- can use the same cheatsheet for regex, with a couple of exceptions




/*
 * regex tweaks
 * 
 * ~ define a regex
 * ~* define a case insensitive regex
 * !~ negate a regex
 * !~* case insensitive and negated
 */


SELECT *
FROM employees
WHERE last_name !~ '^.[rs][ao]';
-- negated version of above query

/*
 * IS NULL
 */

-- task:  We need to ensure our employee records are up to date. Find all employees who do not have a listed email address

SELECT * 
FROM employees 
WHERE email IS NULL;
-- MUST USE IS NULL not " = NULL" . Similar to is.na in R




