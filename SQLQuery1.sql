***************************
-- DATA INSERTION AND CLEANING
***************************
CREATE TABLE vgsales (
    [Rank] VARCHAR(10),
    [Name] VARCHAR(255),
    [Platform] VARCHAR(50),
    [Year] VARCHAR(50),
    [Genre] VARCHAR(50),
    [Publisher] VARCHAR(100),
    [NA_Sales] VARCHAR(50),
    [EU_Sales] VARCHAR(50),
    [JP_Sales] VARCHAR(50),
    [Other_Sales] VARCHAR(50),
    [Global_Sales] VARCHAR(50)
);

BULK INSERT vgsales
FROM "C:\Public\vgsales new.csv"
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

CREATE TABLE vgsales2 (
    [Rank] INT,
    [Name] VARCHAR(255),
    [Platform] VARCHAR(50),
    [Year] INT,
    [Genre] VARCHAR(50),
    [Publisher] VARCHAR(100),
    [NA_Sales] FLOAT,
    [EU_Sales] FLOAT,
    [JP_Sales] FLOAT,
    [Other_Sales] FLOAT,
    [Global_Sales] FLOAT
);

INSERT INTO vgsales2 (
    Rank, Name, Platform, Year, Genre, Publisher,
    NA_Sales, EU_Sales, JP_Sales, Other_Sales, Global_Sales
)
SELECT
    TRY_CAST(TRIM(Rank) AS INT),
    Name,
    Platform,
    TRY_CAST(TRIM(Year) AS INT),
    Genre,
    Publisher,
    TRY_CAST(TRIM(NA_Sales) AS FLOAT),
    TRY_CAST(TRIM(EU_Sales) AS FLOAT),
    TRY_CAST(TRIM(JP_Sales) AS FLOAT),
    TRY_CAST(TRIM(Other_Sales) AS FLOAT),
    TRY_CAST(TRIM(REPLACE(Global_Sales, CHAR(13), '')) AS FLOAT)  
FROM vgsales

-- view final table --
SELECT*FROM vgsales2

***************************************
-- 1. What are the top 5 publishers by sales?
***************************************
SELECT TOP 5 Publisher, ROUND(SUM(Global_Sales),2) as TotalSales
FROM vgsales2
GROUP BY Publisher
ORDER BY SUM(Global_Sales) DESC

**********************************
-- 2. What are Nintendo's top genres?
**********************************
SELECT TOP 5 Genre, ROUND(SUM(Global_Sales),2) as TotalSales
FROM vgsales2
WHERE Publisher = 'Nintendo'
GROUP BY Genre
ORDER BY TotalSales desc

***************************************************
-- 3. Which region yields the most sales for Nintendo?
***************************************************
SELECT ROUND(SUM(NA_Sales),2) as NA_SALES, ROUND(SUM(JP_Sales),2) AS JP_SALES, ROUND(SUM(Other_Sales),2) AS OTHER_SALES
FROM vgsales2
WHERE Publisher = 'Nintendo'

**********************************************
-- 4. What were Nintendo's top years of sales?
**********************************************
SELECT TOP 5 ROUND(SUM(Global_Sales),2) as YearlySales, Year
FROM vgsales2
WHERE Publisher = 'Nintendo'
GROUP BY Year
ORDER BY YearlySales desc


