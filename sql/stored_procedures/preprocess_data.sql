CREATE PROCEDURE dbo.Preprocess_PartD_Data
AS
BEGIN
    SET NOCOUNT ON;
    
    TRUNCATE TABLE dbo.Clean_PartD_Prescribers;
    
    INSERT INTO dbo.Clean_PartD_Prescribers (
        NPI, Provider_Name, City, State, State_FIPS, Provider_Type, Provider_Type_Src,
        Brand_Name, Generic_Name, Total_Claims, Total_30day_Fills, Total_Drug_Cost,
        Total_Day_Supply, Total_Beneficiaries, GE65_Supression_Flag, GE65_Total_Claims,
        GE65_Total_Drug_Cost, GE65_Total_30day_Fills, GE65_Total_Day_Supply, GE65_Bene_Supression_Flag
    )
    SELECT
        COALESCE(TRY_CAST(Prscrbr_NPI AS BIGINT), 0) AS NPI,
        COALESCE(Prscrbr_Last_Org_Name, 'Unknown') + ', ' + COALESCE(Prscrbr_First_Name, '') AS Provider_Name,
        COALESCE(Prscrbr_City, 'Unknown') AS City,
        COALESCE(Prscrbr_State_Abrvtn, 'XX') AS State,
        COALESCE(TRY_CAST(Prscrbr_State_FIPS AS INT), 0) AS State_FIPS,
        COALESCE(Prscrbr_Type, 'UNCLASSIFIED') AS Provider_Type,
        COALESCE(Prscrbr_Type_Src, 'U') AS Provider_Type_Src,
        COALESCE(Brnd_Name, 'Unknown') AS Brand_Name,
        COALESCE(Gnrc_Name, 'Unknown') AS Generic_Name,
        COALESCE(TRY_CAST(Tot_Clms AS INT), 0) AS Total_Claims,
        COALESCE(TRY_CAST(Tot_30day_Fills AS INT), 0) AS Total_30day_Fills,
        COALESCE(TRY_CAST(Tot_Drug_Cst AS DECIMAL(15,2)), 0.00) AS Total_Drug_Cost,
        COALESCE(TRY_CAST(Tot_Day_Suply AS INT), 0) AS Total_Day_Supply,
        COALESCE(TRY_CAST(Tot_Benes AS INT), 0) AS Total_Beneficiaries,
        COALESCE(GE65_Sprsn_Flag, 'U') AS GE65_Supression_Flag,
        COALESCE(TRY_CAST(GE65_Tot_Clms AS INT), 0) AS GE65_Total_Claims,
        COALESCE(TRY_CAST(GE65_Tot_Drug_Cst AS DECIMAL(15,2)), 0.00) AS GE65_Total_Drug_Cost,
        COALESCE(TRY_CAST(GE65_Tot_30day_Fills AS INT), 0) AS GE65_Total_30day_Fills,
        COALESCE(TRY_CAST(GE65_Tot_Day_Suply AS INT), 0) AS GE65_Total_Day_Supply,
        COALESCE(GE65_Bene_Sprsn_Flag, 'U') AS GE65_Bene_Supression_Flag
    FROM dbo.Medicare_Part_D;
    
    PRINT 'Data preprocessing completed. Rows processed: ' + CAST(@@ROWCOUNT AS VARCHAR(20));
END;
