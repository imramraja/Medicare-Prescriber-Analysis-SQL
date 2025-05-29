CREATE PROCEDURE dbo.Preprocess_PartD_Data
AS
BEGIN
    TRUNCATE TABLE dbo.Clean_PartD_Prescribers;
    
    INSERT INTO dbo.Clean_PartD_Prescribers (
        NPI, Provider_Name, State, Provider_Type,
        Total_Claims,Total_30day_Fills, Total_Drug_Cost, Total_Day_Supply,
        GE65_Total_Claims, GE65_Total_Drug_Cost
    )
    SELECT
        Prscrbr_NPI,
        COALESCE(Prscrbr_Last_Org_Name, 'Unknown') + ', ' + COALESCE(Prscrbr_First_Name, ''),
        Prscrbr_State_Abrvtn,
        COALESCE(Prscrbr_Type, 'UNCLASSIFIED'),
        -- Ensure no NULLs for non-nullable columns
        COALESCE(
            CASE 
                WHEN Tot_Clms IN ('*', '#') OR Tot_Clms = '' THEN 0
                ELSE TRY_CAST(Tot_Clms AS INT) 
            END, 0
        ) AS Total_Claims,
        COALESCE(
            CASE 
                WHEN Tot_30day_Fills IN ('*', '#') OR Tot_30day_Fills = '' THEN 0
                ELSE TRY_CAST(Tot_30day_Fills AS INT) 
            END, 0
        ) AS Total_30day_Fills,
        COALESCE(
            CASE 
                WHEN Tot_Drug_Cst IN ('*', '#') OR Tot_Drug_Cst = '' THEN 0.00
                ELSE TRY_CAST(Tot_Drug_Cst AS DECIMAL(15,2)) 
            END, 0.00
        ) AS Total_Drug_Cost,
        COALESCE(
            CASE 
                WHEN Tot_Day_Suply IN ('*', '#') OR Tot_Day_Suply = '' THEN 0
                ELSE TRY_CAST(Tot_Day_Suply AS INT) 
            END, 0
        ) AS Total_Day_Supply,
        -- GE65 columns (nullable)
        CASE 
            WHEN GE65_Tot_Clms IN ('*', '#') OR GE65_Tot_Clms = '' THEN 0
            ELSE TRY_CAST(GE65_Tot_Clms AS INT) 
        END,
        CASE 
            WHEN GE65_Tot_Drug_Cst IN ('*', '#') OR GE65_Tot_Drug_Cst = '' THEN 0.00
            ELSE TRY_CAST(GE65_Tot_Drug_Cst AS DECIMAL(15,2)) 
        END
    FROM dbo.Medicare_Part_D;
    
    PRINT 'Data preprocessing completed successfully';
END;
