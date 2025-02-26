
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
SELECT *
FROM names
ORDER BY num_registered DESC
LIMIT 1;

-- 4. What range of years are included?
SELECT MIN(year) AS min_year,MAX(year) AS max_year
FROM names;

-- 5. What year has the largest number of registrations?
SELECT year, SUM(num_registered) AS most_registrations
FROM names
GROUP BY year
ORDER BY SUM(num_registered) DESC
LIMIT 1;

-- 6. How many different (distinct) names are contained in the dataset?
SELECT COUNT(DISTINCT(name)) AS n_distinct_names
FROM names;

-- 7. Are there more males or more females registered?
SELECT gender, SUM(num_registered)
FROM names
GROUP BY gender;
-- more males

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

-- alternate
SELECT DISTINCT ON (gender) name, gender, SUM(num_registered)
FROM names
GROUP BY name, gender
ORDER BY gender, SUM(num_registered) DESC;


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

-- alternate
SELECT DISTINCT ON (gender) name, gender, SUM(num_registered)
FROM names
WHERE year BETWEEN 2000 AND 2009
GROUP BY name, gender
ORDER BY gender, SUM(num_registered) DESC;


-- 10. Which year had the most variety in names (i.e. had the most distinct names)?
SELECT year, COUNT(DISTINCT(name))
FROM names
GROUP BY year
ORDER BY COUNT(DISTINCT(name)) DESC
LIMIT 1;

-- 11. What is the most popular name for a girl that starts with the letter X?
SELECT name as girl_x_name, SUM(num_registered), gender
FROM names
WHERE (name LIKE 'X%') AND (gender = 'F')
GROUP BY name, gender
ORDER BY SUM(num_registered) DESC
LIMIT 1;

-- 12. Write a query to find all (distinct) names that start with a 'Q' but whose second letter is not 'u'.
SELECT DISTINCT(name)
FROM names
WHERE name LIKE 'Q%' AND name NOT LIKE '_u%'
GROUP BY name;

-- 13. Which is the more popular spelling between "Stephen" and "Steven"? Use a single query to answer this question.
SELECT name, SUM(num_registered)
FROM names
WHERE name IN ('Stephen', 'Steven')
GROUP BY name
ORDER BY SUM(num_registered);

-- 14. Find all names that are "unisex" - that is all names that have been used both for boys and for girls.
SELECT name
FROM names
GROUP BY name
HAVING COUNT(DISTINCT gender) = 2;

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

--how many total males and females are there registered in the dataset? 
SELECT SUM(num_registered) AS total_males
FROM names
WHERE gender = 'M';

SELECT SUM(num_registered) AS total_females
FROM names
WHERE gender = 'F'



-- BONUS --
-- Names Bonus Questions

-- For this first set of questions, you might find it useful to refer to the PostgreSQL string functions (https://www.postgresql.org/docs/current/functions-string.html).

-- 	1. Find the longest name contained in this dataset. What do you notice about the long names?
SELECT name, LENGTH(name)
FROM names
GROUP BY name
ORDER BY LENGTH(name) DESC;
-- the longest names are all capped at 15 characters

-- 	2. How many names are palindromes (i.e. read the same backwards and forwards, such as Bob and Elle)?
SELECT COUNT(name)
FROM names
WHERE LOWER(name) = REVERSE(LOWER(name));

-- 	3. Find all names that contain no vowels (for this question, we'll count a,e,i,o,u, and y as vowels). (Hint: you might find this page helpful: https://www.postgresql.org/docs/current/functions-matching.html)
SELECT name
FROM names
WHERE name NOT SIMILAR TO '%(a*|e*|i*|o*|u*|y*)%';

-- 	4. How many double-letter names show up in the dataset? Double-letter means the same letter repeated back-to-back, like Matthew or Aaron. Are there any triple-letter names?
SELECT *
FROM names
WHERE LOWER(name) ~ '(.)\1';

SELECT *
FROM names
WHERE LOWER(name) ~ '(.)\1\1'
-- For the next few questions, you'll likely need to make use of subqueries. A subquery is a SQL query nested inside another query. You'll learn more about subqueries over the next few DataCamp assignments.


-- 	5. On question 17 of the first part of the exercise, you found names that only appeared in the 1950s. Now, find all names that did not appear in the 1950s but were used both before and after the 1950s. We'll answer this question in two steps.

-- 		a. First, write a query that returns all names that appeared during the 1950s.
SELECT name
FROM names
WHERE year BETWEEN 1950 AND 1959
GROUP BY name;

-- 		b. Now, make use of this query along with the IN keyword in order the find all names that did not appear in the 1950s but which were used both before and after the 1950s. See the example "A subquery with the IN operator." on this page: https://www.dofactory.com/sql/subquery.
SELECT name
FROM names
WHERE name NOT IN 
	(SELECT name
	FROM names
	WHERE year BETWEEN 1950 AND 1959
	GROUP BY name)
GROUP BY name
HAVING MIN(year) <1950
	AND MAX(year) >1959;

	
-- 	6. In question 16, you found how many names appeared in only one year. Which year had the highest number of names that only appeared once?
-- i need the years that have the most names that do not occur in any other year
SELECT name
FROM names
GROUP BY name
HAVING COUNT(year) = 1
ORDER BY COUNT(year);

SELECT year, COUNT(name) as n_names
FROM names
WHERE name IN
	(
	SELECT name
	FROM names
	GROUP BY name
	HAVING COUNT(year) = 1
	ORDER BY COUNT(year)
	)
GROUP BY year
ORDER BY n_names DESC
LIMIT 1;

-- 	7. Which year had the most new names (names that hadn't appeared in any years before that year)? For this question, you might find it useful to write a subquery and then select from this subquery. See this page about using subqueries in the from clause: https://www.geeksforgeeks.org/sql-sub-queries-clause/
SELECT DISTINCT name, MIN(year) AS year
FROM names
GROUP BY name
ORDER BY year ASC;

SELECT m.year, COUNT(name) AS new_names
FROM (
	SELECT DISTINCT name, MIN(year) AS year
	FROM names
	GROUP BY name
	ORDER BY year ASC
) AS m
GROUP BY m.year 
ORDER BY new_names DESC
LIMIT 1;

-- 	8. Is there more variety (more distinct names) for females or for males? Is this true for all years or are their any years where this is reversed? Hint: you may need to make use of multiple subqueries and JOIN them in order to answer this question.
SELECT gender,COUNT(DISTINCT name) AS distinct_names
FROM names
GROUP BY gender;
-- overall more distinct female names than male names
SELECT *
FROM (
	SELECT year, m.distinct_male_names, f.distinct_female_names
	FROM (
		SELECT year, COUNT(DISTINCT name) AS distinct_male_names
		FROM names
		WHERE gender = 'M'
		GROUP BY year
	) AS m
	INNER JOIN (
		SELECT year, COUNT(DISTINCT name) AS distinct_female_names
		FROM names
		WHERE gender = 'F'
		GROUP BY year
	) AS f
	USING(year)
)
WHERE distinct_male_names > distinct_female_names;
-- only three years where there were more distinct male names than femal names


-- 	9. Which names are closest to being evenly split between male and female usage? For this question, consider only names that have been used at least 10000 times in total. 
-- query to get names used 10000 times at least
SELECT name, SUM(num_registered)
FROM names
GROUP BY name
HAVING SUM(num_registered)> 10000
ORDER BY SUM(num_registered);


-- output should show name, n_female, n_male, n_diff
-- order by n_diff, smallest are closest to even split
-- join on name

SELECT name, m.n_male, f.n_female, ABS(m.n_male - f.n_female) AS n_diff
FROM(
	SELECT name, SUM(num_registered) AS n_male
	FROM names
	WHERE gender = 'M'
	GROUP BY name
	HAVING SUM(num_registered) > 10000
) AS m
INNER JOIN (
	SELECT name, SUM(num_registered) AS n_female
	FROM names
	WHERE gender = 'F'
	GROUP BY name
	HAVING SUM(num_registered) > 10000
) AS f
USING(name)
ORDER BY n_diff
LIMIT 5;


-- For the last questions, you might find window functions useful (see https://www.postgresql.org/docs/current/sql-expressions.html#SYNTAX-WINDOW-FUNCTIONS and https://www.postgresql.org/docs/current/functions-window.html for a list of window function available in PostgreSQL). A window function is like an aggregate function in that it can be applied across a group, but a window function does not collapse each group down to a single summary statistic. The groupings for a window function are specified using the PARTITION BY keyword (and can include an ORDER BY when it is needed). The PARTITION BY and ORDER BY associated with a window function are CONTAINED in an OVER clause.
-- For example, to rank each row by the value of num_registered, we can use the query
-- ```
-- SELECT name, year, num_registered, RANK() OVER(ORDER BY num_registered DESC)
-- FROM names;
-- ```

-- If I want to rank within gender, I can add a PARTITION BY:  
-- ```
-- SELECT name, year, num_registered, RANK() OVER(PARTITION BY gender ORDER BY num_registered DESC)
-- FROM names;
-- ```


-- 	10. Which names have been among the top 25 most popular names for their gender in every single year contained in the names table? Hint: you may have to combine a window function and a subquery to answer this question.



-- 	11. Find the name that had the biggest gap between years that it was used. 


-- 	12. Have there been any names that were not used in the first year of the dataset (1880) but which made it to be the most-used name for its gender in some year? Difficult follow-up: What is the shortest amount of time that a name has gone from not being used at all to being the number one used name for its gender in a year?


