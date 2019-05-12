/* Creating the database and checking if database exists already*/

USE master;

IF DB_ID('SDP_Movie_DB') IS NOT NULL
DROP DATABASE SDP_Movie_DB
Print 'Movie db exists and dropped';

CREATE DATABASE SDP_Movie_DB
PRINT 'Movie db was created'
GO

USE SDP_Movie_DB;

CREATE TABLE Movies (
	MovieID int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Title varchar(100),
	Release_Year int,
	Country varchar(50),
	Gross_Revenue money,
	Budget money,
	Facebook_Likes int,
	IMDB_Rating decimal(3,1),
	RottenTomatoes_Rating int
	);

CREATE TABLE Directors (
	DirectorID int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	FirstName varchar(50),
	LastName varchar(50)
	);

CREATE TABLE Movie_Directors (
	MovieID int FOREIGN KEY REFERENCES Movies(MovieID),
	DirectorID int FOREIGN KEY REFERENCES Directors(DirectorID)
	);

CREATE TABLE Sequels (
	MovieID int FOREIGN KEY REFERENCES Movies(MovieID),
	Sequel_Titles varchar(100)
	);

CREATE TABLE Actors (
	ActorID int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Act_FirstName varchar(50),
	Act_LastName varchar(50),
	Gender varchar(10)
	);

CREATE TABLE Movie_Actors (
	MovieID int FOREIGN KEY REFERENCES Movies(MovieID),
	ActorID int FOREIGN KEY REFERENCES Actors(ActorID),
	[Role] varchar(50)
	);

CREATE TABLE [Languages] (
	LanguageID int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Language] varchar(50),
	);

CREATE TABLE Movie_Language (
	MovieID int FOREIGN KEY REFERENCES Movies(MovieID),
	LanguageID int FOREIGN KEY REFERENCES [Languages](LanguageID)
	);

CREATE TABLE Genres (
	GenreID int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Genre_Category varchar(50)
	);

CREATE TABLE Movie_Genres (
	MovieID int FOREIGN KEY REFERENCES Movies(MovieID),
	GenreID int FOREIGN KEY REFERENCES Genres(GenreID)
	);

/* Insert data into the Movies table */

USE SDP_Movie_DB;

INSERT Movies (Title, Release_Year, Country, Gross_Revenue, Budget, Facebook_Likes, IMDB_Rating, RottenTomatoes_Rating)
VALUES ('[Rec]',2007,'Spain',0,1500000,15000,7.5,88),
	('[Rec] 2',2009,'Spain',27024,5600000,4000,6.6,68),
	('Avatar',2009,'USA',760505847,237000000,33000,7.9,82),
	('Terminator 2: Judgment Day',1991,'USA',204843350,102000000,13000,8.5,93),
	('Terminator 3: Rise of the Machines',2003,'USA',150350192,200000000,0,6.4,69),
	('Terminator Genisys',2015,'USA',89732035,155000000,82000,6.6,26),
	('Terminator Salvation',2009,'USA',125320003,200000000,0,6.6,33),
	('The Terminator',1984,'UK',38400000,6500000,0,8.1,100),	
	('The Transporter',2002,'France',25296447,21000000,0,6.8,54),
	('Transformers',2007,'USA',318759914,150000000,8000,7.1,57),
	('Transformers: Age of Extinction',2014,'USA',245428137,210000000,56000,5.7,18),
	('Transformers: Dark of the Moon',2011,'USA',352358779,195000000,46000,6.3,35),
	('Transformers: Revenge of the Fallen',2009,'USA',402076689,200000000,0,6,19),
	('Wanted',2008,'USA',134568845,75000000,0,6.7,71);

INSERT Directors (FirstName, LastName)
VALUES ('Jaume','Balaguer'),
	('James','Cameron'),
	('Jonathan','Mostow'),
	('Alan','Taylor'),
	('McG',''),
	('Louis','Leterrier'),
	('Michael','Bay'),
	('Timur','Bekmambetov');

INSERT Movie_Directors
VALUES (1,1),
	(2,1),
	(3,2),
	(4,2),
	(5,3),
	(6,4),
	(7,5),
	(8,2),
	(9,6),
	(10,7),
	(11,7),
	(12,7),
	(13,7),
	(14,8);

INSERT Sequels
VALUES (1,'[Rec] 2'),
	(4,'Terminator 3: Rise of the Machines'),
	(4,'Terminator Genisys'),
	(4,'Terminator Salvation'),
	(5,'Terminator Genisys'),
	(5,'Terminator Salvation'),
	(7,'Terminator Genisys'),
	(8,'Terminator 2: Judgment Day'),
	(8,'Terminator 3: Rise of the Machines'),
	(8,'Terminator Genisys'),
	(8,'Terminator Salvation'),
	(10,'Transformers: Age of Extinction'),
	(10,'Transformers: Dark of the Moon'),
	(10,'Transformers: Revenge of the Fallen'),
	(13,'Transformers: Age of Extinction'),
	(13,'Transformers: Dark of the Moon'),
	(12,'Transformers: Age of Extinction');

INSERT Actors (Act_FirstName, Act_LastName, Gender)
VALUES ('Manuela','Velasco','F'),
	('Jonathan D.','Mellor','M'),
	('CCH','Pounder','F'),
	('Joe','Mortin','M'),
	('Nick','Stahl','M'),
	('J.K.','Simmons','M'),
	('Christian','Bale','M'),
	('Michael','Biehn','M'),
	('Jason','Statham','M'),
	('Zack','Ward','M'),
	('Bingbing','Li','F'),
	('Glenn','Morshower','M'),
	('Angelina Jolie','Pitt','F');

INSERT Movie_Actors
VALUES (1,1,'Main'),
	(2,2,'Main'),
	(3,3,'Main'),
	(4,4,'Main'),
	(5,5,'Main'),
	(6,6,'Main'),
	(7,7,'Main'),
	(8,8,'Main'),
	(9,9,'Main'),
	(10,10,'Main'),
	(11,11,'Main'),
	(12,12,'Main'),
	(13,12,'Main'),
	(14,13,'Main');

INSERT [Languages] ([Language])
VALUES ('Spanish'),
	('English');		

INSERT Movie_Language
VALUES (1,1),
	(2,1),
	(3,2),
	(4,2),
	(5,2),
	(6,2),
	(7,2),
	(8,2),
	(9,2),
	(10,2),
	(11,2),
	(12,2),
	(13,2),
	(14,2);	

INSERT Genres (Genre_Category)
VALUES ('Action'),
	('Adventure'),
	('Crime'),
	('Fantasy'),
	('Horror'),
	('Thriller'),
	('Sci-Fi');

INSERT Movie_Genres
VALUES (1,5),
	(2,5),
	(3,1),
	(3,2),
	(3,4),
	(3,7),
	(4,1),
	(4,7),
	(5,1),
	(5,7),
	(6,1),
	(6,2),
	(6,7),
	(7,1),
	(7,2),
	(7,7),
	(8,1),
	(8,7),
	(9,1),
	(9,3),
	(9,6),
	(10,1),
	(10,2),
	(10,7),
	(11,1),
	(11,2),
	(11,7),
	(12,1),
	(12,2),
	(12,7),
	(13,1),
	(13,2),
	(13,7),
	(14,1),
	(14,3),
	(14,4),
	(14,6);	

/* Movies table already has a Primary Key as clustered index
therefore creating a non-clustered index in the Movies table */

USE SDP_Movie_DB;

CREATE INDEX IX_Movies_Title
	ON Movies(Title);

-- Creating non-clustered indexes for the remaining tables.
USE SDP_Movie_DB;

CREATE INDEX IX_Directors_LName
	ON Directors(LastName)

CREATE INDEX IX_Actors_LName
	ON Actors(Act_LastName);