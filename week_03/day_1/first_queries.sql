/*
* This is a multiline comment
*/
-- This is an inline comment



-- Get me a table of all the animals information

SELECT *
FROM animals;

-- READ operation




-- Get me a table of information about the nimal with id=2

SELECT *
FROM animals
WHERE id = 2;


--  Task get em a table of information about ernest the snake

SELECT *
FROM animals
WHERE name = 'Ernest' AND species = 'Snake';

-- because we are filtering on a primary key we should only expect 1 row
SELECT *
FROM animals
WHERE id = 7;
