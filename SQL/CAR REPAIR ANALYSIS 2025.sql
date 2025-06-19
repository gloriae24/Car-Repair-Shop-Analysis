
-- CHECK FOR NULL VALUES
SELECT 
  COUNT(*) AS TotalRows,
  SUM(CASE WHEN VehicleID IS NULL THEN 1 ELSE 0 END) AS Nulls_VehicleID,
  SUM(CASE WHEN Make IS NULL THEN 1 ELSE 0 END) AS Nulls_Make,
  SUM(CASE WHEN Model IS NULL THEN 1 ELSE 0 END) AS Nulls_Model,
  SUM(CASE WHEN Year IS NULL THEN 1 ELSE 0 END) AS Nulls_Year,
  SUM(CASE WHEN Color IS NULL THEN 1 ELSE 0 END) AS Nulls_Color,
  SUM(CASE WHEN VIN IS NULL THEN 1 ELSE 0 END) AS Nulls_VIN,
  SUM(CASE WHEN RegNumber IS NULL THEN 1 ELSE 0 END) AS Nulls_RegNumber,
  SUM(CASE WHEN Mileage IS NULL THEN 1 ELSE 0 END) AS Nulls_Mileage,
  SUM(CASE WHEN Name IS NULL THEN 1 ELSE 0 END) AS Nulls_Name
FROM dim_vehicle;--    REPEAT SAME FOR ALL THE TABLES


-- ANALYSIS--
--  Top 5 customers by total spending
SELECT c.Name, SUM(i.Total) AS TotalSpent
FROM Fact_Invoice i
JOIN dim_Customer c ON i.CustomerID = c.CustomerID
GROUP BY c.CustomerID
ORDER BY TotalSpent DESC
LIMIT 5;

-- OR

SELECT dim_customer.Name, SUM(fact_invoice.Total) AS TotalSpent
FROM Fact_Invoice 
JOIN dim_Customer  ON fact_invoice.CustomerID = dim_Customer.CustomerID
GROUP BY dim_Customer.CustomerID
ORDER BY TotalSpent DESC
LIMIT 5;

-- Average customer spending
SELECT AVG(Total) AS AvgCustomerSpend
FROM Fact_Invoice;

--  Frequency of visits (number of invoices per customer
SELECT c.Name, COUNT(i.InvoiceID) AS VisitCount
FROM Fact_Invoice i
JOIN dim_Customer c ON i.CustomerID = c.CustomerID
GROUP BY c.CustomerID
ORDER BY VisitCount DESC;

-- b. Vehicle Analysis
-- 1. Average mileage of serviced vehicles
SELECT AVG(Mileage) AS AvgMileage FROM dim_Vehicle;

-- 2. Most common vehicle makes and models
SELECT Make, Model, COUNT(*) AS Count
FROM dim_Vehicle
GROUP BY Make, Model
ORDER BY Count DESC
LIMIT 5;

-- 3. Distribution of vehicle ages
 SELECT Year, COUNT(*) AS VehicleCount
FROM dim_Vehicle
GROUP BY Year
ORDER BY Year DESC;

-- c. Job Performance Analysis
-- 1. Most common types of jobs performed
SELECT Description, COUNT(*) AS JobCount
FROM dim_Job
GROUP BY Description
ORDER BY JobCount DESC
LIMIT 5;

-- 2. Total revenue by job type
SELECT Description, SUM(Amount) AS Revenue
FROM dim_Job
GROUP BY Description
ORDER BY Revenue DESC;

-- Jobs with highest and lowest average cost
SELECT Description, AVG(Amount) AS AvgCost
FROM dim_Job
GROUP BY Description
ORDER BY AvgCost DESC
LIMIT 1; -- Highest

-- For lowest
SELECT Description, AVG(Amount) AS AvgCost
FROM dim_Job
GROUP BY Description
ORDER BY AvgCost ASC
LIMIT 1;


-- d. Parts Usage Analysis
-- 1. Top 5 most used parts
SELECT PartName, SUM(Quantity) AS TotalUsed
FROM dim_Parts
GROUP BY PartName
ORDER BY TotalUsed DESC
LIMIT 5;

-- 2. Average cost of parts
-- SELECT AVG(UnitPrice) AS AvgPartCost FROM dim_Parts;
SELECT AVG(UnitPrice) AS AvgPartCost FROM dim_Parts;

-- 3. Total revenue from parts
SELECT SUM(Amount) AS TotalPartsRevenue FROM dim_Parts;

-- e. Financial Analysis
-- 1. Monthly revenue from labor and parts
SELECT 
  DATE_FORMAT(InvoiceDate, '%Y-%m') AS Month,
  SUM(TotalLabour) AS LabourRevenue,
  SUM(TotalParts) AS PartsRevenue,
  SUM(Total) AS TotalRevenue
FROM Fact_Invoice
GROUP BY Month
ORDER BY Month;

-- 2. Overall profitability (Total Revenue - Total Cost of Parts and Labour)
-- If cost data isn’t given, assume profit = total revenue.
SELECT 
  SUM(Total) AS TotalRevenue,
  SUM(TotalLabour + TotalParts) AS TotalCost,
  SUM(Total - (TotalLabour + TotalParts)) AS EstimatedProfit
FROM Fact_Invoice;

-- 3. Impact of sales tax on total revenue
SELECT 
  SUM(SalesTax) AS TotalSalesTax,
  SUM(Total) AS TotalRevenue,
  (SUM(SalesTax) / SUM(Total)) * 100 AS TaxImpactPercent
FROM Fact_Invoice;








