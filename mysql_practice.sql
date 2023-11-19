-- CREATE TABLE employeedemographics
( EmployeeID int,
firstname varchar(50),
lastname varchar(50),
Age int,
gender varchar(50)
);

 -- CREATE TABLE employeesalary (
EmployeeID int,
jobtitle varchar(50),
salary int
);

-- we do some inserting into the tables created

-- INSERT INTO employeedemographics VALUES ( 1001, 'Jim', 'Halpert', 30, 'Male' );

Insert into EmployeeDemographics VALUES
(1001, 'Jim', 'Halpert', 30, 'Male'),
(1002, 'Pam', 'Beasley', 30, 'Female'),
(1003, 'Dwight', 'Schrute', 29, 'Male'),
(1004, 'Angela', 'Martin', 31, 'Female'),
(1005, 'Toby', 'Flenderson', 32, 'Male'),
(1006, 'Michael', 'Scott', 35, 'Male'),
(1007, 'Meredith', 'Palmer', 32, 'Female'),
(1008, 'Stanley', 'Hudson', 38, 'Male'),
(1009, 'Kevin', 'Malone', 31, 'Male');

Insert Into employeesalary VALUES
(1001, 'Salesman', 45000),
(1002, 'Receptionist', 36000),
(1003, 'Salesman', 63000),
(1004, 'Accountant', 47000),
(1005, 'HR', 50000),
(1006, 'Regional Manager', 65000),
(1007, 'Supplier Relations', 41000),
(1008, 'Salesman', 48000),
(1009, 'Accountant', 42000);




-- -- SELECT firstname, lastname
-- -- FROM employeedemographics;

-- -- TOP statement only works on sql microsoft server 
SELECT TOP 2 *
FROM employeedemographics;

-- -- so in mysql we use LIMIT instead of TOP
SELECT *
FROM employeedemographics
LIMIT 2;

SELECT DISTINCT(gender)
FROM employeedemographics;

-- DROP TABLE employeedemographics;
-- DROP TABLE employeesalary;

    -- here we select count of all lastname  
    
SELECT COUNT(lastname)
FROM employeedemographics;

-- here we select all data where first name is not equal to jim
SELECT *
FROM employeedemographics
WHERE firstname <> 'Jim';

-- here also trying another symbol that can represent not equal to '!='
SELECT *
FROM employeedemographics
WHERE firstname != 'Jim';

SELECT EmployeeID, firstname, Age
FROM employeedemographics
UNION ALL
SELECT EmployeeID, jobtitle, salary
FROM employeesalary;


-- LEARNING HOW TO USE CASE STATEMENT IN SQL 
-- this case statement is a statement that returns a function with also query results when our queries are executed

SELECT firstname, lastname, age,
CASE
    WHEN age > 30 THEN 'OLD'
    WHEN age BETWEEN 27 AND 30 THEN 'Young'
    ELSE 'Baby'
END as Age_group
FROM employeedemographics
WHERE age is not null
ORDER BY age;
-- to me i think case statement in sql is similar to if else statement wrapped in a function in python

-- this below example is to show that the case statement takes account of supriority to the first  when statement always
SELECT firstname, lastname, age,
CASE
    WHEN age > 30 THEN 'OLD'
    WHEN age = 38 THEN "it's Stanley"
    ELSE 'Baby'
END as Age_group
FROM employeedemographics
WHERE age is not null
ORDER BY age;

-- now we place condition for its stanley first and see the result 
SELECT firstname, lastname, age,
CASE
	WHEN age = 38 THEN "it's Stanley"
    WHEN age > 30 THEN 'OLD'
    ELSE 'Baby'
END as Age_group
FROM employeedemographics
WHERE age is not null
ORDER BY age;
-- here it gives priority to the stanley hence changing the age = 38 from old  to its stanley

-- now lets use case statement to do actual advance stuff in our database 
-- here we are going to give a 10% raise to salesman and 5% raise to accountant, also a non tangible raise to hr and others a 3% raise
-- we will use a case statement to achieve this 
SELECT firstname, lastname, jobtitle, salary,
CASE
   WHEN jobtitle = 'salesman' THEN salary + (salary * 0.1)
   WHEN jobtitle = 'accountant' THEN salary + (salary * 0.05)
   WHEN jobtitle = 'hr' THEN salary + (salary * 0.00001)
   ELSE salary + (salary * 0.03)
END  AS New_Salary_Raise
FROM employeedemographics AS ed
JOIN employeesalary AS es
ON ed.EmployeeID = es.EmployeeID;

-- HAVING CLAUSE
-- learning how to use having clause effectively
-- having clause allows us to use agregate statement in our query, this agregegate statements are not allowed in a where clause

SELECT jobtitle, COUNT(jobtitle)
FROM employeedemographics AS ed
JOIN employeesalary AS es
ON ed.EmployeeID = es.EmployeeID
GROUP BY jobtitle
HAVING COUNT(jobtitle) > 1 ;

-- note that having clause comes after groupby statement because also we cant agregate without a groupby statement or clause.

-- another example 
SELECT jobtitle, AVG(salary)
FROM employeedemographics AS ed
JOIN employeesalary AS es
ON ed.EmployeeID = es.EmployeeID
GROUP BY jobtitle
HAVING AVG(salary) > 45000 
ORDER BY AVG(salary);


-- how to do an update in sql
-- here we will focus on updating a specific data 

UPDATE employeedemographics
SET Age = 31, gender = 'Female' 
WHERE EmployeeID = 1012;
-- we are not getting answer because there is no place in our table where there is employee with 1012 id unlike 
-- the tutorial video of alex 

SELECT *
FROM employeesalary;
  
  
-- DELETE a specific data in SQl 
DELETE 
FROM employeedemographics 
WHERE  EmployeeID = 1012;

-- PARTITION BY used -- it also relates to groupby in a way that it gives the result of groupby in a more detailed way

SELECT  firstname, lastname, gender, salary, COUNT(gender) OVER (PARTITION BY gender) AS Totalgender
FROM employeedemographics AS demo
JOIN employeesalary AS esal
ON demo.EmployeeID = esal.EmployeeID;

SELECT gender, COUNT(gender)
FROM employeedemographics AS demo
JOIN employeesalary AS esal
ON demo.EmployeeID = esal.EmployeeID
GROUP BY gender;

-- PARTITION BY STATEMENT QUERY 
SELECT *
FROM employeedemographics emp
JOIN employeesalary esal
ON emp.EmployeeID = esal.EmployeeID
WHERE salary > '45000'

-- now we do partitioning on the previous created query

SELECT firstname, lastname, gender, salary,
COUNT(gender) OVER (PARTITION BY gender) AS TotalGender,
AVG(salary) OVER (PARTITION BY gender)  AS Avgsalary
FROM employeedemographics emp
JOIN employeesalary esal
ON emp.EmployeeID = esal.EmployeeID
WHERE salary > '45000';

-- CTE QUERIES ALSO CALLED 'WITH' QUERIES
--   cte is not stored anywhere unlike temp tables 
--  it puts our querie in a temporary place, 

WITH CTE_Employee as (
SELECT firstname, lastname, gender, salary,
COUNT(gender) OVER (PARTITION BY gender) AS TotalGender,
AVG(salary) OVER (PARTITION BY gender)  AS Avgsalary
FROM employeedemographics emp
JOIN employeesalary esal
ON emp.EmployeeID = esal.EmployeeID
WHERE salary > '45000'
)
SELECT *
FROM CTE_Employee;

-- note: the final querie of cte comes after the 'with' statement/query

-- TEMP TABLES
-- in temp tables we can hit off it multiple times , this we cant do with a cte or sub-queries

-- first we create our temp table which takes the '#' for ms server and 'TEMPORARY' for mysql as the only diff between temp and normal table 

DROP TABLE IF EXISTS temp_Employee1;
CREATE TEMPORARY TABLE temp_Employee1 (
firstname VARCHAR(50),
Lastname VARCHAR(50),
Gender VARCHAR(50),
Salary INT,
Total_Gender INT,
Avg_Salary INT);

INSERT INTO temp_Employee1
SELECT firstname, lastname, gender, salary,
COUNT(gender) OVER (PARTITION BY gender) AS TotalGender,
AVG(salary) OVER (PARTITION BY gender)  AS Avgsalary
FROM employeedemographics emp
JOIN employeesalary esal
ON emp.EmployeeID = esal.EmployeeID
WHERE salary > '45000';

SELECT *
FROM temp_Employee1;


-- Today's Topic: String Functions - TRIM, LTRIM, RTRIM, Replace, Substring, Upper, Lower

-- Drop Table EmployeeErrors;


CREATE TABLE EmployeeErrors (
EmployeeID varchar(50),
FirstName varchar(50),
LastName varchar(50)
);

Insert into EmployeeErrors Values 
('1001  ', 'Jimbo', 'Halbert')
,('  1002', 'Pamela', 'Beasely')
,('1005', 'TOby', 'Flenderson - Fired');

Select *
From EmployeeErrors;

-- Using Trim, LTRIM, RTRIM

Select EmployeeID, TRIM(employeeID) AS IDTRIM
FROM EmployeeErrors;

Select EmployeeID, RTRIM(employeeID) as IDRTRIM
FROM EmployeeErrors;

Select EmployeeID, LTRIM(employeeID) as IDLTRIM
FROM EmployeeErrors; 

-- Using Replace

Select LastName, REPLACE(LastName, '- Fired', '') as LastNameFixed
FROM EmployeeErrors;

SELECT *,
REPLACE(LastName, '- Fired', '-f') as LastNameFixed1
FROM EmployeeErrors;

-- Using Substring

Select Substring(err.FirstName,1,3), Substring(dem.FirstName,1,3), Substring(err.LastName,1,3), Substring(dem.LastName,1,3)
FROM EmployeeErrors err
JOIN EmployeeDemographics dem
	on Substring(err.FirstName,1,3) = Substring(dem.FirstName,1,3)
	and Substring(err.LastName,1,3) = Substring(dem.LastName,1,3);


-- Using UPPER and lower 

Select firstname, LOWER(firstname)
from EmployeeErrors;

Select Firstname, UPPER(FirstName)
from EmployeeErrors;


-- Today's Topic: Stored Procedures

-- this is the way its created for ms server

-- CREATE PROCEDURE TEST 
-- AS 
-- SELECT *
-- FROM Employeedemograhics;

-- This is for MYSQL
DELIMITER //

CREATE PROCEDURE TEST()
BEGIN
    SELECT *
    FROM Employeedemographics;
END //

DELIMITER ;

-- this is how to run the created stored procedure in ms server
EXECUTE TEST;

-- this is how to run the stored procedure in mysql
CALL TEST;  

-- complex example for stored procedures
DROP PROCEDURE IF EXISTS TEMP;
DROP TABLE IF EXISTS temp_employee3;
DELIMITER //
CREATE PROCEDURE TEMP()
BEGIN 
   CREATE TABLE temp_employee3(
   JobTitle VARCHAR(50),
   EmployeesPerJob int,
   AvgAge int,
   Avgsalary int
   );
   INSERT INTO temp_employee3 
   SELECT JobTitle, COUNT(JobTitle), AVG(age), AVG(salary)
   FROM Employeedemographics emp
   JOIN Employeesalary sal
   ON emp.EmployeeID = sal.EmployeeID
   GROUP BY JobTitle;
   
   SELECT *
   FROM temp_employee3;
END //
DELIMITER ;

CALL TEMP;


-- SUBQUERIES 

-- subqueries in select statement 

SELECT EmployeeID, salary,(SELECT AVG(salary) FROM Employeesalary) AS AllAVgsalary
 FROM employeesalary;
-- the above query gives same result with the query below 
SELECT EmployeeID, salary, AVG(salary) OVER ( ) AS AllAVgsalary
 FROM employeesalary;
 
 -- Subqueries in  FROM statement 
SELECT f.EmployeeID, f.AllAVgsalary
 FROM(SELECT EmployeeID, salary,(SELECT AVG(salary) FROM Employeesalary) AS AllAVgsalary
	  FROM employeesalary) f;
       
-- Subqueries in WHERE statement
SELECT * 
FROM employeedemographics;
WHERE EmployeeID IN (
       SELECT EmployeeID
       FROM Employeedemographics
       WHERE age > 30);
             
SELECT *
 FROM employeesalary;



( SELECT * 
        FROM employeesalary es
        JOIN employeedemographics ed
        ON es.EmployeeID = ed.EmployeeID
        WHERE ed.Age > 30
        );