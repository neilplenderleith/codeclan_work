
/* table relationships
 * 
 * one-to-one eg marriage, one NI number per person
 * 
 * one to many eg one person has more than one bank account
 * 				1 diet can have many animals
 * 
 * many to many 1 player can belong to many teams
 * 				1 animal could have many animals, 1 keeper could have many animals
 * 
 * if you see more than one foreign key in a table it generally denotes a many to many join table
 * 
 * 
 */

-- inner join implies at least a one-one relationship or a one-Many
SELECT *
FROM animals
INNER JOIN diets ON animals.diet_id = diets.id

-- can also write this way
SELECT animals.*,
diets.*
FROM animals
INNER JOIN diets ON animals.diet_id = diets.id


-- can also write this way - with aliases
SELECT A.*,
D.*
FROM animals AS A
INNER JOIN diets AS D ON A.diet_id = D.id;


-- can pick which columns we want with "table_name.column_name"
SELECT 	A.name, A.species ,A.age,
		D.diet_type
FROM animals AS A
INNER JOIN diets AS D ON A.diet_id = D.id
WHERE A.age > 4;


-- count the animals in the zoo group by diet type

SELECT count(A.id), D.diet_type
FROM animals AS A
INNER JOIN diets AS D ON a.diet_id = D.id
GROUP BY D.diet_type;

-- Modify the above to return all herbivores only

SELECT count(A.id), D.diet_type
FROM animals AS A
INNER JOIN diets AS D ON a.diet_id = D.id
WHERE D.diet_type = 'herbivore'
GROUP BY D.diet_type;

-- adding an extra column to change the output 
SELECT count(A.id),A.species, D.diet_type
FROM animals AS A
INNER JOIN diets AS D ON a.diet_id = D.id
WHERE D.diet_type = 'herbivore'
GROUP BY A.species, D.diet_type;


--Defualt inner join for copying and pasting
SELECT 	A.name, A.species ,A.age,
		D.diet_type
FROM animals AS A
INNER JOIN diets AS D ON A.diet_id = D.id;


-- LEFT JOIN brings back all records on the left table and any matching records on the right(if any)

SELECT 	A.name, A.species ,A.age,
		D.diet_type
FROM animals AS A
LEFT JOIN diets AS D ON A.diet_id = D.id;

-- RIGHT JOIN is the opposite of a left join
SELECT 	A.name, A.species ,A.age,
		D.diet_type
FROM animals AS A
RIGHT JOIN diets AS D ON A.diet_id = D.id;



-- return how many animals follow each diet type, including any diets which no animals follow

SELECT 	count(A.id),
		D.diet_type
FROM animals AS A
RIGHT JOIN diets AS D ON A.diet_id = D.id
GROUP BY D.diet_type;

-- return how many animals have a matching diet, including those with no diet

SELECT 	count(A.id),
		D.diet_type
FROM animals AS A
LEFT JOIN diets AS D ON A.diet_id = D.id
GROUP BY D.diet_type;


-- FULL JOIN brings back records from both tables
-- dont see full joins too often - mostly inner or left

SELECT 	A.name, A.species, A.age,
		D.diet_type
FROM animals AS A
full JOIN diets AS D ON A.diet_id = D.id;

--Get a rota for keepers and the naimals they look after ordered first by animal name and then by day

SELECT A."name" AS animal_name, A.species,
CS."day",
K."name" AS keeper_name
FROM animals AS A
INNER JOIN care_schedule AS CS ON A.id = CS.animal_id 
INNER JOIN keepers AS K ON K.id = CS.keeper_id 
ORDER BY  CS.DAY, A.name;


-- For the above change to show me the keeper for Ernest the Snake

SELECT A."name" AS animal_name, A.species,
CS."day",
K."name" AS keeper_name
FROM animals AS A
INNER JOIN care_schedule AS CS ON A.id = CS.animal_id 
INNER JOIN keepers AS K ON K.id = CS.keeper_id 
WHERE A.name = 'Ernest' AND A.species = 'Snake'
ORDER BY  CS.DAY, A.name;

-- in the where remember we can use A.name LIKE ('%rne%), or IN('Snake')



--Various animals feature on various tours around the zoo (this is another example of a many-to-many relationship).

--Identify the join table linking the animals and tours table and reacquaint yourself with its contents.
--Obtain a table showing animal name and species, the tour name on which they feature(d), along with the start date 
--and end date (if stored) of their involvement. Order the table by tour name, and then by animal name.

--[Harder] - can you limit the table to just those animals currently featuring on tours. Perhaps the NOW() function might help? 
--Assume an animal with a start date in the past and either no stored end date or an end date in the future is currently active on a tour.


SELECT 	A."name", A.species,
		T.name,
		AnT.start_date, AnT.end_date
FROM animals AS A
INNER JOIN 
animals_tours AS AnT  ON A.id = AnT.animal_id
INNER JOIN 
tours AS T ON T.id = AnT.tour_id
ORDER BY 
T.name, A."name" ;

-- Heres a go at the harder section of the above task

SELECT 	A."name", A.species,
		T.name,
		AnT.start_date, AnT.end_date
FROM animals AS A
INNER JOIN 
animals_tours AS AnT  ON A.id = AnT.animal_id
INNER JOIN 
tours AS T ON T.id = AnT.tour_id
WHERE AnT.start_date <= NOW() 
AND (AnT.end_date >= NOW() OR AnT.end_date IS NULL) -- Evaluates AS one CONDITION because its in brackets
ORDER BY 
T.name, A."name" ;




--SELF JOIN

SELECT 
keepers.name AS keeper_name,
managers.name AS manager_name
FROM keepers
INNER JOIN keepers AS managers ON keepers.manager_id = managers.id 



-- Optionals

-- UNION - rarely used

SELECT * FROM animals 
-- 100 where conditions
UNION -- Eliminates duplicates
SELECT * FROM animals;


-- Union ALL, brings back duplicates as well - rarely used

SELECT * FROM animals 
-- 100 where conditions
UNION all -- Eliminates duplicates
SELECT * FROM animals;


-- Grafana - lookup for graphs












