CREATE PROCEDURE dbo.Weekly_Data_Refresh
AS
BEGIN
    TRUNCATE TABLE dbo.Raw_PartD_Prescribers;
    -- (Add data import logic here)
    EXEC dbo.Preprocess_PartD_Data;
    PRINT 'Data refresh completed: ' + CONVERT(VARCHAR, GETDATE());
END;
