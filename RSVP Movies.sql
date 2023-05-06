USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:


SELECT count(*) FROM [dbo].[movie];

-- The total number of rows in movie table is 7997.

SELECT count(*) FROM [dbo].[genre];

-- The total number of rows in genre table is 14662.

SELECT count(*) FROM [dbo].[director_mapping];

-- The total number of rows in director_mapping table is 3867.

SELECT count(*) FROM [dbo].[role_mapping];

-- The total number of rows in role_mapping is 15615.

SELECT count(*) FROM [dbo].[names];

-- The total number of rows in names table is 25735.

SELECT count(*) FROM [dbo].[ratings];

-- The total number of rows in ratings table is 7997.


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT Sum(CASE
             WHEN [id] IS NULL THEN 1
             ELSE 0
           END) AS NULL_ID,
       Sum(CASE
             WHEN [title] IS NULL THEN 1
             ELSE 0
           END) AS NULL_Title,
       Sum(CASE
             WHEN [year] IS NULL THEN 1
             ELSE 0
           END) AS NULL_Year,
       Sum(CASE
             WHEN [date_published] IS NULL THEN 1
             ELSE 0
           END) AS NULL_Date_Published,
       Sum(CASE
             WHEN [duration] IS NULL THEN 1
             ELSE 0
           END) AS NULL_Duration,
       Sum(CASE
             WHEN [country] IS NULL THEN 1
             ELSE 0
           END) AS NULL_Country,
       Sum(CASE
             WHEN [worlwide_gross_income] IS NULL THEN 1
             ELSE 0
           END) AS NULL_Worldwide_Gross_Income,
       Sum(CASE
             WHEN [languages] IS NULL THEN 1
             ELSE 0
           END) AS NULL_Languages,
       Sum(CASE
             WHEN [production_company] IS NULL THEN 1
             ELSE 0
           END) AS NULL_Production_Company
FROM [dbo].[movie]; 
-- Country, worlwide_gross_income, languages and production_company columns have NULL values


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


-- Number of movies released each year
SELECT [year],
       Count([title]) AS NUMBER_OF_MOVIES
FROM [dbo].[movie]  
GROUP  BY [year];


-- Number of movies released each month 
SELECT Month([date_published]) AS MONTH_NUM,
       Count([id])             AS NUMBER_OF_MOVIES
FROM  [dbo].[movie] 
GROUP  BY Month([date_published])
ORDER  BY Month([date_published]); 

-- Highest number of movies were released in month of MARCH


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:


SELECT Count(DISTINCT [id]) AS number_of_movies, [year]
FROM  [dbo].[movie]

WHERE  ( [country] LIKE '%INDIA%'
          OR [country] LIKE '%USA%' )
       AND [year] = 2019
GROUP BY [year]

-- 1059 movies were produced in the USA or India in the year 2019



/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

-- Finding unique genres using DISTINCT keyword
SELECT DISTINCT [genre]
FROM [dbo].[genre]; 

-- Movies belong to 13 genres in the dataset.



/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

-- Using TOP clause to display only the genre with highest number of movies produced last year 2019
SELECT    TOP 1
	   G.[genre] AS Gener,
           Count(M.[id]) AS number_of_movies
FROM [dbo].[movie] AS M
INNER JOIN [dbo].[genre] AS G
ON G.[movie_id]= M.[id]
WHERE M.[year] = '2019'
GROUP BY   M.[year], G.[genre]
ORDER BY number_of_movies DESC;

-- 1078 Drama movies were produced in total and are the highest among all genres for last year 2019. 


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:


-- Using genre table to find movies which belong to only one genre
-- Grouping rows based on movie id and finding the distinct number of genre each movie belongs to
-- Using the result of CTE, we find the count of movies which belong to only one genre

WITH movies_with_one_genre
     AS (SELECT [movie_id]
         FROM   [dbo].[genre]
         GROUP  BY [movie_id]
         HAVING Count(DISTINCT [genre]) = 1)
SELECT Count([movie_id]) AS movies_with_one_genre
FROM   movies_with_one_genre; 

-- 3289 movies belong to only one genre


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Finding the average duration of movies by grouping the genres that movies belong to 
SELECT     G.genre,
           Round(Avg(M.duration),2) AS avg_duration
FROM   [dbo].[movie]  AS M
INNER JOIN  [dbo].[genre] AS G
ON      G.movie_id = M.id
GROUP BY   G.genre
ORDER BY avg_duration DESC;

-- Action genre has the highest duration of 112.88 seconds followed by romance and crime genres.

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


-- CTE : Finds the rank of each genre based on the number of movies in each genre
-- Select query displays the genre rank and the number of movies belonging to Thriller genre
WITH genre_summary AS
(
           SELECT     G.genre AS Genre,
                      Count(G.movie_id)  AS movie_count ,
                      Rank() OVER(ORDER BY Count(G.movie_id) DESC) AS genre_rank
           FROM       [dbo].[genre] AS G                                 
           GROUP BY   G.genre )
SELECT *
FROM   genre_summary
WHERE  Genre = 'Thriller' ;

-- Thriller has rank=3 and movie count of 1484



/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:



-- Using MIN and MAX functions for the query 
SELECT Min([avg_rating])    AS MIN_AVG_RATING,
       Max([avg_rating])    AS MAX_AVG_RATING,
       Min([total_votes])   AS MIN_TOTAL_VOTES,
       Max([total_votes])   AS MAX_TOTAL_VOTES,
       Min([median_rating]) AS MIN_MEDIAN_RATING,
       Max([median_rating]) AS MAX_MEDIAN_RATING
FROM [dbo].[ratings]  ; 


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

-- Finding the rank of each movie based on it's average rating
-- Displaying the top 10 movies By AVG_rating
SELECT    TOP 10 M.title,
           R.avg_rating,
           Rank() OVER(ORDER BY R.avg_rating DESC) AS movie_rank
FROM    [dbo].[ratings]   AS R
INNER JOIN  [dbo].[movie] AS M
ON         M.id = R.movie_id
ORDER BY R.avg_rating DESC
-- Top 3 movies have average rating >= 9.8

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

-- Finding the number of movies vased on median rating and sorting based on movie count.
SELECT [median_rating],
       Count([movie_id]) AS movie_count
FROM   [dbo].[ratings]
GROUP  BY [median_rating]
ORDER  BY movie_count DESC; 

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_company_hit_movie_summary
     AS (SELECT M.production_company,
                Count(R.movie_id) AS MOVIE_COUNT,
                Rank()
                  OVER(
                    ORDER BY Count(R.movie_id) DESC ) AS PROD_COMPANY_RANK
         FROM [dbo].[ratings] AS R
                INNER JOIN [dbo].[movie] AS M
                        ON M.id = R.movie_id
         WHERE  R.avg_rating > 8
                AND M.production_company IS NOT NULL
         GROUP  BY M.production_company)
SELECT *
FROM   production_company_hit_movie_summary
WHERE  prod_company_rank = 1; 

-- Dream Warrior Pictures and National Theatre Live production houses has produced the most number of hit movies (average rating > 8)
-- They have rank=1 and movie count =3 

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT G.genre,
       Count(M.id) AS MOVIE_COUNT
FROM [dbo].[movie] AS M
       INNER JOIN [dbo].[genre] AS G
               ON G.movie_id = M.id
       INNER JOIN [dbo].[ratings] AS R
               ON R.movie_id = M.id
WHERE  year = 2017
       AND Month(M.date_published) = 3
       AND M.country LIKE '%USA%'
       AND R.total_votes > 1000
GROUP  BY G.genre
ORDER  BY MOVIE_COUNT DESC; 


-- 24 Drama movies were released during March 2017 in the USA and had more than 1,000 votes
-- Top 3 genres are drama, comedy and action during March 2017 in the USA and had more than 1,000 votes


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT  M.title,
       R.avg_rating,
       G.genre
FROM   [dbo].[movie] AS M
       INNER JOIN [dbo].[genre] AS G
               ON G.movie_id = M.id
       INNER JOIN [dbo].[ratings] AS R
               ON R.movie_id = M.id
WHERE  R.avg_rating > 8
       AND  M.title LIKE 'THE%'
GROUP BY  M.title, R.avg_rating, G.genre
ORDER BY R.avg_rating DESC;

-- There are 8 movies which begin with "The" in their title.
-- The Brighton Miracle has highest average rating of 9.5.
-- All the movies belong to the top 3 genres.

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.

-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:


-- BETWEEN operator is used to find the movies released between 1 April 2018 and 1 April 2019
SELECT R.median_rating, Count(M.id) AS movie_count
FROM  [dbo].[movie]  AS M
       INNER JOIN [dbo].[ratings] AS R
               ON R.movie_id = M.id
WHERE  R.median_rating = 8
       AND M.date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY R.median_rating;

-- 358 movies have released between 1 April 2018 and 1 April 2019 with a median rating of 8


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

-- Compute the total number of votes for German and Italian movies.
SELECT 'ITALIAN' AS Languages,
       Sum(R.total_votes) AS Votes
FROM  [dbo].[movie]  AS M
       INNER JOIN [dbo].[ratings] AS R
               ON R.movie_id = M.id
WHERE  M.languages LIKE '%Italian%'
--GROUP BY M.languages
UNION
SELECT 'GERMAN' AS Languages,
       Sum(R.total_votes) AS Votes
FROM  [dbo].[movie]  AS M
       INNER JOIN [dbo].[ratings] AS R
               ON R.movie_id = M.id
WHERE   M.languages LIKE '%GERMAN%'
--GROUP BY M.languages
ORDER  BY Votes DESC; 

-- By observation, German movies received the highest number of votes when queried against language and country columns.

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


-- NULL counts for columns of names table using CASE statements
SELECT 
		SUM(CASE WHEN [name] IS NULL THEN 1 ELSE 0 END) AS name_nulls, 
		SUM(CASE WHEN [height] IS NULL THEN 1 ELSE 0 END) AS height_nulls,
		SUM(CASE WHEN [date_of_birth] IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
		SUM(CASE WHEN [known_for_movies] IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
		
FROM [dbo].[names];

-- Height, date_of_birth, known_for_movies columns contain NULLS



/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_3_genres AS
(
           SELECT     TOP 3 G.genre AS Genre,
                      Count(M.id) AS movie_count ,
                      Rank() OVER(ORDER BY Count(M.id) DESC) AS genre_rank
           FROM    [dbo].[movie]  AS M
           INNER JOIN [dbo].[genre]  AS G
           ON         G.movie_id = M.id
           INNER JOIN [dbo].[ratings] AS R
           ON         R.movie_id = M.id
           WHERE      R.avg_rating > 8
           GROUP BY   G.genre
		   ORDER BY	  genre_rank ASC)
SELECT     TOP 3 N.name            AS director_name ,
           Count(D.movie_id) AS movie_count
FROM     [dbo].[director_mapping]    AS D
INNER JOIN [dbo].[genre]  AS G
ON D.movie_id=G.movie_id
INNER JOIN [dbo].[names] AS N
ON         N.id = D.name_id
INNER JOIN top_3_genres AS T
ON  G.genre = T.Genre
INNER JOIN [dbo].[ratings] AS R
ON D.movie_id = R.movie_id
WHERE      R.avg_rating > 8
GROUP BY   N.name 
ORDER BY   movie_count DESC;

-- James Mangold , Joe Russo and Anthony Russo are top three directors in the top three genres whose movies have an average rating > 8

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT TOP 2 N.name          AS actor_name,
       Count(RM.movie_id) AS movie_count
FROM  [dbo].[role_mapping]  AS RM
       INNER JOIN [dbo].[movie] AS M
               ON M.id = RM.movie_id
       INNER JOIN [dbo].[ratings] AS R 
			   ON M.id = R.movie_id
       INNER JOIN [dbo].[names] AS N
               ON N.id = RM.name_id
WHERE  R.median_rating >= 8
AND RM.category = 'ACTOR'
GROUP  BY N.name
ORDER  BY movie_count DESC; 
        
-- Top 2 actors are Mammootty and Mohanlal.


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

-- Approach 1:
SELECT   TOP 3  M.production_company,
           Sum(R.total_votes) AS vote_count,
           Rank() OVER(ORDER BY Sum(R.total_votes) DESC) AS prod_comp_rank
FROM       [dbo].[movie] AS M
INNER JOIN [dbo].[ratings] AS R
ON         R.movie_id = M.id
GROUP BY   production_company
ORDER BY   prod_comp_rank ASC;

-- Approach 2: using CTEs
WITH Ranking AS(
SELECT M.production_company AS Prod_Company, sum(R.total_votes) AS vote_count,
	RANK() OVER(ORDER BY SUM(R.total_votes) DESC) AS prod_comp_rank
FROM [dbo].[movie] AS M
	INNER JOIN [dbo].[ratings] AS R ON R.movie_id=M.id
GROUP BY M.production_company)
SELECT Prod_Company, vote_count, prod_comp_rank
FROM ranking
WHERE prod_comp_rank<4;

-- Top three production houses based on the number of votes received by their movies are Marvel Studios, Twentieth Century Fox and Warner Bros.

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH ind_actors
     AS (SELECT n.NAME,
                Sum(total_votes)                                           AS
					total_votes,
                Count(r.movie_id)                                          AS
					movie_count,
                Round(Sum(total_votes * avg_rating) / Sum(total_votes), 2) AS
					actor_avg_rating,
                Rank() OVER(ORDER BY Round(Sum(total_votes * avg_rating)/Sum(total_votes), 2) DESC, 
                Sum(total_votes) DESC)                                     AS 
					actor_rank
         FROM  [dbo].[names]  n
                INNER JOIN [dbo].[role_mapping] rm
                        ON n.id = rm.name_id
                INNER JOIN [dbo].[movie] m
                        ON rm.movie_id = m.id
                INNER JOIN [dbo].[ratings] r
                        ON rm.movie_id = r.movie_id
         WHERE  country = 'India'
         GROUP  BY n.NAME
         HAVING Count(r.movie_id) >= 5)
SELECT * FROM   ind_actors;
-- Top actor is Vijay Sethupathi followed by Fahadh Faasil and Yogi Babu.

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_summary AS
(
           SELECT     n.NAME AS actress_name,
                      total_votes,
                      Count(r.movie_id)                                     AS movie_count,
                      Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating
           FROM       movie                                                 AS m
           INNER JOIN ratings                                               AS r
           ON         m.id=r.movie_id
           INNER JOIN role_mapping AS rm
           ON         m.id = rm.movie_id
           INNER JOIN names AS n
           ON         rm.name_id = n.id
           WHERE      category = 'ACTRESS'
           AND        country = 'INDIA'
           AND        languages LIKE '%HINDI%'
           GROUP BY   NAME, total_votes
           HAVING     Count(r.movie_id) >=5 )
SELECT   *,
         Rank() OVER(ORDER BY actress_avg_rating DESC) AS actress_rank
FROM     actress_summary ;

-- Top five actresses in Hindi movies released in India based on their average ratings are Taapsee Pannu, Kriti Sanon, Divya Dutta, Shraddha Kapoor, Kriti Kharbanda


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:



-- Using CASE statements to classify thriller movies as per avg rating 

WITH thriller_movies
     AS (SELECT DISTINCT M.title,
                         R.avg_rating AS AVG_Ratings
         FROM  [dbo].[movie]  AS M
                INNER JOIN [dbo].[ratings] AS R
                        ON R.movie_id = M.id
                INNER JOIN [dbo].[genre] AS G 
						ON R.movie_id = G.movie_id
         WHERE  G.genre LIKE 'THRILLER')
SELECT *,
       CASE
         WHEN AVG_Ratings > 8 THEN 'Superhit movies'
         WHEN AVG_Ratings BETWEEN 7 AND 8 THEN 'Hit movies'
         WHEN AVG_Ratings BETWEEN 5 AND 7 THEN 'One-time-watch movies'
         ELSE 'Flop movies'
       END AS avg_rating_category
FROM   thriller_movies; 


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT G.genre,
		ROUND(AVG(M.duration),2) AS avg_duration,
        SUM(ROUND(AVG(M.duration),2)) OVER(ORDER BY G.genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
        AVG(ROUND(AVG(M.duration),2)) OVER(ORDER BY G.genre ROWS 10 PRECEDING) AS moving_avg_duration
FROM [dbo].[movie] AS M 
INNER JOIN [dbo].[genre] AS G 
ON M.id= G.movie_id
GROUP BY G.genre
ORDER BY G.genre;


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top_3_genre AS
(     
    SELECT     TOP 3 G.genre AS Genre,
                      Count(M.id)                            AS movie_count ,
                      Rank() OVER(ORDER BY Count(M.id) DESC) AS genre_rank
           FROM       [dbo].[movie]  AS M
           INNER JOIN [dbo].[genre] AS G
           ON         G.movie_id = M.id
           INNER JOIN [dbo].[ratings] AS R
           ON         R.movie_id = M.id
           WHERE      R.avg_rating > 8
           GROUP BY   G.genre 
		   ORDER BY	  genre_rank ASC

),

 

top_5 AS
(
    SELECT genre,
            year,
            title AS movie_name,
            worlwide_gross_income,
            DENSE_RANK() OVER(PARTITION BY year ORDER BY worlwide_gross_income DESC) AS movie_rank

    FROM movie AS m 
    INNER JOIN genre AS g 
    ON m.id= g.movie_id
    WHERE genre IN (SELECT genre FROM top_3_genre)
)

 

SELECT *
FROM top_5
WHERE movie_rank<=5;


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


WITH production_company_summary
     AS (SELECT production_company,
                Count(*) AS movie_count
         FROM  [dbo].[movie]  AS m
                inner join [dbo].[ratings] AS r
                        ON r.movie_id = m.id
         WHERE  median_rating >= 8
                AND production_company IS NOT NULL
                AND Position(',' IN languages) > 0
         GROUP  BY production_company
         ORDER  BY movie_count DESC)
SELECT *,
       Rank()
         over(
           ORDER BY movie_count DESC) AS prod_comp_rank
FROM   production_company_summary
LIMIT 2; 


-- Star Cinema and Twentieth Century Fox are the top two production houses that have produced the highest number of hits among multilingual movies.






-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_summary AS
(
           SELECT    TOP 3 n.NAME AS actress_name,
                      SUM(total_votes) AS total_votes,
                      Count(r.movie_id)                                     AS movie_count,
                      Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating
           FROM       movie                                                 AS m
           INNER JOIN ratings                                               AS r
           ON         m.id=r.movie_id
           INNER JOIN role_mapping AS rm
           ON         m.id = rm.movie_id
           INNER JOIN names AS n
           ON         rm.name_id = n.id
           INNER JOIN GENRE AS g
           ON g.movie_id = m.id
           WHERE      category = 'ACTRESS'
           AND        avg_rating>8
           AND genre = 'Drama'
           GROUP BY   NAME )
SELECT   *,
         Rank() OVER(ORDER BY movie_count DESC) AS actress_rank
FROM     actress_summary;






/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH next_date_published_summary AS
(
           SELECT     d.name_id,
                      NAME,
                      d.movie_id,
                      duration,
                      r.avg_rating,
                      total_votes,
                      m.date_published,
                      Lead(date_published,1) OVER(partition BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
           FROM       director_mapping                                                                      AS d
           INNER JOIN names                                                                                 AS n
           ON         n.id = d.name_id
           INNER JOIN movie AS m
           ON         m.id = d.movie_id
           INNER JOIN ratings AS r
           ON         r.movie_id = m.id ), top_director_summary AS
(
       SELECT *,
              Datediff(next_date_published, date_published) AS date_difference
       FROM   next_date_published_summary )
SELECT   name_id                       AS director_id,
         NAME                          AS director_name,
         Count(movie_id)               AS number_of_movies,
         Round(Avg(date_difference),2) AS avg_inter_movie_days,
         Round(Avg(avg_rating),2)               AS avg_rating,
         Sum(total_votes)              AS total_votes,
         Min(avg_rating)               AS min_rating,
         Max(avg_rating)               AS max_rating,
         Sum(duration)                 AS total_duration
FROM     top_director_summary
GROUP BY director_id
ORDER BY Count(movie_id) DESC limit 9;





