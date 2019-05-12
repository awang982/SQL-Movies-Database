/* Showing the Movies table*/

USE SDP_Movie_DB;

SELECT *
FROM Movies;

-- Cleaning up the data on the Movies Table
UPDATE Movies
SET 
	Facebook_Likes = NULL
WHERE
	Facebook_Likes = 0;

UPDATE Movies
SET 
	Gross_Revenue = NULL
WHERE
	Gross_Revenue = 0;

--Add a check constraint to check for values of zero from the Movies Table

ALTER TABLE Movies WITH CHECK
ADD CONSTRAINT Check_FBLikes_Values
	CHECK (Facebook_Likes >= 0),
	CONSTRAINT Check_GR_Values
	CHECK (Gross_Revenue >= 0),
	CONSTRAINT Check_IMDB
	CHECK (IMDB_Rating >= 0 AND IMDB_Rating <= 10),
	CONSTRAINT Check_RT
	CHECK (RottenTomatoes_Rating >= 0 AND RottenTomatoes_Rating <= 100);


/*Identifying the most popular Genre Categories on Facebook by likes
using multiple JOINs, SUM, and GROUP BY */

USE SDP_Movie_DB;

SELECT Ge.Genre_Category,
	SUM(Mo.Facebook_Likes) AS Total_FB_Likes
FROM Movies AS Mo
JOIN Movie_Genres AS Mg
ON Mo.MovieID = Mg.MovieID
JOIN Genres AS Ge
ON Mg.GenreID = Ge.GenreID
GROUP BY Ge.Genre_Category
ORDER BY Total_FB_Likes DESC;


/*Listing out all the movies with sequels with multiple joins*/

USE SDP_Movie_DB;

SELECT Title,
	FirstName + ' ' + LastName AS Director,
	Sequel_Titles
FROM Movies
JOIN Movie_Directors
ON Movies.MovieID = Movie_Directors.MovieID
JOIN Directors
ON Movie_Directors.DirectorID = Directors.DirectorID
JOIN Sequels
ON Movies.MovieID = Sequels.MovieID
GROUP BY Title, LastName, FirstName, Sequel_Titles;

/*Modifying the list of all the movies with sequels and using a 
COUNT to identify the movie with the most amount of sequels*/

USE SDP_Movie_DB;

SELECT Title,
	FirstName + ' ' + LastName AS Director,
	COUNT(Sequel_Titles) AS Num_Of_Sequels
FROM Movies
JOIN Movie_Directors
ON Movies.MovieID = Movie_Directors.MovieID
JOIN Directors
ON Movie_Directors.DirectorID = Directors.DirectorID
JOIN Sequels
ON Movies.MovieID = Sequels.MovieID
GROUP BY Title, LastName, FirstName
ORDER BY Num_Of_Sequels DESC;


/*Modifying the list of all the movies with sequels and using a 
SUM to identify the sequels with the most overall gross revenue*/

USE SDP_Movie_DB;

SELECT Title,
	FirstName + ' ' + LastName AS Director,
	SUM(Gross_Revenue) AS Revenue
FROM Movies
JOIN Movie_Directors
ON Movies.MovieID = Movie_Directors.MovieID
JOIN Directors
ON Movie_Directors.DirectorID = Directors.DirectorID
JOIN Sequels
ON Movies.MovieID = Sequels.MovieID
GROUP BY Title, LastName, FirstName
HAVING Title = 'The Terminator' OR Title = 'Transformers' OR Title = '[Rec]'
ORDER BY Revenue DESC;

/*Create View for all the tables*/

CREATE VIEW V_Movies
AS SELECT Title,
	Release_Year,
	Country,
	Gross_Revenue,
	Budget,
	(Gross_Revenue - Budget) AS Profit,
	Facebook_Likes,
	IMDB_Rating,
	RottenTomatoes_Rating
FROM Movies
WHERE Gross_Revenue IS NOT NULL;

CREATE VIEW V_Directors
AS SELECT Title,
	Release_Year,
	Country,
	(Gross_Revenue - Budget) AS Profit,
	FirstName + ' ' + LastName AS Director
FROM Movies AS mo
JOIN Movie_Directors AS md
ON mo.MovieID = md.MovieID
JOIN Directors AS di
ON md.DirectorID = di.DirectorID;

CREATE VIEW V_Sequels
AS SELECT Title,
	Release_Year,
	Country,
	Sequel_Titles
FROM Movies AS mo
JOIN Sequels AS seq
ON mo.MovieID = seq.MovieID;

CREATE VIEW V_Movie_Actor
AS SELECT Title,
	Release_Year,
	Country,
	Gross_Revenue,
	Act_FirstName + ' ' + Act_LastName AS Actor,
	Gender,
	[Role]
FROM Movies AS mo
JOIN Movie_Actors AS ma
ON mo.MovieID = ma.MovieID
JOIN Actors AS ac
ON ma.ActorID = ac.ActorID;

CREATE VIEW V_Language
AS SELECT Title,
	Release_Year,
	Country,
	[Language]
FROM Movies AS mo
JOIN Movie_Language AS ml
ON mo.MovieID = ml.MovieID
JOIN [Languages] AS la
ON ml.LanguageID = la.LanguageID;

CREATE VIEW V_Genres
AS SELECT Title,
	Release_Year,
	Country,
	Genre_Category
FROM Movies AS mo
JOIN Movie_Genres AS mg
ON mo.MovieID = mg.MovieID
JOIN Genres AS ge
ON mg.GenreID = ge.GenreID;

/*Stored Procedure for Profit Range, which only shows results with Positive Profits*/

USE SDP_Movie_DB;
GO
CREATE PROC spProfitRange
	@PercentProfit decimal(5,2) = 0,
	@CeilingorFloor varchar(50) = 'Floor'
AS

IF @CeilingorFloor = 'Floor'
	BEGIN
		SELECT Title,
			Release_Year,
			Country,
			Gross_Revenue,
			Budget,
			(Gross_Revenue - Budget) AS Profit
		FROM Movies
		WHERE Gross_Revenue IS NOT NULL
AND ((Gross_Revenue - Budget) / Budget) >= @PercentProfit
ORDER BY Profit DESC;
	END;
ELSE IF @CeilingorFloor = 'Ceiling'
	BEGIN
		SELECT Title,
			Release_Year,
			Country,
			Gross_Revenue,
			Budget,
			(Gross_Revenue - Budget) AS Profit
		FROM Movies
		WHERE Gross_Revenue IS NOT NULL
AND ((Gross_Revenue - Budget) / Budget) <= @PercentProfit
AND ((Gross_Revenue - Budget) / Budget) >= 0
ORDER BY Profit DESC;
	END;
ELSE
	BEGIN
		PRINT 'Invalid CeilingorFloor value.  Only use string ''Ceiling'' or ''Floor''';
	END;

/*Creating a funtion that finds the most profitable movie Title*/

USE SDP_Movie_DB;
GO

CREATE FUNCTION MostProfitTitle ()
	RETURNS int
BEGIN
	RETURN
		(SELECT MIN(MovieID)
		FROM Movies
		WHERE (Gross_Revenue - Budget) > 0 AND
			(Gross_Revenue - Budget) = 
			(SELECT TOP 1 (Gross_Revenue - Budget)
			FROM Movies
			ORDER BY (Gross_Revenue - Budget) DESC
			)
		);

END;


/*Creating a funtion that finds the movie Title with the highest profit margin*/

USE SDP_Movie_DB;
GO

CREATE FUNCTION MostProfitMarginTitle ()
	RETURNS int
BEGIN
	RETURN
		(SELECT MIN(MovieID)
		FROM Movies
		WHERE ((Gross_Revenue - Budget) / Budget) > 0 AND
			((Gross_Revenue - Budget) / Budget) = 
			(SELECT TOP 1 ((Gross_Revenue - Budget) / Budget)
			FROM Movies
			ORDER BY ((Gross_Revenue - Budget) / Budget) DESC
			)
		);

END;


/* Creating a function that performs a simple Title search */

USE SDP_Movie_DB;
GO

CREATE FUNCTION TitleSearch (@Keyword varchar(100))
	RETURNS TABLE
RETURN
	(
	SELECT * 
	FROM Movies 
	WHERE Title LIKE CONCAT('%',@Keyword,'%')
	);

/* Using the Stored Procedure spProfitRange*/

/* Checking all the movies that made over 100% Profit*/

USE SDP_Movie_DB;

EXEC spProfitRange @PercentProfit = 1;

/* Checking all the movies that made less than 100% Profit but still positive cashflow*/

USE SDP_Movie_DB;

EXEC spProfitRange @PercentProfit = 1, @CeilingorFloor = "Ceiling";

/* Checking all the movies that made a Profit*/

USE SDP_Movie_DB;

EXEC spProfitRange @PercentProfit = 0, @CeilingorFloor = "Floor";

/* Output most of the results including movies that made negative cashflow*/

USE SDP_Movie_DB;

EXEC spProfitRange @PercentProfit = -10, @CeilingorFloor = "Floor";

/* Finding the most profitable movie title versus the highest Profit Margin movie title in the database using the function MostProfitTitle() and MostProfitMarginTitle() and a UNION*/

SELECT *,
	(Gross_Revenue - Budget) AS Profit,
	((Gross_Revenue - Budget) / Budget) AS ProfitMargin,
	'Most Profitable' AS [Status]
FROM Movies
WHERE MovieID = dbo.MostProfitTitle()
UNION
SELECT *,
	(Gross_Revenue - Budget) AS Profit,
	((Gross_Revenue - Budget) / Budget) AS ProfitMargin,
	'Highest Margin' AS [Status]
FROM Movies
WHERE MovieID = dbo.MostProfitMarginTitle();

/*Performing a search for Titles of the keyword "Tran" */

SELECT *
FROM TitleSearch('Tran');

/*Lists movies with a sequel using a subquery*/

USE SDP_Movie_DB;

SELECT Title,
	Release_Year
FROM Movies
WHERE MovieID IN 
		(SELECT MovieID 
		FROM Sequels)
	OR Title IN
		(SELECT Sequel_Titles 
		FROM Sequels);

/*Sample of the V_Movie_Actor View sorted by Actor name*/

USE SDP_Movie_DB;

SELECT *
FROM V_Movie_Actor
ORDER BY Actor;

/*Finding the highest rated movies using filters in the HAVING clause 
with additional Actor.  Result is ordered by rating in descending order.*/

USE SDP_Movie_DB;

SELECT Title,
	CAST(AVG(IMDB_Rating) AS DECIMAL (3,1)) AS AVG_IMDB_Score,
	CAST(AVG(RottenTomatoes_Rating) AS DECIMAL (4,1)) AS AVG_RT_Score,
	Act_FirstName + ' ' + Act_LastName AS Actor
FROM Movies AS mo
JOIN Movie_Actors AS ma
ON mo.MovieID = ma.MovieID
JOIN Actors AS ac
ON ma.ActorID = ac.ActorID
GROUP BY Title, Act_FirstName, Act_LastName
HAVING AVG(IMDB_Rating) >= 6.8 AND AVG(RottenTomatoes_Rating) >= 65
ORDER BY AVG_IMDB_Score DESC, AVG_RT_Score DESC;

/* Creating a role with SELECT ability for the database and
INSERT and UPDATE for the Movies Table*/

USE SDP_Movie_DB;

CREATE ROLE DataEntry;

GRANT INSERT,UPDATE
  ON Movies
  TO DataEntry;

ALTER ROLE db_datareader ADD MEMBER DataEntry;
