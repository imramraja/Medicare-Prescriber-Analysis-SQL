CREATE VIEW dbo.PowerBI_Analysis
AS
SELECT
    NPI,
    Provider_Name,
    State,
    Provider_Type,
    Total_Claims,
    Total_Drug_Cost,
    Total_Day_Supply,
    GE65_Total_Claims,
    GE65_Total_Drug_Cost,
    dbo.Calculate_FillRate(Total_30day_Fills, Total_Claims) AS Fill_Rate,
    Cost_Per_Day,
    Senior_Cost_Pct
FROM dbo.Clean_PartD_Prescribers;
