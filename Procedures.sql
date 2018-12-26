USE DB2019_Ass2
GO

CREATE PROCEDURE sp_AddMunicipalEmployee
@EID int,
@LastName varchar(255),
@FirstName varchar(255),
@BirthDate date,
@StreetName varchar(255), 
@Number int,
@door int,
@City varchar(255)
AS
BEGIN
	INSERT INTO Employee
	VALUES (@EID, @LastName, @FirstName, @BirthDate, @StreetName, @Number, @door, @City)
END
GO

CREATE PROCEDURE sp_AddMunicipalEmployeeOfficial
@EID int,
@LastName varchar(255),
@FirstName varchar(255),
@BirthDate date,
@StreetName varchar(255), 
@Number int,
@door int,
@City varchar(255),
@StartDate date,
@Degree varchar(255),
@DepartmentId int
AS
BEGIN
	INSERT INTO Employee
	VALUES (@EID, @LastName, @FirstName, @BirthDate, @StreetName, @Number, @door, @City)
	INSERT INTO OfficialEmployee
	VALUES (@EID, @StartDate, @Degree, @DepartmentId)
END
GO

CREATE PROCEDURE sp_AddMunicipalEmployeeConstructor
@EID int,
@LastName varchar(255),
@FirstName varchar(255),
@BirthDate date,
@StreetName varchar(255), 
@Number int,
@door int,
@City varchar(255),
@CompanyName varchar(255),
@SalaryPerDay int
AS
BEGIN
	INSERT INTO Employee
	VALUES (@EID, @LastName, @FirstName, @BirthDate, @StreetName, @Number, @door, @City)
	INSERT INTO ConstructorEmployee
	VALUES (@EID, @CompanyName, @SalaryPerDay)
END
GO

CREATE PROCEDURE sp_StartParking
@CID int,
@StartTime datetime, 
@ParkingAreaID int
AS
BEGIN
	INSERT INTO CarParking (CID, StartTime, ParkingAreaID)
	VALUES (@CID, @StartTime, @ParkingAreaID)
END
GO

CREATE PROCEDURE sp_EndParking
@CID int,
@StartTime datetime, 
@EndTime datetime
AS
BEGIN
	DECLARE @ParkingAreaID int
	SET @ParkingAreaID = (SELECT TOP 1 CarParking.ParkingAreaID FROM CarParking WHERE CID = @CID AND StartTime = @StartTime)
	DECLARE @RealCost int
	SET @RealCost = (DATEDIFF(HOUR, @StartTime, @EndTime) * (SELECT TOP 1 priceperhour FROM ParkingArea WHERE AID = @ParkingAreaID))
	DECLARE @MaxPrice int
	SET @MaxPrice = (SELECT maxpriceperday FROM ParkingArea WHERE AID = @ParkingAreaID)
	UPDATE CarParking
	SET EndTime = @EndTime,
		Cost = (SELECT Case When @RealCost < @MaxPrice
							Then @RealCost Else @MaxPrice END)
	WHERE CID = @CID AND StartTime = @StartTime
END
GO
