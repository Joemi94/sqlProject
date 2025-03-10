# North American Retail Sales Analysis
## Project Overview
North America Retail is a major retail company operating in multiple locations, offering a wide range of products to different customer groups. They focus on excellent customer service and a smooth shopping experience.
## Data Source
The Dataset contains a total of 22 features and 1198 records. The dataset was obtained from myDataClique. It also include a Calender date file.
## Objectives
The goal of this analysis is to determined the following:
1. What was the Average delivery days for different product subcategory?
2. What was the Average delivery days for each segment ?
3.What are the Top 5 Fastest delivered products and Top 5 slowest delivered products?
4. Which product Subcategory generate most profit?
5. Which segment generates the most profit?
6. Which Top 5 customers made the most profit?
7. What is the total number of products by Subcategory?
## Tools Used
- SQL Server
- Microsoft Excel
## Data Cleaning/Preparation
The dataset was inspecting in Microsoft Excel for missing data and for duplicate records. There was no missing values recorded.
Data Modeling and other cleaning processes was done using SQL Server. 
![cap](https://github.com/user-attachments/assets/1b9c7ad9-7fe7-49dd-affc-e84e846b1a69)

## Result
### 1. What was the Average delivery days for different product subcategory?
~~~ sql
SELECT p.Sub_Category, AVG(DATEDIFF(DAY,o.Order_Date, o.Ship_Date)) AS Delivery_Days
	FROM OrdersTable as o LEFT JOIN DimProduct as p 
	ON o.Product_ID = p.Product_ID
	GROUP BY Sub_Category ORDER BY 2 DESC
/*
The Average Delivery Days based on Sub category is 36 days for Tables and 34, 32 and 32 for 
Furnishings, Chairs and Bookcases respectively. Tables has the Highest Average Delivery Days
while Bookcases and Chairs have the least delivery days.
*/
~~~
### 2. What was the Average delivery days for each segment ?
~~~ sql
SELECT Segment, AVG(DATEDIFF(DAY,Order_Date, Ship_Date)) AS Delivery_Days
	FROM OrdersTable 
	GROUP BY Segment ORDER BY 2 DESC
/*
Based on Segment, the Segment with the Highest Average of delivery days is Corporate with 35 Average
Days while Consumer and Home Office segment has an average of 34 and 31 days respectively.
*/
~~~
### 3.What are the Top 5 Fastest delivered products and Top 5 slowest delivered products?
~~~ sql
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
Contemporary Borderless Frame						    1
TOP 5 SLOWEST DELIVERY PRODUCT
Bevis Round Conference Room Tables and Bases					        167
Bush Mission Pointe Library										                123
Global Enterprise Series Seating Low-Back Swivel/Tilt Chairs	123
Bush Cubix Collection Bookcases, Fully Assembled				      103
Career Cubicle Clock, 8 1/4", Black								            102
*/
~~~
### 4. Which product Subcategory generate most profit?
~~~ sql
--Which product Subcategory generate most profit?
SELECT p.Sub_Category, ROUND(SUM(o.Profit),2) AS Total_Profit FROM OrdersTable AS o
	LEFT JOIN DimProduct AS p ON 
	o.Product_ID = p.Product_ID WHERE o.Profit > 0
	GROUP BY Sub_Category ORDER BY 2 DESC
/*
The Sub Category with the most profits is CHAIRS having a total of $36,471.10 as Profit while the least profiting 
Sub Category is Tables with $8,358.33
*/
~~~
### 5. Which segment generates the most profit?
~~~ sql
-- Which segment generates the most profit?
SELECT Segment, ROUND(SUM(Profit),2) AS Total_Profit FROM OrdersTable 
	WHERE Profit > 0
		GROUP BY Segment ORDER BY 2 DESC
/*
Analysing by Segment the most profiting segment is Consumer with a total of $35,427.03 as profit followed closely by
Corporate Segment and Home Office with a profit total of $23,655.96 and $13,657.04 with the least being Home Office.
*/
~~~
### 6. Which Top 5 customers made the most profit?
~~~ sql
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
~~~
### 7. What is the total number of products by Subcategory?
~~~ sql
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
~~~
## Summary Insights/Recommendations
1. Average Delivery Days for Different Product Subcategories
- Insight: Tables have the highest average delivery days (36 days), while Bookcases and Chairs have the lowest (32 days).
- Recommendation: Investigate the supply chain and logistics processes for Tables to identify bottlenecks causing the longer delivery times. Consider optimizing inventory management, supplier relationships, or shipping methods for this subcategory to reduce delivery times and improve customer satisfaction.
2. Average Delivery Days for Each Segment
- Insight: The Corporate segment has the highest average delivery days (35 days), while the Home Office segment has the lowest (31 days).
- Recommendation: Analyze the order fulfillment process for the Corporate segment to understand why it takes longer. Consider offering expedited shipping options or prioritizing corporate orders to reduce delivery times, as corporate clients may have higher expectations for timely delivery.
3. Top 5 Fastest and Slowest Delivered Products
- Insight: Some products like the "Executive Impressions 16-1/2" Circular Wall Clock" are delivered on the same day, while others like the "Bevis Round Conference Room Tables and Bases" take an average of 167 days.
- Recommendation: For products with extremely long delivery times, consider stocking more inventory or finding alternative suppliers to reduce lead times. For products with same-day delivery, use them as a selling point in marketing campaigns to attract customers who value fast delivery.
4. Product Subcategory Generating the Most Profit
- Insight: Chairs generate the most profit (36,471.10),whileTablesgeneratetheleast(36,471.10),whileTablesgeneratetheleast(8,358.33).
- Recommendation: Focus on promoting and expanding the Chairs subcategory, as it is the most profitable. Consider offering discounts or bundles on Tables to increase their sales volume and profitability. Additionally, analyze the cost structure of Tables to identify areas where margins can be improved.
5. Segment Generating the Most Profit
- Insight: The Consumer segment generates the most profit (35,427.03),followedbyCorporate(35,427.03),followedbyCorporate(23,655.96), and Home Office ($13,657.04).
- Recommendation: Continue to target the Consumer segment with tailored marketing campaigns and promotions. For the Corporate segment, consider offering bulk discounts or loyalty programs to increase profitability. For the Home Office segment, explore ways to increase sales, such as offering home office bundles or ergonomic product lines.
6. Top 5 Customers Generating the Most Profit
- Insight: Laura Armstrong, Joe Elijah, Seth Vernon, Quincy Jones, and Maria Etezadi are the top 5 customers generating the most profit.
- Recommendation: Implement a customer loyalty program or offer exclusive deals to these high-value customers to retain their business. Additionally, analyze their purchasing patterns to identify cross-selling or upselling opportunities.
7. Total Number of Products by Subcategory
- Insight: Furnishings have the highest product count (949), while Tables have the lowest (198).
- Recommendation: Consider expanding the product range in the Tables subcategory to offer more variety and attract a broader customer base. For Furnishings, focus on optimizing the product mix to ensure that the most profitable items are prominently featured and promoted.


