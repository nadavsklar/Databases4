USE DB2019_Ass4
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

CREATE VIEW MaxParking AS
SELECT ParkingArea.AID, ParkingArea.Name, CarID FROM ParkingArea LEFT JOIN (

		SELECT carParking1.ParkingAreaID, carParking1.CID AS CarID 
		FROM CarParking AS carParking1 
		GROUP BY carParking1.ParkingAreaID, carParking1.CID
		HAVING COUNT(carParking1.CID)>=All(
			SELECT COUNT(CID) FROM CarParking AS carParking2
			WHERE carParking1.ParkingAreaID=carParking2.ParkingAreaID 
			GROUP BY carParking2.ParkingAreaID, carParking2.CID
		)		
) AS carI ON ParkingArea.AID = carI.ParkingAreaID
