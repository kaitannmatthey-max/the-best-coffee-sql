/*
	We are going to steal a bit of SQL from the example file given to us by Murach!
	The example file is create_ap.sql
	However, we will modify it to fit our needs.
*/
USE master
GO

IF DB_ID('bcmd2') IS NOT NULL
	DROP DATABASE bcmd2
GO

CREATE DATABASE bcmd2 -- Pg. 25 in the book for an example of this line
GO 

USE [bcmd2]
GO

/*
	First we are going to create the tables for our database!
*/
-- Pg. 25 in the book for an example
CREATE TABLE actors
(
	Id			INT				NOT NULL IDENTITY PRIMARY KEY,
	FirstName	VARCHAR(25)		NOT NULL,
	LastName	VARCHAR(25)		NOT NULL,
	Gender		VARCHAR(10)		NULL
);

CREATE TABLE directors
(
	Id			INT				NOT NULL IDENTITY PRIMARY KEY,
	FirstName	VARCHAR(25)		NOT NULL,
	LastName	VARCHAR(25)		NOT NULL
);

CREATE TABLE directors_genres
(
	DirectorId		INT				NOT NULL REFERENCES directors(Id),
	Genre			VARCHAR(25)		NOT NULL
);

CREATE TABLE movies
(
	Id		INT				NOT NULL IDENTITY PRIMARY KEY,
	Name	VARCHAR(50)		NOT NULL,
	Year	INT				NOT NULL, -- Year is a keyword, but not a protected keyword. We can use it!
	Rank	INT				NULL -- Rank is a keyword, but not a protected keyword. We can use it!
);

CREATE TABLE movies_directors
(
	DirectorId		INT		NOT NULL REFERENCES directors(Id),
	MovieID			INT		NOT NULL REFERENCES movies(Id)
);

CREATE TABLE movies_genre
(
	MovieId		INT				NOT NULL REFERENCES movies(Id),
	Genre		VARCHAR(25)		NOT NULL 
);

CREATE TABLE roles
(
	ActorId		INT				NOT NULL REFERENCES actors(Id),
	MovieId		INT				NOT NULL REFERENCES movies(Id),
	Role		VARCHAR(25)		NOT NULL
);


/*
	Next, we will create some example data for our databases. 

	Pg. 31 in the book for an example

	Here is the structure:
		INSERT INTO actors (FirstName, LastName, Gender)
		VALUES ('Tom', 'Hanks', 'male');
*/

-- Insert 3-5 actors into the actors table
INSERT INTO actors (FirstName, LastName, Gender)
VALUES ('Tom', 'Hanks', 'male');

INSERT INTO actors (FirstName, LastName, Gender)
VALUES
	('Mark', 'Hamill', 'male'),
	('Harrison', 'Ford', 'male'),
	('Carrie', 'Fisher', 'female');


-- Insert 3-5 directors into the directors table
INSERT INTO directors (FirstName, LastName)
VALUES ('Robert', 'Zemeckis');

INSERT INTO directors (FirstName, LastName)
VALUES 
	('George', 'Lucas'),
	('Steven', 'Spielberg');

-- Insert 3-5 movies into the movies table
INSERT INTO movies (Name, Year, Rank)
VALUES ('Forrest Gump', 1994, 171);

INSERT INTO movies (Name, Year, Rank)
VALUES 
	('Star Wars: Episode IV', 1977, 301),
	('Indiana Jones and the Raiders of the Lost Ark', 1981, 599);

-- Insert 1-2 genres for each director in your directors table into your directors_genres table
INSERT INTO directors_genres (DirectorId, Genre)
VALUES (1, 'Drama');

INSERT INTO directors_genres (DirectorId, Genre)
VALUES 
	(2, 'Action'),
	(3, 'Adventure');

-- Insert a record to connect each of your movies to the director of that movie, using the movies_directors table
INSERT INTO movies_directors (DirectorId, MovieId)
VALUES (1, 1);

INSERT INTO movies_directors (DirectorId, MovieId)
VALUES 
	(2, 2),
	(3, 3);

-- Insert a genre for each of the movies in your movies table, using the movies_genre table
INSERT INTO movies_genre (MovieId, Genre)
VALUES (1, 'Drama');

INSERT INTO movies_genre (MovieId, Genre)
VALUES 
	(2, 'Action'),
	(3, 'Adventure');

-- Insert a record to connect the actors and movies in your database with a role, using the roles table
INSERT INTO roles (ActorId, MovieId, Role)
VALUES (1, 1, 'Forrest Gump');

INSERT INTO roles (ActorId, MovieId, Role)
VALUES 
	(2, 2, 'Luke Skywalker'),
	(3, 2, 'Han Solo'),
	(4, 2, 'Princess Leia Organa'),
	(3, 3, 'Indy');

/*
	Now that we have data in our tables, let's double check each of our tables.
	This will give us an idea of what we're working with as we do more complicated queries.
*/
SELECT * FROM actors;
SELECT * FROM directors;
SELECT * FROM directors_genres;
SELECT * FROM movies;
SELECT * FROM movies_directors;
SELECT * FROM movies_genre;
SELECT * FROM roles;

/*
	Practice with SELECT, WHERE, DISTINCT, AND, OR, NOT
*/
-- Practice with TOP (Pg. 103)
SELECT TOP 2 * FROM actors; -- This will select the top two records from the actors table, including all column headers (Pg. 103)
SELECT TOP 10 * FROM actors; -- This will select all of the records from the table, because I don't have 10 in the table (Pg. 103)

-- Practice with WHERE (Pg. 89)
SELECT FirstName, LastName FROM actors WHERE FirstName = 'Tom'; -- This will return the record for Tom Hanks, and only show us the first and last name columns (Pg. 89)

-- Practice with DISTINCT (Pg. 100)
INSERT INTO actors (FirstName, LastName, Gender)
VALUES ('Harrison', 'Ford', 'male'); -- I already have this record in my table. This will be a duplicate!

SELECT * FROM actors -- See that we have a duplicate, but each record has a different ID

SELECT DISTINCT FirstName, LastName FROM actors -- Will show us a list of records without duplication

-- Practice with AND, OR, and NOT (Pg. 106)
SELECT FirstName, LastName FROM actors WHERE FirstName = 'Harrison' AND LastName = 'Ford'; -- I did not use DISTINCT, so I should see two records here, because two records match the first and last name

SELECT FirstName, LastName FROM actors WHERE FirstName = 'Harrison' OR FirstName = 'Tom'; -- I should see three records, because I did not use DISTINCT, and I have three records that either have first name Tom or Harrison

SELECT DISTINCT FirstName, LastName FROM actors WHERE FirstName = 'Harrison' AND LastName = 'Ford'; -- I did  use DISTINCT, so I should see one records here, even though two records match the first and last name

SELECT DISTINCT FirstName, LastName FROM actors WHERE FirstName = 'Harrison' OR FirstName = 'Tom'; -- I should see two records, because I did use DISTINCT, even though I have three records that either have first name Tom or Harrison

SELECT FirstName, LastName FROM actors WHERE NOT FirstName = 'Harrison'; -- I should see three records, because I have three entries where the first name is not Harrison

SELECT * FROM actors WHERE FirstName = 'Harrison'; -- Let's see what the IDs are for both of our Harrison Ford records

SELECT * FROM actors WHERE FirstName = 'Harrison'  AND NOT Id = 5; -- I can combine AND and NOT to specify I want the record that is first name Harrison, but not the one with the ID of 5

-- Practice with IN, BETWEEN, ORDER BY, MAX, MIN, AVERAGE, SUM, and COUNT (Pgs. 108, 111, 163)
SELECT * from directors; -- First let's take a look at our directors

SELECT * from directors WHERE FirstName IN ('Robert', 'Steven'); -- I should not see George Lucas returned, because his name is not in the options I gave (Pg. 108)

SELECT * from movies; -- Let's take a look at our movies table.

SELECT * FROM movies WHERE Rank BETWEEN 300 AND 500; -- I should only see Star Wars returned, because I only want movies returned that rank between 300 and 500 (Pg. 111)

SELECT 
MAX(Rank) AS 'Max Rank', -- Should be 599 for Indiana Jones
MIN(Rank) AS 'Min Rank', -- Should be 171 for Forrest Gump
AVG(Rank) AS 'Average Rank', -- Should be ((171 + 301 + 599)/3) = 357
COUNT(*) AS 'Total Movies' -- Should be 3
FROM movies; -- See page 163 for more on aggregate functions!

INSERT INTO movies (Name, Year)
VALUES ('A Bug''s Life', 1998); -- Next I'll want to practice aggregate functions with a null value. Let's insert a new record with no rank.

SELECT * from movies; -- We can see the movie has been added with no value (NULL) for Rank

SELECT -- Same queries, plus an additional query!
MAX(Rank) AS 'Max Rank', -- Should be 599 for Indiana Jones
MIN(Rank) AS 'Min Rank', -- Should be 171 for Forrest Gump
AVG(Rank) AS 'Average Rank', -- Should be ((171 + 301 + 599)/3) = 357
COUNT(*) AS 'Total Movies', -- Should be 4
COUNT(Rank) AS 'Total Non NULL Values' -- Should be 3
FROM movies; -- See page 163 for more on aggregate functions!

-- Practice with JOINs (Pgs. 126 - 148)

/*
	Let's look at the article we've been loosely following:
	https://hoda-saiful.medium.com/sql-tutorial-using-imdb-database-4223fc45f092

	'To retrieve data from multiple tables in a single SELECT statement, we JOIN the tables together using a common key.

	The primary key in directors table is “id” which maps as a foreign key “director_id” in the directors_genres table.
	The director table contains the id, first and last name of the director. 
	The director_genres table contains the director_id, genre of the movies directed and probability. 
	The point I’m trying to make is a single director could have directed movies of multiple genres, 
	so there is a one to many relationship between the director (id, name)and genres.'

	Let's further break this down by describing joins in terms of Venn Diagrams.

	Below is an example of if we only wanted the data where the two circles overlap:
	SELECT <headers>
	FROM <table a name> <table a alias>
	INNER JOIN <table b name> <table b alias>
	ON <table a alias>.<key> = <table b alias>.<key>

	Below is an example of if we wanted all of the data from the left circle PLUS where the circles overlap
	SELECT <headers>
	FROM <table a name> <table a alias>
	LEFT JOIN <table b name> <table b alias>
	ON <table a alias>.<key> = <table b alias>.<key>

	Below is an example of if we wanted all of the data from the right circle PLUS where the circles overlap
	SELECT <headers>
	FROM <table a name> <table a alias>
	RIGHT JOIN <table b name> <table b alias>
	ON <table a alias>.<key> = <table b alias>.<key>

	Below is an example of if we wanted all of the data from both circles PLUS where the circles overlap
	SELECT <headers>
	FROM <table a name> <table a alias>
	FULL OUTER JOIN <table b name> <table b alias>
	ON <table a alias>.<key> = <table b alias>.<key>

	We'll practice this with some queries below, using the directors and directors_genres tables
*/

SELECT * FROM directors; -- Let's see what's in the directors table

SELECT * FROM directors_genres; -- Let's see what's in the directors_genres table

INSERT INTO directors_genres (DirectorId, Genre) -- I need some more data, because my directors actually make movies of many genres!
VALUES 
	(3, 'Action'),
	(2, 'Adventure'),
	(2, 'Fantasy'),
	(1, 'Romance');

SELECT d.FirstName, d.LastName, dg.Genre FROM directors d, directors_genres dg; -- Without a join, I seemingly have a lot of repeat information! This is confusing to look at!

SELECT d.FirstName, d.LastName, dg.Genre
FROM directors d INNER JOIN directors_genres dg -- Page 126 - 139
ON d.Id = dg.DirectorId; -- I'm saying that I want to only pull back data where the director ID is the same in both tables. But I still see multiple entries of the director's name because of the difference in genre

SELECT d.FirstName, d.LastName, dg.Genre
FROM directors d RIGHT JOIN directors_genres dg
ON d.Id = dg.DirectorId; -- This is technically pulling back everything from directors_genres and everything that matches with the director ID from directors. However, it's the same information. Why? Because there's no director that doesn't have an ID in directors_genres. Let's experiment!

INSERT INTO directors (FirstName, LastName)
VALUES ('Ron', 'Howard'); -- Add a new director, but do not add a record to directors_genres

SELECT * FROM directors; -- See our new addition

SELECT d.FirstName, d.LastName, dg.Genre
FROM directors d RIGHT JOIN directors_genres dg
ON d.Id = dg.DirectorId; -- Because Ron Howard does not have an entry in the directors_genres table, there is no overlap. We will not see Ron Howard returned

SELECT d.FirstName, d.LastName, dg.Genre
FROM directors d LEFT JOIN directors_genres dg
ON d.Id = dg.DirectorId -- Because we are grabbing everything from directors PLUS any overlap with directors_genres, we WILL see Ron Howard, but will see a NULL value for the Genre column!

SELECT d.FirstName, d.LastName, dg.Genre
FROM directors d FULL OUTER JOIN directors_genres dg
ON d.Id = dg.DirectorId -- Now we are grabbing everything from both tables, PLUS overlap. We are expecting to see the same results as last time, because there was nothing in the directors_genres table that wasn't included in the overlap.

-- Practice with GROUP BY, HAVING, ORDER BY (Pg. 165)
SELECT d.FirstName, d.LastName, COUNT(dg.Genre) AS 'Number of Genres Directed'
FROM directors d INNER JOIN directors_genres dg -- Page 126 - 139
ON d.Id = dg.DirectorId
GROUP BY d.FirstName, d.LastName; -- With GROUP BY we no longer see the duplicate entries of the directors' names

SELECT d.FirstName, d.LastName, COUNT(dg.Genre) AS 'Number of Genres Directed'
FROM directors d INNER JOIN directors_genres dg -- Page 126 - 139
ON d.Id = dg.DirectorId
GROUP BY d.FirstName, d.LastName -- (Pg. 165)
HAVING COUNT(dg.Genre) > 2; -- HAVING is like WHERE for aggregate functions (Pg. 165)

SELECT d.FirstName, d.LastName, COUNT(dg.Genre) AS 'Number of Genres Directed'
FROM directors d INNER JOIN directors_genres dg -- Page 126 - 139
ON d.Id = dg.DirectorId
GROUP BY d.FirstName, d.LastName
ORDER BY 'Number of Genres Directed' ASC; -- I can order by column sequence number or by column name. Here, I'm ordering by column name. Default sort is DESC.

SELECT d.FirstName, d.LastName, COUNT(dg.Genre) AS 'Number of Genres Directed'
FROM directors d INNER JOIN directors_genres dg -- Page 126 - 139
ON d.Id = dg.DirectorId
GROUP BY d.FirstName, d.LastName
ORDER BY 3 ASC; -- I can order by column sequence number or by column name. Here, I'm ordering by column sequence number. Default sort is DESC.

-- Practice with Subqueries (Pages 185 - 203)
SELECT * FROM movies; -- Let's preview our movies table so we can see all of the ranks

SELECT m.Id, m.Name, mg.Genre, m.Rank
FROM movies m INNER JOIN movies_genre mg
ON m.Id = mg.MovieId
WHERE m.Rank > 
	(
		SELECT AVG(Rank) -- Average is 357
		FROM movies
	)


