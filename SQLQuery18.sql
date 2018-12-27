USE DB2019_Ass2
GO

--EXECUTE sp_StartParking @CID ="16358945", @StartTime = '2002-05-23 20:25:10.487', @ParkingAreaID = 5
SELECT ParkingArea.AID, ParkingArea.Name, CarID FROM ParkingArea LEFT JOIN (

		SELECT cp1.ParkingAreaID, cp1.CID AS CarID 
		FROM CarParking AS cp1 
		GROUP BY cp1.ParkingAreaID, cp1.CID
		HAVING COUNT(cp1.CID)>=All(

			SELECT COUNT(CID) FROM CarParking AS cp2
			WHERE cp1.ParkingAreaID=cp2.ParkingAreaID 
			GROUP BY cp2.ParkingAreaID, cp2.CID
		)		
) AS tt ON ParkingArea.AID = tt.ParkingAreaID

SELECT CarParking.[ParkingAreaID], CarParking.[CID], COUNT(*) AS NumberOfParkings
	FROM CarParking JOIN ParkingArea ON CarParking.[ParkingAreaID] = ParkingArea.[AID]
	GROUP BY [ParkingAreaID],[CID]
	HAVING COUNT([CID]) >= ALL (SELECT COUNT(CID) FROM CarParking WHERE CarParking.[ParkingAreaID] = ParkingArea.[AID] GROUP BY CarParking.[CID])
	ORDER BY NumberOfParkings DESC  