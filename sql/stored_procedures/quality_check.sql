CREATE PROCEDURE dbo.Validate_Data_Quality
AS
BEGIN
    IF EXISTS (SELECT 1 FROM dbo.Clean_PartD_Prescribers WHERE Provider_Type = 'UNCLASSIFIED')
        PRINT 'Warning: Unclassified provider types found';
    
    DECLARE @AvgCost DECIMAL(15,2) = (SELECT AVG(Total_Drug_Cost) FROM dbo.Clean_PartD_Prescribers);
    DECLARE @StdDev DECIMAL(15,2) = (SELECT STDEV(Total_Drug_Cost) FROM dbo.Clean_PartD_Prescribers);
    
    IF EXISTS (
        SELECT 1 
        FROM dbo.Clean_PartD_Prescribers 
        WHERE Total_Drug_Cost > (@AvgCost + 3 * @StdDev)
    )
        PRINT 'Warning: Extreme cost outliers detected';
    
    PRINT 'Data quality check completed';
END;
