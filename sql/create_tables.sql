USE MedicarePartDAnalysis;
GO

-- Raw data table
CREATE TABLE dbo.Raw_PartD_Prescribers (
    Prscrbr_NPI BIGINT,
    Prscrbr_Last_Org_Name NVARCHAR(255),
    Prscrbr_First_Name NVARCHAR(255),
    Prscrbr_City NVARCHAR(100),
    Prscrbr_State_Abrvtn CHAR(2),
    Prscrbr_State_FIPS INT,
    Prscrbr_Type NVARCHAR(100),
    Prscrbr_Type_Src CHAR(1),
    Brnd_Name NVARCHAR(255),
    Gnrc_Name NVARCHAR(255),
    Tot_Clms INT,
    Tot_30day_Fills INT,
    Tot_Day_Suply INT,
    Tot_Drug_Cst DECIMAL(15,2),
    Tot_Benes INT,
    GE65_Sprsn_Flag CHAR(1),
    GE65_Tot_Clms INT,
    GE65_Tot_30day_Fills INT,
    GE65_Tot_Drug_Cst DECIMAL(15,2),
    GE65_Tot_Day_Suply INT,
    GE65_Bene_Sprsn_Flag CHAR(1)
);

-- Cleaned data table
CREATE TABLE dbo.Clean_PartD_Prescribers (
    NPI BIGINT PRIMARY KEY,
    Provider_Name NVARCHAR(255) NOT NULL,
    City NVARCHAR(100) NOT NULL,
    State CHAR(2) NOT NULL,
    State_FIPS INT NOT NULL,
    Provider_Type NVARCHAR(100) NOT NULL,
    Provider_Type_Src CHAR(1) NOT NULL,
    Brand_Name NVARCHAR(255) NOT NULL,
    Generic_Name NVARCHAR(255) NOT NULL,
    Total_Claims INT NOT NULL,
    Total_30day_Fills INT NOT NULL,
    Total_Drug_Cost DECIMAL(15,2) NOT NULL,
    Total_Day_Supply INT NOT NULL,
    Total_Beneficiaries INT NOT NULL,
    GE65_Supression_Flag CHAR(1) NOT NULL,
    GE65_Total_Claims INT,
    GE65_Total_Drug_Cost DECIMAL(15,2),
    GE65_Total_30day_Fills INT,
    GE65_Total_Day_Supply INT,
    GE65_Bene_Supression_Flag CHAR(1),
    Cost_Per_Day AS CASE 
        WHEN Total_Day_Supply > 0 
        THEN Total_Drug_Cost / Total_Day_Supply 
        ELSE 0 END,
    Senior_Cost_Pct AS CASE 
        WHEN Total_Drug_Cost > 0 
        THEN GE65_Total_Drug_Cost * 100.0 / Total_Drug_Cost 
        ELSE 0 END
);
