CREATE OR ALTER PROCEDURE dbo.Preprocess_PartD_Data
AS
BEGIN
    TRUNCATE TABLE dbo.Clean_PartD_Prescribers;
    
    INSERT INTO dbo.Clean_PartD_Prescribers (
        NPI, 
        Provider_Name, 
        City,
        State, 
        State_FIPS,
        Provider_Type,
        Provider_Type_Src,
        Brand_Name,
        Generic_Name,
        Total_Claims,
        Total_30day_Fills, 
        Total_Drug_Cost, 
        Total_Day_Supply,
        Total_Beneficiaries,
        GE65_Supression_Flag,
        GE65_Total_Claims, 
        GE65_Total_Drug_Cost,
        GE65_Total_30day_Fills,
        GE65_Total_Day_Supply,
        GE65_Bene_Supression_Flag
    )
    SELECT
        COALESCE(TRY_CAST(Prscrbr_NPI AS BIGINT), 0),
        COALESCE(Prscrbr_Last_Org_Name, 'Unknown') + ', ' + COALESCE(Prscrbr_First_Name, ''),
        COALESCE(Prscrbr_City, 'Unknown'),
        COALESCE(Prscrbr_State_Abrvtn, 'XX'),
        COALESCE(
            CASE 
                WHEN Prscrbr_State_FIPS IN ('*', '#') OR Prscrbr_State_FIPS = '' THEN 0
                ELSE TRY_CAST(Prscrbr_State_FIPS AS INT)
            END, 0
        ),
        COALESCE(Prscrbr_Type, 'UNCLASSIFIED'),
        COALESCE(
            CASE 
                WHEN Prscrbr_Type_Src IN ('*', '#') OR Prscrbr_Type_Src = '' THEN 'U'
                ELSE Prscrbr_Type_Src
            END, 'U'
        ),
        COALESCE(Brnd_Name, 'Unknown'),
        COALESCE(Gnrc_Name, 'Unknown'),
        COALESCE(
            CASE 
                WHEN Tot_Clms IN ('*', '#') OR Tot_Clms = '' THEN 0
                ELSE TRY_CAST(Tot_Clms AS INT) 
            END, 0
        ),
        COALESCE(
            CASE 
                WHEN Tot_30day_Fills IN ('*', '#') OR Tot_30day_Fills = '' THEN 0
                ELSE TRY_CAST(Tot_30day_Fills AS INT) 
            END, 0
        ),
        COALESCE(
            CASE 
                WHEN Tot_Drug_Cst IN ('*', '#') OR Tot_Drug_Cst = '' THEN 0.00
                ELSE TRY_CAST(Tot_Drug_Cst AS DECIMAL(15,2)) 
            END, 0.00
        ),
        COALESCE(
            CASE 
                WHEN Tot_Day_Suply IN ('*', '#') OR Tot_Day_Suply = '' THEN 0
                ELSE TRY_CAST(Tot_Day_Suply AS INT) 
            END, 0
        ),
        COALESCE(
            CASE 
                WHEN Tot_Benes IN ('*', '#') OR Tot_Benes = '' THEN 0
                ELSE TRY_CAST(Tot_Benes AS INT) 
            END, 0
        ),
        COALESCE(
            CASE 
                WHEN GE65_Sprsn_Flag IN ('*', '#') OR GE65_Sprsn_Flag = '' THEN 'U'
                ELSE GE65_Sprsn_Flag
            END, 'U'
        ),
        COALESCE(
            CASE 
                WHEN GE65_Tot_Clms IN ('*', '#') OR GE65_Tot_Clms = '' THEN 0
                ELSE TRY_CAST(GE65_Tot_Clms AS INT) 
            END, 0
        ),
        COALESCE(
            CASE 
                WHEN GE65_Tot_Drug_Cst IN ('*', '#') OR GE65_Tot_Drug_Cst = '' THEN 0.00
                ELSE TRY_CAST(GE65_Tot_Drug_Cst AS DECIMAL(15,2)) 
            END, 0.00
        ),
        COALESCE(
            CASE 
                WHEN GE65_Tot_30day_Fills IN ('*', '#') OR GE65_Tot_30day_Fills = '' THEN 0
                ELSE TRY_CAST(GE65_Tot_30day_Fills AS INT) 
            END, 0
        ),
        COALESCE(
            CASE 
                WHEN GE65_Tot_Day_Suply IN ('*', '#') OR GE65_Tot_Day_Suply = '' THEN 0
                ELSE TRY_CAST(GE65_Tot_Day_Suply AS INT) 
            END, 0
        ),
        COALESCE(
            CASE 
                WHEN GE65_Bene_Sprsn_Flag IN ('*', '#') OR GE65_Bene_Sprsn_Flag = '' THEN 'U'
                ELSE GE65_Bene_Sprsn_Flag
            END, 'U'
        )
    FROM dbo.Medicare_Part_D;
    
    PRINT 'Data preprocessing completed successfully';
END;
