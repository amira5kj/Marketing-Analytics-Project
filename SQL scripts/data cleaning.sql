-- insepecting the data and checking it's quality


-----customer_journey----- 
SELECT * FROM customer_journey  --> action is the most important col here

  -->making sure PK is not duplicated or null
SELECT JourneyID , COUNT (*)
FROM customer_journey
GROUP BY JourneyID
HAVING COUNT (*)>1 or JourneyID IS NULL
--> there are 79 duplicated row


SELECT DISTINCT(JourneyID),
		   CustomerID,
		   ProductID,
		   VisitDate,
		   Stage,
		   Action,
		   Duration
FROM customer_journey

-->> are there customers that dont belong to the customers table?
SELECT * 
FROM customer_journey cj
JOIN customers c
ON cj.CustomerID=c.CustomerID
WHERE c.CustomerID IS NULL
--NOTHING 

-->>checking data consistency for Stage,Action
SELECT DISTINCT(Action)
FROM customer_journey

SELECT DISTINCT(Stage)
FROM customer_journey
-- the data is consistent
-->> for the duration > keep nulls as is

-------products----------
SELECT * FROM products 
--there is only one category so we are gonna remove this column
--we are gonna add categorization to the price amd check for outliers
SELECT MIN(Price), MAX(Price) FROM products

SELECT ProductID,
       ProductName,
	   Price,
	   CASE
	       WHEN Price <50 THEN 'Low'
		   WHEN Price BETWEEN 50 AND 200 THEN 'Medium'
		   WHEN Price > 200 THEN 'HIGH'
	   END AS PriceCategory
FROM products 

------customers--------
SELECT * FROM customers

SELECT CustomerID,COUNT(*)
FROM customers
GROUP BY CustomerID
HAVING COUNT (*)>1 or CustomerID IS NULL
-- no duplicates or nuls in the pk
--no nulls in any row or column

--checking for outliers
SELECT MIN(age),MAX(age) FROM customers

--geography
SELECT * FROM geography

-->combing customers with geography
SELECT c.CustomerID,
	     c.CustomerName,
	     c.Email,
	     c.Gender,
	     c.Age,
	     g.Country,
	     g.City
FROM customers c
JOIN geography g
on c.GeographyID=g.GeographyID

-----customer_reviews-----
SELECT * FROM customer_reviews

SELECT 
distinct(replace(ReviewText,'  ',' ')) FROM customer_reviews

------ engagement_data------
SELECT * FROM engagement_data

--clean and normalize the engagement_data table
SELECT 
    EngagementID,  
    ContentID, 
  	CampaignID, 
    ProductID,  
    UPPER(REPLACE(ContentType, 'Socialmedia', 'Social Media')) AS ContentType, 
    LEFT(ViewsClicksCombined, CHARINDEX('-', ViewsClicksCombined) - 1) AS Views,  
    RIGHT(ViewsClicksCombined, LEN(ViewsClicksCombined) - CHARINDEX('-', ViewsClicksCombined)) AS Clicks,  
    Likes,  
    FORMAT(CONVERT(DATE, EngagementDate), 'dd.MM.yyyy') AS EngagementDate  
FROM 
    dbo.engagement_data 
WHERE 
    ContentType != 'Newsletter';  -- Filters out rows where ContentType is 'Newsletter' as these are not relevant for our analysis
