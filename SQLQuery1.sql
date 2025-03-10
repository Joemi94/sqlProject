
SELECT * FROM Retail_Sales;

-- Separating into Fact and Dimension Tables
SELECT * INTO DimCustomer
	FROM 
		(SELECT customer_ID, Customer_Name FROM Retail_Sales) 
		AS DimC;
-- To remove Duplicates
WITH CTE_DimC
AS 
	(SELECT Customer_ID, Customer_Name, ROW_NUMBER() OVER 
	(PARTITION BY Customer_ID, Customer_Name ORDER BY Customer_ID ASC) AS RowNumber
	FROM DimCustomer
	)
DELETE FROM CTE_DimC 
WHERE RowNumber > 1

-- Creating Location Table
SELECT * INTO DimLocation
	FROM 
		(SELECT Postal_Code,Country, City, State, Region FROM Retail_Sales)
		AS DimLoc;
--Removing duplicates rows
WITH CTE_DimLoc
AS
	(SELECT Postal_Code,Country, City, State, Region, ROW_NUMBER() OVER 
	(PARTITION BY Postal_Code,Country, City, State, Region ORDER BY Postal_Code ASC) AS RowNum
	FROM DimLocation
	)

DELETE FROM CTE_DimLoc 
WHERE RowNum > 1;

--Selecting/Creating DimProduct Table
DROP TABLE DimProduct
SELECT * INTO DimProduct
	FROM 
		(SELECT Product_ID, Category, Sub_Category FROM Retail_Sales)
		AS DimP

WITH CTE_DimPro
AS 
	(SELECT Product_ID, Category, Sub_Category, ROW_NUMBER() OVER (
	PARTITION BY Product_ID, Category, Sub_Category ORDER BY Product_ID) AS RowNum 
	FROM DimProduct
	)
DELETE FROM CTE_DimPro
WHERE RowNum >1

-- Creating Calendar Date
SELECT * FROM Calendar_Date

-- Creating the Order Sales Fact table

SELECT * INTO OrdersTable
	FROM 
		(SELECT Order_ID, Order_Date, Ship_Date, Ship_Mode, Product_Name, Customer_ID, Segment, Postal_Code,Product_ID,Returned, Sales, 
		Quantity, Discount, Profit FROM Retail_Sales ) AS DimOrder;

WITH CTE_Order
	AS 
		(SELECT Order_ID, Order_Date, Ship_Date, Ship_Mode,Product_Name, Customer_ID, Segment, Postal_Code,Product_ID,Returned, Sales, 
		Quantity, Discount, Profit,ROW_NUMBER () OVER (PARTITION BY Order_ID, Order_Date, Ship_Date, Ship_Mode,Product_Name, Customer_ID, Segment, Postal_Code,Product_ID,Returned, Sales, 
		Quantity, Discount, Profit ORDER BY Order_ID) AS RowNum 
		FROM OrdersTable
		)

DELETE FROM CTE_Order
WHERE RowNum > 1
ALTER TABLE OrdersTable
ADD Row_ID INT IDENTITY(1,1)

-- 1. What was the Average delivery days for different product subcategory?
SELECT p.Sub_Category, AVG(DATEDIFF(DAY,o.Order_Date, o.Ship_Date)) AS Delivery_Days
	FROM OrdersTable as o LEFT JOIN DimProduct as p 
	ON o.Product_ID = p.Product_ID
	GROUP BY Sub_Category ORDER BY 2 DESC
/*
The Average Delivery Days based on Sub category is 36 days for Tables and 34, 32 and 32 for 
Furnishings, Chairs and Bookcases respectively. Tables has the Highest Average Delivery Days
while Bookcases and Chairs have the least delivery days.
*/

-- What was the Average delivery days for each segment ?
SELECT Segment, AVG(DATEDIFF(DAY,Order_Date, Ship_Date)) AS Delivery_Days
	FROM OrdersTable 
	GROUP BY Segment ORDER BY 2 DESC
/*
Based on Segment, the Segment with the Highest Average of delivery days is Corporate with 35 Average
Days while Consumer and Home Office segment has an average of 34 and 31 days respectively.
*/

-- What are the Top 5 Fastest delivered products and 
SELECT TOP 5(Product_Name), AVG(DATEDIFF(DAY, Order_Date, Ship_Date)) AS Delivery_Days
	FROM OrdersTable GROUP BY Product_Name ORDER BY 2 ASC
-- Top 5 slowest delivered products?
SELECT TOP 5(Product_Name), AVG(DATEDIFF(DAY, Order_Date, Ship_Date)) AS Delivery_Days
	FROM OrdersTable GROUP BY Product_Name ORDER BY 2 DESC
/*
The Product with the Fastest delivery days (on Average) is Executive Impression 16-1/2' Circular Wall Clock,
Linden 12" Wall Clock with Oak Frame and Nu-Dell EZ-Mount Plastic Wall Frame with the average of 0 day which
means were delivery that same day of order while the product with the slowest delivery rate is Bevis Round
Round Conference Room Tables and Bases with an Average of 167 days of delivery.
TOP 5 FASTEST DELIVERY PRODUCT
Executive Impressions 16-1/2" Circular Wall Clock	0
Linden 12" Wall Clock With Oak Frame				0
Nu-Dell EZ-Mount Plastic Wall Frames				0
Bevis Boat-Shaped Conference Table					1
Contemporary Borderless Frame						1
TOP 5 SLOWEST DELIVERY PRODUCT
Bevis Round Conference Room Tables and Bases					167
Bush Mission Pointe Library										123
Global Enterprise Series Seating Low-Back Swivel/Tilt Chairs	123
Bush Cubix Collection Bookcases, Fully Assembled				103
Career Cubicle Clock, 8 1/4", Black								102
*/

--Which product Subcategory generate most profit?SELECT p.Sub_Category, ROUND(SUM(o.Profit),2) AS Total_Profit FROM OrdersTable AS o
	LEFT JOIN DimProduct AS p ON 
	o.Product_ID = p.Product_ID WHERE o.Profit > 0
	GROUP BY Sub_Category ORDER BY 2 DESC
/*
The Sub Category with the most profits is CHAIRS having a total of $36,471.10 as Profit while the least profiting 
Sub Category is Tables with $8,358.33
*/

-- Which segment generates the most profit?
SELECT Segment, ROUND(SUM(Profit),2) AS Total_Profit FROM OrdersTable 
	WHERE Profit > 0
		GROUP BY Segment ORDER BY 2 DESC
/*
Analysing by Segment the most profiting segment is Consumer with a total of $35,427.03 as profit followed closely by
Corporate Segment and Home Office with a profit total of $23,655.96 and $13,657.04 with the least being Home Office.
*/

-- Which Top 5 customers made the most profit?
SELECT TOP 5 (c.Customer_Name), ROUND(SUM(o.Profit),2) AS Total_Profit 
	FROM OrdersTable AS o LEFT JOIN DimCustomer AS c
	ON o.Customer_ID = c.customer_ID 
	WHERE o.Profit > 0
	GROUP BY c.Customer_Name ORDER BY 2 DESC
/*
The top 5 Costomers with the most profits are:
Laura Armstrong	$1156.17
Joe Elijah		$1121.6
Seth Vernon		$1047.14
Quincy Jones	$1013.13
Maria Etezadi	$822.65
*/

-- What is the total number of products by Subcategory
SELECT p.Sub_Category, count(o.Product_ID) AS Product_Count
	FROM OrdersTable AS o LEFT JOIN DimProduct AS p
	ON o.Product_ID = p.Product_ID
	GROUP BY Sub_Category ORDER BY 2 DESC
/*
Based on Sub category the Following are the product count by sub Category with Furnishings topping the list with
949 product counts and table the least with 198 count.
Furnishings	949
Chairs		611
Bookcases	221
Tables		198
*/