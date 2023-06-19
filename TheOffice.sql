CREATE TABLE EmployeeDemographics
    (EmployeeID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Age INT,
    Gender VARCHAR(50)
    )

CREATE TABLE EmployeeSalary
    (EmployeeID INT,
    Jobtitle VARCHAR(50),
    Salary INT
    )

CREATE TABLE WareHouseEmployeeDemographics
    (EmployeeID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Age INT,
    Gender VARCHAR(50)
    )

INSERT INTO EmployeeDemographics(EmployeeID,FirstName, LastName, Age, Gender) VALUES 
    (1001, 'Jim', 'Halpert', 30, 'Male'),
    (1002, 'Pam', 'Beasley', 30, 'Female'),
    (1003, 'Dewight', 'Schrute', 29, 'Male'),
    (1004, 'Angela', 'Martin', 31, 'Female'),
    (1005, 'Toby', 'Flenderson', 32, 'Male'),
    (1006, 'Michael', 'Scott', 35, 'Male'),
    (1007, 'Meredith', 'Palmer', 32, 'Female'),
    (1008, 'Stanley', 'Hudson', 38, 'Male'),
    (1009, 'Kevin', 'Malone', 31, 'Male'),
    (1011, 'Ryan', 'Howard', 26, 'Male'),
    (1012, 'Holly', 'Flax', 31, 'Female'),
    (1013, 'Darryl', 'Philbin', NULL, 'Male'),
    (NULL, NULL, NULL, NULL, NUlL)

INSERT INTO EmployeeSalary(EmployeeID, Jobtitle, Salary) VALUES
    (1001, 'Salesman', 45000),
    (1002, 'Receptionist', 36000),
    (1003, 'Salesman', 63000),
    (1004, 'Accountant', 47000),
    (1005, 'Human Resource', 50000),
    (1006, 'Regional Manager', 65000),
    (1007, 'Supplier Relations', 41000),
    (1008, 'Salesman', 48000),
    (1009, 'Accountant', 42000),
    (1010, NULL, 47000),
    (NULL, 'Salesman', 43000),
    (NULL, NULL, NULL)

INSERT INTO WareHouseEmployeeDemographics(EmployeeID, FirstName, LastName, Age, Gender) VALUES
    (1013, 'Darryl', 'Philbin', NULL, 'Male'),
    (1050, 'Roy', 'Anderson', 31, 'Male'),
    (1051, 'Hidetoshi', 'Hasagawa', 40, 'Male'),
    (1052, 'Val', 'Johnson', 31, 'Female'),
    (NULL, NULL, NULL, NULL, NUll)

-- We hit our sales goals for the year, here is the end of year bonus for the department 
SELECT EmployeeDemographics.EmployeeID, LastName, JobTitle, Salary,
CASE
    WHEN JobTitle = 'Salesman' THEN (Salary * 0.10)
    WHEN JobTitle = 'Accountant' THEN (Salary * 0.05)
    WHEN JobTitle = 'Human Resource' THEN (Salary * 0.01)
    ELSE (Salary * 0.03)
END AS End_of_Year_Bonus
FROM EmployeeDemographics
JOIN EmployeeSalary
    ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

-- Our employer wants to figure out whos the highest paid employee at dunder mifflin, We have hit a slump in revenue and we have to cut back in salary
-- Michael Scott has advised us to exclude him from the salary cutback!
SELECT EmployeeDemographics.EmployeeID, FirstName, LastName, JobTitle, MAX(Salary) AS Max_Salary
FROM EmployeeDemographics
JOIN EmployeeSalary
    ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
WHERE JobTitle <> 'Regional Manager'
GROUP BY EmployeeDemographics.EmployeeID, FirstName, LastName, JobTitle
ORDER BY Max_Salary DESC

-- Creating a CTE for demonstration purposes
WITH CTE_Employee AS 
(SELECT FirstName, LastName, Gender, Salary, COUNT(Gender) OVER (partition by Gender) AS Total_Gender
FROM EmployeeDemographics AS EMPDEMO
JOIN EmployeeSalary AS EMPSAL
    ON EMPDEMO.EmployeeID = EMPSAL.EmployeeID
WHERE Salary > 45000
)
SELECT *
FROM CTE_Employee