USE DB2019_Ass2
GO

CREATE VIEW ConstructionEmployeeOverFifty
AS
	SELECT ConstructorEmployee.*
	FROM Employee, ConstructorEmployee
	WHERE Employee.EID = ConstructorEmployee.EID AND DATEDIFF(YEAR, Employee.BirthDate, GETDATE()) >= 50
GO

CREATE VIEW ApartmentNumberInNeighborhood
AS
	SELECT Neighborhood.[Name], Count(*) AS ApartmentsCount
	FROM Neighborhood JOIN Apartment ON Apartment.[NeighborhoodID] = Neighborhood.[NID]
	GROUP BY [NAME], [NID]
GO

--ALTER VIEW MaxParking
--AS
	--SELECT CarParking.[ParkingAreaID], CarParking.[CID], COUNT(*) AS NumberOfParkings
	--FROM CarParking JOIN ParkingArea ON CarParking.[ParkingAreaID] = ParkingArea.[AID]
	--GROUP BY [ParkingAreaID],[CID]
	--HAVING COUNT([CID]) >= ALL (SELECT COUNT(CID) FROM CarParking WHERE CarParking.[ParkingAreaID] = ParkingAreaID GROUP BY CID)
	--ORDER BY NumberOfParkings DESC  
--GO