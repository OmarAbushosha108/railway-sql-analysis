Create Database RailwayDB
Use RailwayDB

SELECT TOP (10) *
FROM dbo.railway;

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'railway'
ORDER BY ORDINAL_POSITION;

--------------------------------------------------------------------------------------
--General Trip Analysis--

-- 1- Total Transactions
SELECT COUNT(*) AS Total_Transactions
FROM dbo.railway;

-- 2- Total Revenue
SELECT SUM(CAST(Price AS DECIMAL(10,2))) AS Total_Revenue
FROM dbo.railway;

-- 3- Top Departure Stations
SELECT Departure_Station, COUNT(*) AS Trips
FROM dbo.railway
GROUP BY Departure_Station
ORDER BY Trips DESC;

-- 4- Top Arrival Destinations
SELECT Arrival_Destination, COUNT(*) AS Trips
FROM dbo.railway
GROUP BY Arrival_Destination
ORDER BY Trips DESC;

--------------------------------------------------------------------------------------
--Timing & Delay Analysis--

-- 5- Delayed Trips Count
SELECT COUNT(*) AS Delayed_Trips
FROM dbo.railway
WHERE Actual_Arrival_Time IS NOT NULL 
  AND Arrival_Time IS NOT NULL
  AND DATEDIFF(MINUTE, Arrival_Time, Actual_Arrival_Time) > 0;

-- 6- Average Delay (Minutes)
SELECT AVG(DATEDIFF(MINUTE, Arrival_Time, Actual_Arrival_Time)) AS Avg_Delay_Minutes
FROM dbo.railway
WHERE Actual_Arrival_Time IS NOT NULL 
  AND Arrival_Time IS NOT NULL
  AND DATEDIFF(MINUTE, Arrival_Time, Actual_Arrival_Time) > 0;

-- 7- Top 5 Delaying Departure Stations
SELECT TOP 5 Departure_Station,
       COUNT(*) AS Delayed_Trips,
       AVG(DATEDIFF(MINUTE, Arrival_Time, Actual_Arrival_Time)) AS Avg_Delay_Minutes
FROM dbo.railway
WHERE Actual_Arrival_Time IS NOT NULL 
  AND Arrival_Time IS NOT NULL
  AND DATEDIFF(MINUTE, Arrival_Time, Actual_Arrival_Time) > 0
GROUP BY Departure_Station
ORDER BY Delayed_Trips DESC;

-- 8- Delay Rate (%)
SELECT 
  CAST(SUM(CASE 
             WHEN Actual_Arrival_Time IS NOT NULL AND Arrival_Time IS NOT NULL 
                  AND DATEDIFF(MINUTE, Arrival_Time, Actual_Arrival_Time) > 0 
             THEN 1 ELSE 0 END) AS FLOAT) / 
  NULLIF(COUNT(*), 0) * 100 AS Delay_Rate_Percent
FROM dbo.railway;

-- 9- Most Delayed Routes
SELECT 
  Departure_Station + ' -> ' + Arrival_Destination AS Route,
  COUNT(*) AS Trips,
  AVG(DATEDIFF(MINUTE, Arrival_Time, Actual_Arrival_Time)) AS Avg_Delay_Minutes
FROM dbo.railway
WHERE Actual_Arrival_Time IS NOT NULL 
  AND Arrival_Time IS NOT NULL
  AND DATEDIFF(MINUTE, Arrival_Time, Actual_Arrival_Time) > 0
GROUP BY Departure_Station, Arrival_Destination
ORDER BY Avg_Delay_Minutes DESC;

--------------------------------------------------------------------------------------
--Payment & Refund Analysis--

-- 10- Payment Method Analysis
SELECT Payment_Method,
       COUNT(*) AS Transactions,
       AVG(CAST(Price AS DECIMAL(10,2))) AS Avg_Ticket_Price
FROM dbo.railway
GROUP BY Payment_Method
ORDER BY Transactions DESC;

-- 11- Refund Request Count
SELECT SUM(CASE WHEN Refund_Request = 1 THEN 1 ELSE 0 END) AS Refund_Requests
FROM dbo.railway;

-- 12- Refund Request Count
SELECT 
  CAST(SUM(CASE WHEN Refund_Request = 1 THEN 1 ELSE 0 END) AS FLOAT) / 
  NULLIF(COUNT(*), 0) * 100 AS Refund_Rate_Percent
FROM dbo.railway;

--------------------------------------------------------------------------------------
--Ticket & Railcard Analysis--
  
  -- 13- Railcard Usage
  SELECT Railcard,
       COUNT(*) AS Usage_Count
FROM dbo.railway
GROUP BY Railcard
ORDER BY Usage_Count DESC;

  -- 14- Railcard Delay Analysis
  SELECT Railcard,
       COUNT(*) AS Trips,
       AVG(DATEDIFF(MINUTE, Arrival_Time, Actual_Arrival_Time)) AS Avg_Delay_Minutes
FROM dbo.railway
WHERE Actual_Arrival_Time IS NOT NULL AND Arrival_Time IS NOT NULL
  AND DATEDIFF(MINUTE, Arrival_Time, Actual_Arrival_Time) > 0
GROUP BY Railcard
ORDER BY Avg_Delay_Minutes DESC;

  -- 15- Revenue by Ticket Class
  SELECT Ticket_Class,
       SUM(CAST(Price AS DECIMAL(10,2))) AS Revenue
FROM dbo.railway
GROUP BY Ticket_Class
ORDER BY Revenue DESC;

  -- 16- Trips by Ticket Type
  SELECT Ticket_Type,
       COUNT(*) AS Trip_Count
FROM dbo.railway
GROUP BY Ticket_Type
ORDER BY Trip_Count DESC;

  -- 17- Delay by Ticket Type
  SELECT Ticket_Type,
       COUNT(*) AS Delayed_Trips,
       AVG(DATEDIFF(MINUTE, Arrival_Time, Actual_Arrival_Time)) AS Avg_Delay_Minutes
FROM dbo.railway
WHERE Actual_Arrival_Time IS NOT NULL 
  AND Arrival_Time IS NOT NULL
  AND DATEDIFF(MINUTE, Arrival_Time, Actual_Arrival_Time) > 0
GROUP BY Ticket_Type
ORDER BY Avg_Delay_Minutes DESC;

--------------------------------------------------------------------------------------
--Advanced Date/Time Analysis--

  -- 18- Trips by Day of Week
  SELECT DATENAME(WEEKDAY, Date_of_Journey) AS Day_Of_Week,
       COUNT(*) AS Trips
FROM dbo.railway
GROUP BY DATENAME(WEEKDAY, Date_of_Journey)
ORDER BY Trips DESC;

  -- 19- Peak Purchase Hours
  SELECT DATEPART(HOUR, Time_of_Purchase) AS Hour_Of_Day,
       COUNT(*) AS Purchases
FROM dbo.railway
GROUP BY DATEPART(HOUR, Time_of_Purchase)
ORDER BY Purchases DESC;

  -- 20- Monthly Seasonality
  SELECT DATENAME(MONTH, Date_of_Journey) AS Month_Name,
       COUNT(*) AS Trips
FROM dbo.railway
GROUP BY DATENAME(MONTH, Date_of_Journey), MONTH(Date_of_Journey)
ORDER BY MONTH(Date_of_Journey);

  -- 21- Yearly Analysis
  SELECT YEAR(Date_of_Journey) AS Year,
       COUNT(*) AS Trips,
       SUM(CAST(Price AS DECIMAL(10,2))) AS Revenue
FROM dbo.railway
GROUP BY YEAR(Date_of_Journey)
ORDER BY Year;

  -- 22- Monthly Trip Trend
  SELECT FORMAT(Date_of_Journey, 'yyyy-MM') AS YearMonth,
       COUNT(*) AS Trips
FROM dbo.railway
GROUP BY FORMAT(Date_of_Journey, 'yyyy-MM')
ORDER BY YearMonth;

  -- 23- Busiest Travel Days (Top 5)
  SELECT TOP 5 Date_of_Journey,
       COUNT(*) AS Trips
FROM dbo.railway
GROUP BY Date_of_Journey
ORDER BY Trips DESC;

  -- 24- Revenue by Month & Class
SELECT 
  FORMAT(Date_of_Journey, 'yyyy-MM') AS YearMonth,
  Ticket_Class,
  SUM(CAST(Price AS DECIMAL(10,2))) AS Revenue
FROM dbo.railway
GROUP BY FORMAT(Date_of_Journey, 'yyyy-MM'), Ticket_Class
ORDER BY YearMonth, Ticket_Class;

  -- 25- Ticket Purchase Day Analysis
  SELECT DATENAME(WEEKDAY, Date_of_Purchase) AS Purchase_Day,
       COUNT(*) AS Purchases
FROM dbo.railway
GROUP BY DATENAME(WEEKDAY, Date_of_Purchase)
ORDER BY Purchases DESC;

--------------------------------------------------------------------------------------
--Booking Lead Time & Delay--

  -- 26- Booking Lead Time
SELECT 
  DATEDIFF(DAY, Date_of_Purchase, Date_of_Journey) AS Lead_Time_Days,
  COUNT(*) AS Trip_Count
FROM dbo.railway
WHERE 
  Date_of_Purchase IS NOT NULL 
  AND Date_of_Journey IS NOT NULL
  AND DATEDIFF(DAY, Date_of_Purchase, Date_of_Journey) >= 0
GROUP BY DATEDIFF(DAY, Date_of_Purchase, Date_of_Journey)
ORDER BY Lead_Time_Days;
  
  -- 27- Booking Time vs Delay
  SELECT 
  DATEDIFF(DAY, Date_of_Purchase, Date_of_Journey) AS Lead_Days,
  AVG(DATEDIFF(MINUTE, Arrival_Time, Actual_Arrival_Time)) AS Avg_Delay_Minutes
FROM dbo.railway
WHERE Actual_Arrival_Time IS NOT NULL AND Arrival_Time IS NOT NULL
  AND DATEDIFF(MINUTE, Arrival_Time, Actual_Arrival_Time) > 0
  AND Date_of_Purchase IS NOT NULL AND Date_of_Journey IS NOT NULL
GROUP BY DATEDIFF(DAY, Date_of_Purchase, Date_of_Journey)
ORDER BY Lead_Days;
 
--------------------------------------------------------------------------------------
--Extra Advanced Insights--

    -- 28- Delay by Departure Time
  SELECT 
  DATEPART(HOUR, Departure_Time) AS Hour_Of_Day,
  AVG(DATEDIFF(MINUTE, Arrival_Time, Actual_Arrival_Time)) AS Avg_Delay_Minutes
FROM dbo.railway
WHERE Actual_Arrival_Time IS NOT NULL AND Arrival_Time IS NOT NULL
  AND DATEDIFF(MINUTE, Arrival_Time, Actual_Arrival_Time) > 0
GROUP BY DATEPART(HOUR, Departure_Time)
ORDER BY Hour_Of_Day;
 
    -- 29- Morning vs Evening Trips
    SELECT 
  CASE 
    WHEN DATEPART(HOUR, Departure_Time) BETWEEN 5 AND 11 THEN 'Morning'
    ELSE 'Evening'
  END AS Time_Of_Day,
  COUNT(*) AS Trips,
  AVG(DATEDIFF(MINUTE, Arrival_Time, Actual_Arrival_Time)) AS Avg_Delay_Minutes
FROM dbo.railway
WHERE 
  Departure_Time IS NOT NULL AND Arrival_Time IS NOT NULL AND Actual_Arrival_Time IS NOT NULL
  AND DATEDIFF(MINUTE, Arrival_Time, Actual_Arrival_Time) > 0
GROUP BY 
  CASE 
    WHEN DATEPART(HOUR, Departure_Time) BETWEEN 5 AND 11 THEN 'Morning'
    ELSE 'Evening'
  END
ORDER BY Avg_Delay_Minutes DESC;

    -- 30- Payment Method Avg Price
    SELECT Payment_Method,
       AVG(CAST(Price AS DECIMAL(10,2))) AS Avg_Ticket_Price
FROM dbo.railway
GROUP BY Payment_Method
ORDER BY Avg_Ticket_Price DESC;

    -- 31- Avg Revenue Last 3 Months
    SELECT 
  AVG(Monthly_Revenue) AS Avg_Revenue_Last_3_Months
FROM (
    SELECT 
      FORMAT(Date_of_Journey, 'yyyy-MM') AS YearMonth,
      SUM(CAST(Price AS DECIMAL(10,2))) AS Monthly_Revenue
    FROM dbo.railway
    WHERE Date_of_Journey >= DATEADD(MONTH, -3, (SELECT MAX(Date_of_Journey) FROM dbo.railway))
    GROUP BY FORMAT(Date_of_Journey, 'yyyy-MM')
) AS MonthlyData;