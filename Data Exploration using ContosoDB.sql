/*Here I will explore the Contoso database to genrate insights about the business*/

/*Total sales by continent*/
SELECT 
SUM([FactSales].[SalesAmount]) AS SalesAmount,
[DimGeography].[ContinentName]
FROM [ContosoRetailDW].[dbo].[FactSales]
JOIN [ContosoRetailDW].[dbo].[DimStore]
    ON [FactSales].[StoreKey] = [DimStore].[StoreKey]
JOIN [ContosoRetailDW].[dbo].[DimGeography]
    ON [DimStore].[GeographyKey] = [DimGeography].[GeographyKey]
GROUP BY [ContinentName]
ORDER BY SalesAmount DESC;

/*Find the number of sales by product*/
SELECT 
COUNT([SalesKey]) AS TotalSales,
[DimProduct].[ProductName]
FROM [ContosoRetailDW].[dbo].[FactSales]
JOIN [ContosoRetailDW].[dbo].[DimProduct]
    ON [FactSales].[ProductKey] = [DimProduct].[ProductKey]
GROUP BY [DimProduct].[ProductName]
ORDER BY TotalSales DESC;

/*Here I will generate insights about Contoso employees*/
/*All job titles and the number of employees with that title*/
SELECT
[Title],
COUNT([Title]) AS Total
FROM [ContosoRetailDW].[dbo].[DimEmployee]
GROUP BY [Title];
/*Number of employees by department*/
SELECT
[DepartmentName],
COUNT([DepartmentName]) AS Total
FROM [ContosoRetailDW].[dbo].[DimEmployee]
GROUP BY [DepartmentName]
ORDER BY [Total] DESC;
/*Number of employees with a middle name*/
SELECT
COUNT([EmployeeKey]) AS Employees_with_Middlename
FROM [ContosoRetailDW].[dbo].[DimEmployee]
WHERE [MiddleName] IS NOT NULL;
/*Number of salaried employees*/
SELECT
COUNT([SalariedFlag]) AS Salaried_Employees
FROM [ContosoRetailDW].[dbo].[DimEmployee]
WHERE [SalariedFlag] = '1';
/*Check if any employee has another employee as their emergency contact*/
SELECT 
[Employee],
EmployeeTable.[EmergencyContactName] AS Emergency_Contact
FROM
(
SELECT
CONCAT([FirstName], ' ' ,[LastName]) AS Employee,
[DimEmployee].[EmergencyContactName]
FROM [DimEmployee]
) AS EmployeeTable
JOIN [DimEmployee]
    ON [EmployeeTable].[Employee] = [DimEmployee].[EmergencyContactName]
/*Find employee gender ratio*/
SELECT
[Gender],
Count([Gender]) AS Total
FROM [DimEmployee]
GROUP BY Gender

/*Here I will generate insights about Contoso customers*/
/*I will assume there are no married customers where both spouses have bought from Contoso as it would be impossible to verify. I could try to find duplicate addresses, but that does not guarentee that the two customers are a couple they may have
 devorced or a customer may have moved into another customers home*/
/*Average number of children for our customers*/
SELECT AVG(TotalChildren) AS AverageChildren
FROM [ContosoRetailDW].[dbo].[DimCustomer]
/*Number of Male VS. Female Customers*/
SELECT 
Gender,
Count(Gender) AS Total
FROM [ContosoRetailDW].[dbo].[DimCustomer]
GROUP BY Gender
HAVING Gender IS NOT NULL;
/*The Educational makeup of customers*/
SELECT
Education,
COUNT(Education) AS Total
FROM [ContosoRetailDW].[dbo].[DimCustomer]
GROUP BY Education
HAVING Education IS NOT NULL
ORDER BY Total;
/*The occupational makeup of customers*/
SELECT
Occupation,
COUNT(Occupation) AS Total
FROM [ContosoRetailDW].[dbo].[DimCustomer]
GROUP BY Occupation
HAVING Occupation IS NOT NULL
ORDER BY Total;
/*Number of Customers that are home owners and those who are not*/
SELECT
CASE 
    WHEN HouseOwnerFlag = 0 
    THEN 'Not A Homeowner'
    WHEN HouseOwnerFlag = 1 
    THEN 'Homeowner'
END AS [Homeowner],
COUNT(HouseOwnerFlag) AS Total
FROM [ContosoRetailDW].[dbo].[DimCustomer]
GROUP BY HouseOwnerFlag
/*Average income of a Contoso Customer*/
SELECT 
AVG(YearlyIncome) AS AverageIncome
FROM [ContosoRetailDW].[dbo].[DimCustomer]
