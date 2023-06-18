CREATE TABLE Reviewers (
    ID INT,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50)
)

CREATE TABLE Series (
    ID INT,
    Title VARCHAR(50),
    Year_of_Release INT,
    Genre VARCHAR(50)
)

CREATE TABLE Reviews (
    ID INT,
    rating INT,
    series_ID INT,
    Reviewer_ID INT
)
INSERT INTO Series VALUES 
    (1, 'Archer', 2009, 'Animation'),
    (2, 'Arrested Development', 2003, 'Comedy'),
    (3, 'Bobs Burgers', 2011, 'Animation'),
    (4, 'Bojack Horseman', 2014, 'Animation'),
    (5, 'Breaking Bad', 2008, 'Drama'),
    (6, 'Curb Your Enthusiasm', 2000, 'Comedy'),
    (7, 'Fargo', 2014, 'Drama'),
    (8, 'Freaks and Geeks', 1999, 'Comedy'),
    (9, 'General Hospital', 1963, 'Drama'),
    (10, 'Halt and Catch Fire', 2014, 'Drama'),
    (11, 'Malcolm and The Middle', 2000, 'Comedy'),
    (12, 'Pushing Daisies', 1989, 'Comedy'),
    (13, 'Seinfeld', 1989, 'Comedy'),
    (14, 'Stranger Things', 2016, 'Drama')

INSERT INTO Reviewers VALUES
    (1, 'Thomas', 'Stoneman'),
    (2, 'Wyatt', 'Skaggs'),
    (3, 'kimbra', 'Masters'),
    (4, 'Domingo', 'Cortes'),
    (5, 'Colt', 'Steele'),
    (6, 'Pinkie', 'Petit'),
    (7, 'Marlon', 'Crafford')

INSERT INTO Reviews(ID, series_id, reviewer_id, rating) VALUES
    (1,1,1,8.0),(2,1,2,7.5),(3,1,3,8.5),(4,1,4,7.7),(5,1,5,8.9),
    (6,2,1,8.1),(7,2,4,6.0),(8,2,3,8.0),(9,2,6,8.4),(10,2,5,9.9),
    (11,3,1,7.0),(12,3,6,7.5),(13,3,4,8.0),(14,3,3,7.1),(15,3,5,8.0),
    (16,4,1,7.5),(17,4,3,7.8),(18,4,4,8.3),(19,4,2,7.6),(20,4,5,8.5),
    (21,5,1,9.5),(22,5,3,9.0),(23,5,4,9.1),(24,5,2,9.3),(25,5,5,9.9),
    (26,6,2,6.5),(27,6,3,7.8),(28,6,4,8.8),(29,6,2,8.4),(30,6,5,9.1),
    (31,7,2,9.1),(32,7,5,9.7),
    (33,8,4,8.5),(34,8,2,7.8),(35,8,6,8.8),(36,8,5,9.3),
    (37,9,2,5.5),(38,9,3,6.8),(39,9,4,5.8),(40,9,6,4.3),(41,9,5,4.5),
    (42,10,5,9.9),
    (43,13,3,8.0),(44,13,4,7.2),
    (45,14,2,8.5),(46,14,3,8.9),(47,14,4,8.9)

-- The average rating of that every reviewer gave to each title // the highest average rated titles were Halt and Catch Fire, Fargo and Breaking Bad
SELECT Series.ID, series_ID, Title, AVG(rating) AS Average_Rating
FROM Series
JOIN Reviews
    ON Series.ID = Reviews.series_ID
GROUP BY Series.ID, series_ID, Title
ORDER BY ID

-- Finding the the two titles that were not reviewed, this is done by incorporating a full join into my Query // The two titles are Malcom and The Middle & Pushing Daisies
SELECT *
FROM Series
Full JOIN Reviews
    ON series.ID = Reviews.series_ID
WHERE series_ID is NULL

-- The Average rating for our 3 Genre catagories
SELECT Genre, ROUND(AVG(rating), 2) AS Average_Genre
FROM Series
JOIN Reviews
    ON Series.ID = Reviews.series_ID
Group BY Genre

-- Successfully Joined  3 tables together to display valued infomation that was not accesssible proir 
SELECT Title, rating, First_Name, Last_Name, Genre
FROM Reviewers
JOIN Reviews
    ON Reviewers.ID = Reviews.Reviewer_ID
JOIN Series
    ON Reviews.series_ID = Series.ID