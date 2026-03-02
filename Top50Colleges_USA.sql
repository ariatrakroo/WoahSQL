CREATE DATABASE UNIVERSITY;
USE UNIVERSITY;
SELECT * FROM top50;

#Creating a key for state names
CREATE TABLE STATES(
Code CHAR(2),
NAME VARCHAR(20)
);
INSERT INTO STATES (Code, NAME) VALUES 
("MA", "MASSACHUSETTES"),("NY","NEW YORK"),("NJ", "NEW JERSEY"),("CA", "CALIFORNIA"),
("MD", "MARYLAND"), ("CT", "CONNECTICUT"), ("PA", "PENNSYLVANIA"), ("TN", "TENNESSEE"), 
("TX", "TEXAS"), ("IL", "ILLINOIS"),("NH", "NEW HAMPSHIRE"),("RI", "RHODE ISLAND"),
("MI", "MICHIGAN"),("NC", "NORTH CAROLINA"),("MO", "MISSOURI"),("GA", "GEORGIA"),("FL", "FLORIDA"),
("IN", "INDIANA"),("VA", "VIRGINIA"),("ME", "MAINE"),("UT", "UTAH"),("DC", "DISTRICT OF COLUMBIA"),("WA", "WASHINGTON");
SELECT * FROM STATES;

#Q1 List the top 10 Public universities located in California or New York, ordered by their National Rank
SELECT University_Name, National_Rank, State
FROM top50
WHERE State="CA" OR State="NY"
ORDER BY National_Rank
LIMIT 10;

#Q2 Find the average Employment Rate for Private vs Public
SELECT Institution_Type, AVG(Employment_Rate)
FROM TOP50
GROUP BY Institution_Type;

#Q3 For every university, show its Name, State, and its rank within its own state based on the National Rank
SELECT T.University_Name, S.NAME AS State_Name, T.National_Rank,
		RANK() OVER(PARTITION BY T.STATE ORDER BY T.National_Rank) AS State_Rank
FROM TOP50 AS T
JOIN STATES AS S ON T.STATE=S.CODE
ORDER BY S.NAME, STATE_RANK;

#Q4 Categorize universities into 'Historical' (founded before 1900), 
#	Modern' (1900–1980), and 'Contemporary' (post-1980). 
#	Count how many universities fall into each category.
SELECT 
CASE 
	WHEN Founded_Year <1900 THEN "Historical"
	WHEN Founded_Year BETWEEN 1900 AND 1980 THEN "Modern"
	WHEN Founded_Year >1980 THEN "Contemporary"
END AS `Uni Status`
,COUNT(University_Name)
FROM TOP50
GROUP BY `Uni Status`;

#Q5 Find the average Research_Impact_Score for each State. Only show states where the average score is above 80
SELECT S.NAME, AVG(T.Research_Impact_Score) AS State_avg_ResearchImpact
FROM TOP50 AS T
JOIN STATES AS S
ON T.STATE=S.CODE 
GROUP BY S.NAME HAVING State_avg_ResearchImpact>80
ORDER BY State_avg_ResearchImpact;

#Q6 Within each State, find the university with the highest International Student Ratio
WITH RANKED_STUDENTS AS(
SELECT University_Name, State, Intl_Student_Ratio,
	RANK() OVER(PARTITION BY State ORDER BY Intl_Student_Ratio) as Intl_Student_Rank
FROM TOP50
)
SELECT
University_Name, State, Intl_Student_Ratio
FROM RANKED_STUDENTS
WHERE Intl_Student_Rank=1;