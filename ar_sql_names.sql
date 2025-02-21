
/* initial import from setup
SELECT * 
FROM names 
LIMIT 5;
*/
-- column names: name, gender, num_registered, year
-- 1. How many rows are in the names table?
SELECT COUNT(*)
FROM names;

-- 2. How many total registered people appear in the dataset?
SELECT SUM(num_registered) AS total_people
FROM names;

-- 3. Which name had the most appearances in a single year in the dataset?
SELECT year, name, num_registered
FROM names
ORDER BY num_registered DESC
LIMIT 1;

-- 4. What range of years are included?
SELECT 
	MIN(year) AS min_year,
	MAX(year) AS max_year
FROM names;

-- 5. What year has the largest number of registrations?
SELECT year
FROM names
GROUP BY year
ORDER BY SUM(num_registered) DESC
LIMIT 1;

-- 6. How many different (distinct) names are contained in the dataset?
SELECT COUNT(DISTINCT(name)) AS n_distinct_names
FROM names;

-- 7. Are there more males or more females registered?
SELECT COUNT(gender) AS n_male
FROM names
WHERE gender = 'M';
SELECT COUNT(gender) AS n_female
FROM names
WHERE gender = 'F';

-- 8. What are the most popular male and female names overall (i.e., the most total registrations)?
SELECT name, SUM(num_registered) AS most_popular_male
FROM names
WHERE gender = 'M'
GROUP BY name
ORDER BY SUM(num_registered) DESC
LIMIT 1;
SELECT name, SUM(num_registered) AS most_popular_female
FROM names
WHERE gender = 'F'
GROUP BY name
ORDER BY SUM(num_registered) DESC
LIMIT 1;

-- 9. What are the most popular boy and girl names of the first decade of the 2000s (2000 - 2009)?
-- male
SELECT name AS most_pop_boy_2000s
FROM names
WHERE (year BETWEEN 2000 AND 2009) AND (gender = 'M')
GROUP BY name
ORDER BY SUM(num_registered) DESC
LIMIT 1;
-- female
SELECT name AS most_pop_girl_2000s
FROM names
WHERE (year BETWEEN 2000 AND 2009) AND (gender = 'F')
GROUP BY name
ORDER BY SUM(num_registered) DESC
LIMIT 1;

-- 10. Which year had the most variety in names (i.e. had the most distinct names)?
SELECT year AS year_most_variety
FROM names
GROUP BY year
ORDER BY COUNT(DISTINCT(name)) DESC
LIMIT 1;

-- 11. What is the most popular name for a girl that starts with the letter X?
SELECT name as girl_x_name
FROM names
WHERE (name LIKE 'X%') AND (gender = 'F')
GROUP BY name
ORDER BY SUM(num_registered) DESC
LIMIT 1;

-- 12. Write a query to find all (distinct) names that start with a 'Q' but whose second letter is not 'u'.
SELECT DISTINCT(name)
FROM names
WHERE name LIKE 'Q%' AND name NOT LIKE '_u%'
GROUP BY name;

-- 13. Which is the more popular spelling between "Stephen" and "Steven"? Use a single query to answer this question.
SELECT name, COUNT(name)
FROM names
WHERE name IN ('Stephen', 'Steven')
GROUP BY name
ORDER BY SUM(num_registered);

-- 14. Find all names that are "unisex" - that is all names that have been used both for boys and for girls.
SELECT name
FROM names
WHERE (gender = 'M')
INTERSECT
SELECT name
FROM names
WHERE (gender = 'F');

-- 15. Find all names that have made an appearance in every single year since 1880.
SELECT name
FROM names
WHERE year >=1880
GROUP BY name
HAVING COUNT(DISTINCT(year)) = (2019 - 1880); 

-- 16. Find all names that have only appeared in one year.
SELECT name, COUNT(name)
FROM names
GROUP BY name
HAVING COUNT(year) = 1;

-- 17. Find all names that only appeared in the 1950s.
SELECT name
FROM names
GROUP BY name
HAVING MIN(year) >= 1950 AND MAX(year) <= 1959;

-- 18. Find all names that made their first appearance in the 2010s.
SELECT name
FROM names
GROUP BY name
HAVING MIN(year)>=2010 AND MIN(year) < 2020;

-- 19. Find the names that have not be used in the longest.
SELECT name, MAX(year) AS last_used_year
FROM names
GROUP BY name
ORDER BY MAX(year) ASC
LIMIT 5;
-- 20. Come up with a question that you would like to answer using this dataset. Then write a query to answer this question.
-- are there any names that start and end with the same letter? 
SELECT name
FROM names
WHERE LEFT(name, 1) = RIGHT(name,1);
-- how many years does my name appear in?
SELECT name, year, num_registered
FROM names
WHERE name = 'Andrew';
-- find the names that only appear in the first 50 and last 50 years of the dataset
SELECT name
FROM names
GROUP BY name
HAVING MIN(year) < 1930 
AND MAX(year) > 1958 
AND SUM(CASE WHEN year BETWEEN 1930 AND 1958 THEN 1 ELSE 0 END) = 0;

-- find the years that had the least number registered of the most popular names James & Mary 
-- male
SELECT year, num_registered
FROM names
WHERE name = 'James'
ORDER BY num_registered ASC
LIMIT 1;
-- female
SELECT year, num_registered
FROM names
WHERE name = 'Mary'
ORDER BY num_registered ASC
LIMIT 1;

-- what is the longest name and the shortest name? 
SELECT name, LENGTH(name)
FROM names
GROUP BY name
ORDER BY LENGTH(name) DESC;
SELECT name, LENGTH(name)
FROM names
GROUP BY name
ORDER BY LENGTH(name) ASC;

-- what year contains the most names, and how many? what about the fewest?
SELECT year, COUNT(DISTINCT(name)) AS n_names
FROM names
GROUP BY year
ORDER BY n_names DESC
LIMIT 1;
SELECT year, COUNT(DISTINCT(name)) AS n_names
FROM names
GROUP BY year
ORDER BY n_names ASC
LIMIT 1;