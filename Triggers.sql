USE DB2019_Ass4
GO

CREATE TRIGGER DeleteProject ON Project
FOR DELETE
AS
	DELETE FROM ConstructorEmployee
	WHERE ConstructorEmployee.[EID] NOT IN (
		SELECT ConstructorEmployee.[EID] FROM ProjectConstructorEmployee, ConstructorEmployee
		WHERE ProjectConstructorEmployee.EID = ConstructorEmployee.EID
	) 
GO

CREATE TRIGGER Park ON CarParking
FOR UPDATE
AS
	IF TRIGGER_NESTLEVEL() > 1
	BEGIN
		RETURN
    END
	IF UPDATE(EndTime)
	BEGIN
		DECLARE @CarID int
		SET @CarID = (SELECT CarParking1.[CID] FROM inserted CarParking1 JOIN deleted CarParking2 ON (CarParking1.CID = CarParking2.CID AND CarParking1.StartTime = CarParking2.StartTime))
		DECLARE @ParkingAreaID int
		SET @ParkingAreaID = (SELECT TOP 1 CarParking.ParkingAreaID FROM CarParking WHERE @CarID = CarParking.[CID])
		DECLARE @RealCost int
		DECLARE @StartTime DATETIME
		DECLARE @EndTIme DATETIME
		SET @StartTime = (SELECT CarParking1.[StartTime] FROM inserted CarParking1 JOIN deleted CarParking2 ON (CarParking1.CID = CarParking2.CID AND CarParking1.StartTime = CarParking2.StartTime))
		SET @EndTIme = (SELECT CarParking1.[EndTime] FROM inserted CarParking1 JOIN deleted CarParking2 ON (CarParking1.CID = CarParking2.CID AND CarParking1.StartTime = CarParking2.StartTime))
		SET @RealCost = (DATEDIFF(HOUR, @StartTime, @EndTime) * (SELECT TOP 1 priceperhour FROM ParkingArea WHERE AID = @ParkingAreaID))
		DECLARE @MaxPrice int
		SET @MaxPrice = (SELECT maxpriceperday FROM ParkingArea WHERE AID = @ParkingAreaID)
		UPDATE CarParking
		SET EndTime = @EndTime,
			Cost = (SELECT Case When @RealCost < @MaxPrice
								Then @RealCost Else @MaxPrice END)
		WHERE CID = @CarID AND StartTime = @StartTime
	END
GO

CREATE TRIGGER ParkingDiscount ON CarParking
FOR UPDATE
AS
	IF TRIGGER_NESTLEVEL() > 2
	BEGIN
		RETURN
	END
	IF UPDATE(Cost)
	BEGIN
		DECLARE @CarId int
		SET @CarId = (SELECT CarParking.[CID] FROM inserted CarParking)
		DECLARE @StartTime DATETIME
		SET @StartTime = (SELECT CarParking.[StartTime] FROM inserted CarParking)
		DECLARE @Id int
		SET @Id = (SELECT Cars.[ID] FROM Cars WHERE Cars.[CID] = @CarId)
		DECLARE @RealCost int
		SET @RealCost = (SELECT CarParking.[Cost] FROM inserted CarParking)
		DECLARE @DiscountCost int
		SET @DiscountCost = 0.8 * @RealCost
		PRINT @RealCost
		PRINT @DiscountCost
		IF EXISTS (SELECT 1 FROM Employee WHERE Employee.[EID] = @Id)
		BEGIN
			SET @RealCost = @DiscountCost
		END
		UPDATE CarParking
		SET Cost = @RealCost
		WHERE CID = @CarId AND StartTime = @StartTime
	END
GO
