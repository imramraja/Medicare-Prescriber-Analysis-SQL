CREATE VIEW dbo.Senior_Care_Analysis
AS
SELECT
    State,
    Provider_Type,
    SUM(GE65_Total_Drug_Cost) AS Senior_Cost,
    SUM(GE65_Total_Drug_Cost) * 100.0 / SUM(Total_Drug_Cost) AS Senior_Cost_Pct
FROM dbo.Clean_PartD_Prescribers
GROUP BY State, Provider_Type;
