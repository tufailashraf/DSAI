create schema retail_shop;

use retail_shop;

							-- BEGINNER QUERIES
                            
-- beginner_query_1. Define meta data in mysql workbench or any other SQL tool
describe online_retail;


-- beginner_query_2. What is the distribution of order values across all customers in the dataset?
SELECT
    CustomerID,
    SUM(Quantity * UnitPrice) AS TotalOrderValue
FROM
    online_retail
GROUP BY
    CustomerID
ORDER BY
    TotalOrderValue DESC;


-- beginner_query_3. How many unique products has each customer purchased?
SELECT
    CustomerID,
    COUNT(DISTINCT StockCode) AS UniqueProductsPurchased
FROM
    online_retail
GROUP BY
    CustomerID
ORDER BY
    UniqueProductsPurchased DESC;


-- beginner_query_4. Which customers have only made a single purchase from the company?
SELECT
    CustomerID
FROM
    online_retail
GROUP BY
    CustomerID
HAVING
    COUNT(DISTINCT InvoiceNo) = 1;


-- beginner_query_5. Which products are most commonly purchased together by customers in the dataset?
SELECT
    p1.StockCode AS Product1,
    p2.StockCode AS Product2,
    COUNT(*) AS Frequency
FROM
    online_retail p1
JOIN
    online_retail p2
ON
    p1.InvoiceNo = p2.InvoiceNo
AND
    p1.StockCode < p2.StockCode
GROUP BY
    p1.StockCode,
    p2.StockCode
ORDER BY
    Frequency DESC;





							-- ADVANCED QUERIES
                            
-- advanced_query_1. Customer Segmentation by Purchase Frequency
-- Group customers into segments based on their purchase frequency, such as high, medium, and low frequency 
-- customers. This can help you identify your most loyal customers and those who need more attention.
SELECT
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS PurchaseFrequency,
    CASE
        WHEN COUNT(DISTINCT InvoiceNo) > 10 THEN 'High Frequency'
        WHEN COUNT(DISTINCT InvoiceNo) BETWEEN 5 AND 10 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS CustomerSegment
FROM
    online_retail
GROUP BY
    CustomerID
ORDER BY
    PurchaseFrequency DESC;



-- advanced_query_2. Average Order Value by Country
-- Calculate the average order value for each country to identify where your most valuable customers are located.
SELECT
    Country,
    AVG(OrderValue) AS AverageOrderValue
FROM
    (
        SELECT
            InvoiceNo,
            Country,
            SUM(Quantity * UnitPrice) AS OrderValue
        FROM
            online_retail
        GROUP BY
            InvoiceNo, Country
    ) AS order_values
GROUP BY
    Country
ORDER BY
    AverageOrderValue DESC;




-- advanced_query_3. Customer Churn Analysis
-- Identify customers who haven't made a purchase in a specific period (e.g., last 6 months) to assess churn.
SELECT
    CustomerID,
    MAX(InvoiceDate) AS LastPurchaseDate
FROM
    online_retail
GROUP BY
    CustomerID
HAVING
    MAX(InvoiceDate) < DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
ORDER BY
    LastPurchaseDate DESC;



-- advanced_query_4. Product Affinity Analysis
-- Determine which products are often purchased together by calculating the correlation between product purchases.
SELECT
    p1.StockCode AS Product1,
    p2.StockCode AS Product2,
    COUNT(*) AS Frequency
FROM
    online_retail p1
JOIN
    online_retail p2
ON
    p1.InvoiceNo = p2.InvoiceNo
AND
    p1.StockCode < p2.StockCode
GROUP BY
    p1.StockCode, p2.StockCode
ORDER BY
    Frequency DESC;



-- advanced_query_5. Time-based Analysis
-- Explore trends in customer behavior over time, such as monthly or quarterly sales patterns.

SET SQL_SAFE_UPDATES = 0;
UPDATE online_retail
SET InvoiceDate = STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i')
WHERE InvoiceDate IS NOT NULL;



-- for monthly sales pattern
SELECT YEAR(InvoiceDate) AS Year, MONTH(InvoiceDate) AS Month, SUM(Quantity * UnitPrice) AS TotalSales
FROM online_retail
GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
ORDER BY Year, Month;
    
-- for quarterly sales pattern
SELECT YEAR(InvoiceDate) AS Year, QUARTER(InvoiceDate) AS Quarter, SUM(Quantity * UnitPrice) AS TotalSales
FROM online_retail
GROUP BY YEAR(InvoiceDate), QUARTER(InvoiceDate)
ORDER BY Year, Quarter;


										-- ---> THE END <--- --