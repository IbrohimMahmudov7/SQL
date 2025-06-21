create database homework17
go
use homework17

--TASK 1 

DROP TABLE IF EXISTS #RegionSales;
GO
CREATE TABLE #RegionSales (
  Region      VARCHAR(100),
  Distributor VARCHAR(100),
  Sales       INTEGER NOT NULL,
  PRIMARY KEY (Region, Distributor)
);
GO
INSERT INTO #RegionSales (Region, Distributor, Sales) VALUES
('North','ACE',10), ('South','ACE',67), ('East','ACE',54),
('North','ACME',65), ('South','ACME',9), ('East','ACME',1), ('West','ACME',7),
('North','Direct Parts',8), ('South','Direct Parts',7), ('West','Direct Parts',12);

select * from #RegionSales

-- Step 1: Get the full grid of all distributor-region combinations
WITH AllCombos AS (
    SELECT 
        r.Region,
        d.Distributor
    FROM (SELECT DISTINCT Region FROM #RegionSales) r
    CROSS JOIN (SELECT DISTINCT Distributor FROM #RegionSales) d
)

-- Step 2: Join and handle missing sales
SELECT 
    a.Region,
    a.Distributor,
    ISNULL(rs.Sales, 0) AS Sales
FROM AllCombos a
LEFT JOIN #RegionSales rs
    ON a.Region = rs.Region AND a.Distributor = rs.Distributor
ORDER BY a.Distributor, a.Region;



--TASK 2 

Find managers with at least five direct reports
SQL Setup:

CREATE TABLE Employee (id INT, name VARCHAR(255), department VARCHAR(255), managerId INT);
TRUNCATE TABLE Employee;
INSERT INTO Employee VALUES
(101, 'John', 'A', NULL), (102, 'Dan', 'A', 101), (103, 'James', 'A', 101),
(104, 'Amy', 'A', 101), (105, 'Anne', 'A', 101), (106, 'Ron', 'B', 101);

SELECT 
    m.id AS ManagerID,
    m.name AS ManagerName,
    COUNT(e.id) AS DirectReports
FROM Employee e
JOIN Employee m
    ON e.managerId = m.id
GROUP BY m.id, m.name
HAVING COUNT(e.id) >= 5;

--task 3

Write a solution to get the names of products that have at least 100 units ordered in February 2020 and their amount.
SQL Setup:

CREATE TABLE Products (product_id INT, product_name VARCHAR(40), product_category VARCHAR(40));
CREATE TABLE Orders (product_id INT, order_date DATE, unit INT);
TRUNCATE TABLE Products;
INSERT INTO Products VALUES
(1, 'Leetcode Solutions', 'Book'),
(2, 'Jewels of Stringology', 'Book'),
(3, 'HP', 'Laptop'), (4, 'Lenovo', 'Laptop'), (5, 'Leetcode Kit', 'T-shirt');
TRUNCATE TABLE Orders;
INSERT INTO Orders VALUES
(1,'2020-02-05',60),(1,'2020-02-10',70),
(2,'2020-01-18',30),(2,'2020-02-11',80),
(3,'2020-02-17',2),(3,'2020-02-24',3),
(4,'2020-03-01',20),(4,'2020-03-04',30),(4,'2020-03-04',60),
(5,'2020-02-25',50),(5,'2020-02-27',50),(5,'2020-03-01',50);


SELECT 
    p.product_name,
    SUM(o.unit) AS total_units
FROM Products p
JOIN Orders o
    ON p.product_id = o.product_id
WHERE 
    o.order_date >= '2020-02-01' AND o.order_date < '2020-03-01'
GROUP BY p.product_name
HAVING SUM(o.unit) >= 100;



--task 6

 Write an SQL query to return the number of locations,in which location most signals sent, and total number of signal for each device from the given table.
SQL Setup:

CREATE TABLE Device(
  Device_id INT,
  Locations VARCHAR(25)
);
INSERT INTO Device VALUES
(12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'),
(12,'Hosur'), (12,'Hosur'),
(13,'Hyderabad'), (13,'Hyderabad'), (13,'Secunderabad'),
(13,'Secunderabad'), (13,'Secunderabad');

SELECT 
    Device_id as d
    COUNT(DISTINCT d.Locations) AS NumberOfLocations,
    SUM(1) AS TotalSignals,
    MAX_BY(d.Locations, cnt) AS MostSignalsLocation  -- SQL Server doesn't support MAX_BY, see below
FROM (
    SELECT 
        Device_id,
        Locations,
        COUNT(*) AS cnt
    FROM Device
    GROUP BY Device_id, Locations
) d
GROUP BY d.Device_id;


--task 7

Write a SQL to find all Employees who earn more than the average salary in their corresponding department. Return EmpID, EmpName,Salary in your output
SQL Setup:

CREATE TABLE Employee1 (
  EmpID INT,
  EmpName VARCHAR(30),
  Salary FLOAT,
  DeptID INT
);
INSERT INTO Employee1 VALUES
(1001,'Mark',60000,2), (1002,'Antony',40000,2), (1003,'Andrew',15000,1),
(1004,'Peter',35000,1), (1005,'John',55000,1), (1006,'Albert',25000,3), (1007,'Donald',35000,3);

WITH DeptAvgSalary AS (
  SELECT DeptID, AVG(Salary) AS AvgSalary
  FROM Employee1
  GROUP BY DeptID
)
SELECT e.EmpID, e.EmpName, e.Salary
FROM Employee1 e
JOIN DeptAvgSalary d
  ON e.DeptID = d.DeptID
WHERE e.Salary > d.AvgSalary;


--task 8







WITH MatchCounts AS (
  SELECT 
    TicketID,
    COUNT(*) AS MatchCount
  FROM Tickets
  WHERE Number IN (25, 45, 78)
  GROUP BY TicketID
)

SELECT 
  SUM(
    CASE 
      WHEN MatchCount = 3 THEN 100
      WHEN MatchCount >= 1 THEN 10
      ELSE 0
    END
  ) AS TotalWinnings
FROM (
  SELECT DISTINCT TicketID FROM Tickets
) t
LEFT JOIN MatchCounts mc ON t.TicketID = mc.TicketID;


--task 9


CREATE TABLE Spending (
  User_id INT,
  Spend_date DATE,
  Platform VARCHAR(10),
  Amount INT
);
INSERT INTO Spending VALUES
(1,'2019-07-01','Mobile',100),
(1,'2019-07-01','Desktop',100),
(2,'2019-07-01','Mobile',100),
(2,'2019-07-02','Mobile',100),
(3,'2019-07-01','Desktop',100),
(3,'2019-07-02','Desktop',100);

WITH UserPlatform AS (
  SELECT 
    User_id,
    Spend_date,
    MAX(CASE WHEN Platform = 'Mobile' THEN 1 ELSE 0 END) AS used_mobile,
    MAX(CASE WHEN Platform = 'Desktop' THEN 1 ELSE 0 END) AS used_desktop,
    SUM(Amount) AS total_amount
  FROM Spending
  GROUP BY User_id, Spend_date
),
UserCategory AS (
  SELECT 
    Spend_date,
    CASE 
      WHEN used_mobile = 1 AND used_desktop = 1 THEN 'Both'
      WHEN used_mobile = 1 THEN 'Mobile_Only'
      WHEN used_desktop = 1 THEN 'Desktop_Only'
    END AS user_type,
    total_amount
  FROM UserPlatform
)
SELECT 
  Spend_date,
  user_type,
  COUNT(*) AS total_users,
  SUM(total_amount) AS total_amount_spent
FROM UserCategory
GROUP BY Spend_date, user_type
ORDER BY Spend_date, user_type;


--task 10

WITH RECURSIVE Numbers AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1 FROM Numbers WHERE n < 100  -- adjust limit as needed
)
SELECT g.Product
FROM Grouped g
JOIN Numbers n ON n.n <= g.Quantity
ORDER BY g.Product;
