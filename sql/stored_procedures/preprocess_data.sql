CREATE PROCEDURE dbo.Preprocess_PartD_Data
AS
BEGIN
    TRUNCATE TABLE dbo.Clean_PartD_Prescribers;
    
    INSERT INTO dbo.Clean_PartD_Prescribers (
        NPI, Provider_Name, State, Provider_Type,
        Total_Claims, Total_Drug_Cost, Total_Day_Supply,
        GE65_Total_Claims, GE65_Total_Drug_Cost
    )
    SELECT
        Prscrbr_NPI,
        COALESCE(Prscrbr_Last_Org_Name, 'Unknown') + ', ' + COALESCE(Prscrbr_First_Name, ''),
        Prscrbr_State_Abrvtn,
        COALESCE(Prscrbr_Type, 'UNCLASSIFIED'),
        ISNULL(Tot_Clms, 0),
        ISNULL(Tot_Drug_Cst, 0.00),
        ISNULL(Tot_Day_Suply, 0),
        ISNULL(GE65_Tot_Clms, 0),
        ISNULL(GE65_Tot_Drug_Cst, 0.00)
    FROM dbo.Raw_PartD_Prescribers;
    
    PRINT 'Data preprocessing completed successfully';
END;
