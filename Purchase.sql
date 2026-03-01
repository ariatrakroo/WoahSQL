CREATE DATABASE RETAIL;
USE RETAIL;
#Import data using wizard
SELECT * FROM CUSTOMER;

#CREATING TABLES FOR NUMBER CODES
CREATE TABLE Gender(
CODE INT PRIMARY KEY,
Gender VARCHAR(10));
INSERT INTO Gender(CODE, Gender) VALUES
(0,'Male'), (1,'Female');

CREATE TABLE Category(
CODE INT PRIMARY KEY,
Category VARCHAR(20));
INSERT INTO Category(CODE, Category) VALUES
(0,'Electronics'), (1,'Clothing'), 
(2,'Home Goods'), (3,'Beauty'),
(4,'Sports');

CREATE TABLE Loyalty(
CODE INT PRIMARY KEY,
Loyalty VARCHAR(10));
INSERT INTO Loyalty(CODE, Loyalty) VALUES
(0,'No'), (1,'Yes');


#identifying which demographics bring in the most value
#Check age range (18-70)
SELECT MIN(AGE) FROM CUSTOMER;
SELECT MAX(AGE) FROM CUSTOMER;

#break up into age groups using CASE
SELECT SUM(NumberofPurchases),
CASE
	WHEN Age BETWEEN 18 AND 25 THEN '18-25'
    WHEN Age BETWEEN 26 AND 35 THEN '26-35'
    WHEN Age BETWEEN 36 AND 49 THEN '36-49'
    WHEN Age BETWEEN 50 AND 60 THEN '50-60'
    WHEN Age BETWEEN 61 AND 70 THEN '61-70'
    END AS `Age category`
FROM Customer
GROUP BY `Age Category`
ORDER BY SUM(NumberofPurchases) DESC;

#In the 36-49 age category, which product categories are the most popular
SELECT 
CASE
	WHEN ProductCategory=0 THEN 'Electronics'
	WHEN ProductCategory=1 THEN 'Clothing'
	WHEN ProductCategory=2 THEN 'Home Goods'
	WHEN ProductCategory=3 THEN 'Beauty'
	WHEN ProductCategory=4 THEN 'Sports'
    END AS `Product Category`
,COUNT(ProductCategory)
FROM Customer
WHERE Age BETWEEN 36 AND 49
GROUP BY ProductCategory
ORDER BY COUNT(ProductCategory) DESC;

#Windows fn- Comparing Number of purchases within a category to avg purchases in that category
SELECT ProductCategory, NumberOfPurchases,
	AVG(NumberOfPurchases) OVER(PARTITION BY ProductCategory) AS AvgPurchCategory
FROM Customer
ORDER BY ProductCategory ASC;

#Checking correlation between time spent on site and no of purchases
SELECT MIN(TimeSpentOnWebsite/NumberOfPurchases),
		MAX(TimeSpentOnWebsite/NumberOfPurchases) 
FROM Customer;

SELECT NumberOfPurchases, TimeSpentOnWebsite,
CASE
	WHEN TimeSpentOnWebsite/NumberOfPurchases <20 THEN 'High Intent of Purchase'
    WHEN TimeSpentOnWebsite/NumberOfPurchases BETWEEN 20 AND 40 THEN 'Average Intent of Purchase'
    WHEN TimeSpentOnWebsite/NumberOfPurchases BETWEEN 40 AND 60 THEN 'Low Intent of Purchase'
	END AS `Level of intent of purchase`
FROM Customer
ORDER BY `Level of intent of purchase` ASC;
