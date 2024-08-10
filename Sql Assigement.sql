use BikeStores;

-- Question 01

CREATE TABLE Employee (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    salary INT,
    managerId INT
);

INSERT INTO Employee (id, name, salary, managerId) VALUES
(1, 'John', 100000, NULL),  -- John is the CEO with no manager
(2, 'Alice', 90000, 1),    -- Alice is managed by John
(3, 'Bob', 85000, 1),      -- Bob is managed by John
(4, 'Charlie', 95000, 2),  -- Charlie is managed by Alice
(5, 'David', 80000, 2);    -- David is managed by Alice

SELECT e1.name AS Employee
FROM Employee e1
JOIN Employee e2 ON e1.managerId = e2.id
WHERE e1.salary > e2.salary;

--Question no 02

CREATE TABLE Person (
    id INT PRIMARY KEY,
    email VARCHAR(255) NOT NULL
);

INSERT INTO Person (id, email) VALUES
(1, 'a@example.com'),
(2, 'b@example.com'),
(3, 'a@example.com'),  -- Duplicate email
(4, 'c@example.com'),
(5, 'b@example.com');  -- Duplicate email

SELECT email
FROM Person
GROUP BY email
HAVING COUNT(email) > 1;

--Question No 03

DELETE FROM Person
WHERE id NOT IN (
    SELECT MIN(id)
    FROM Person
    GROUP BY email
);

select * from Person;

--Question 04

CREATE TABLE EmployeeUNI (
    id INT,
    uniqueid INT,
    PRIMARY KEY (id, uniqueid)
);


-- Insert values into EmployeeUNI
INSERT INTO EmployeeUNI (id, uniqueid) VALUES
(1, 1001),
(3, 1003);

SELECT e.id, e.name, eu.uniqueid
FROM Employee e
LEFT JOIN EmployeeUNI eu
ON e.id = eu.id;

--Question no 05

SELECT e.EmployeeID, e.Name, e.DepartmentID, e.Salary
FROM Employees e
WHERE e.Salary = (
    SELECT MIN(Salary)
    FROM Employees
    WHERE DepartmentID = e.DepartmentID
);

WITH MinSalaries AS (
    SELECT DepartmentID, MIN(Salary) AS MinSalary
    FROM Employees
    GROUP BY DepartmentID
)
SELECT e.EmployeeID, e.Name, e.DepartmentID, e.Salary
FROM Employees e
JOIN MinSalaries ms
ON e.DepartmentID = ms.DepartmentID AND e.Salary = ms.MinSalary;

--Question no 06

SELECT TOP 1
    o.CustomerID,
    SUM(oi.Quantity) AS TotalQuantity
FROM
    Orders o
JOIN
    OrderItems oi ON o.OrderID = oi.OrderID
GROUP BY
    o.CustomerID
ORDER BY
    TotalQuantity DESC;


--Question no 07

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(255),
    JoinDate DATE
);

CREATE TABLE Ordeers (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Insert sample data into Customers table
INSERT INTO Customers (CustomerID, Name, JoinDate)
VALUES
(1, 'John Doe', '2024-07-15'),
(2, 'Jane Smith', '2024-07-20'),
(3, 'Emily Johnson', '2024-06-25');

-- Insert sample data into Orders table
INSERT INTO Ordeers (OrderID, CustomerID, OrderDate)
VALUES
(1, 1, '2024-08-01'),
(2, 2, '2024-08-05'),
(3, 3, '2024-07-15'),
(4, 1, '2024-08-06');

SELECT C.CustomerID, C.Name, O.FirstOrderDate
FROM Customers C
JOIN (
    SELECT CustomerID, MIN(OrderDate) AS FirstOrderDate
    FROM Ordeers
    GROUP BY CustomerID
) O ON C.CustomerID = O.CustomerID
WHERE O.FirstOrderDate >= DATEADD(DAY, -30, GETDATE());

-- Question no 08

CREATE TABLE Employyee (
    id INT PRIMARY KEY,
    salary INT
);

INSERT INTO Employyee (id, salary)
VALUES
(1, 10000),
(2, 15000),
(3, 20000),
(4, 20000),
(5, 25000);

SELECT MAX(salary) AS SecondHighestSalary
FROM Employyee
WHERE salary < (
    SELECT MAX(salary)
    FROM Employyee
);

WITH RankedSalaries AS (
    SELECT salary,
           ROW_NUMBER() OVER (ORDER BY salary DESC) AS Rank
    FROM Employyee
)
SELECT salary AS SecondHighestSalary
FROM RankedSalaries
WHERE Rank = 2;

--Question no 09

CREATE TABLE Department (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE Emplloyee (
    id INT PRIMARY KEY,
    salary INT,
    name VARCHAR(255),
    departmentId INT,
    FOREIGN KEY (departmentId) REFERENCES Department(id)
);

-- Insert sample data into Department
INSERT INTO Department (id, name)
VALUES
(1, 'HR'),
(2, 'Engineering'),
(3, 'Sales');

-- Insert sample data into Employee
INSERT INTO Emplloyee (id, salary, name, departmentId)
VALUES
(1, 50000, 'Alice', 1),
(2, 60000, 'Bob', 1),
(3, 70000, 'Charlie', 2),
(4, 70000, 'David', 2),
(5, 45000, 'Eve', 3),
(6, 50000, 'Frank', 3);

SELECT E.id, E.salary, E.name, E.departmentId
FROM Emplloyee E
JOIN (
    SELECT departmentId, MAX(salary) AS MaxSalary
    FROM Emplloyee
    GROUP BY departmentId
) MaxSalaries ON E.departmentId = MaxSalaries.departmentId AND E.salary = MaxSalaries.MaxSalary;

WITH RankedEmployees AS (
    SELECT id, salary, name, departmentId,
           ROW_NUMBER() OVER (PARTITION BY departmentId ORDER BY salary DESC) AS rank
    FROM Emplloyee
)
SELECT id, salary, name, departmentId
FROM RankedEmployees
WHERE rank = 1;

--Question no 10

CREATE TABLE Product (
    Product_key INT PRIMARY KEY
);

CREATE TABLE Customer (
    Customer_id INT,
    Product_key INT,
    FOREIGN KEY (Product_key) REFERENCES Product(Product_key)
);

-- Insert sample data into Product
INSERT INTO Product (Product_key)
VALUES
(1),
(2),
(3);

-- Insert sample data into Customer
INSERT INTO Customer (Customer_id, Product_key)
VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 1),
(2, 2),
(3, 1),
(3, 2),
(3, 3),
(4, 1),
(4, 2);

SELECT c.Customer_id
FROM Customer c
GROUP BY c.Customer_id
HAVING COUNT(DISTINCT c.Product_key) = (SELECT COUNT(*) FROM Product);

