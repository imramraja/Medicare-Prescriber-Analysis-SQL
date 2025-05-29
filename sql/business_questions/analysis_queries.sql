-- 1. Top Cost-Driving Providers  
SELECT TOP 10  
    Prscrbr_NPI,  
    Prscrbr_Last_Org_Name,  
    Prscrbr_Type,  
    SUM(Tot_Drug_Cst) AS TotalCost,  
    SUM(Tot_Clms) AS TotalClaims,  
    FORMAT(SUM(Tot_Drug_Cst) / SUM(Tot_Clms), 'C') AS AvgCostPerClaim  
FROM dbo.Clean_PartD_Prescribers  
GROUP BY Prscrbr_NPI, Prscrbr_Last_Org_Name, Prscrbr_Type  
HAVING SUM(Tot_Clms) > 100  
ORDER BY TotalCost DESC;  

-- 2. Brand vs Generic Drug Utilization  
SELECT  
    Prscrbr_State_Abrvtn AS State,  
    FORMAT(SUM(CASE WHEN Brnd_Name IS NOT NULL THEN Tot_Drug_Cst END), 'C') AS BrandCost,  
    FORMAT(SUM(CASE WHEN Gnrc_Name IS NOT NULL THEN Tot_Drug_Cst END), 'C') AS GenericCost,  
    FORMAT(100.0 * SUM(CASE WHEN Gnrc_Name IS NOT NULL THEN Tot_Drug_Cst END) /  
        NULLIF(SUM(Tot_Drug_Cst), 0), 'N1') AS GenericPenetration  
FROM dbo.Clean_PartD_Prescribers  
GROUP BY Prscrbr_State_Abrvtn  
HAVING SUM(Tot_Drug_Cst) > 1000000;  

-- 3. Senior (65+) Drug Utilization Patterns  
SELECT  
    Prscrbr_Type,  
    FORMAT(SUM(GE65_Tot_Clms), 'N0') AS SeniorClaims,  
    FORMAT(SUM(GE65_Tot_Drug_Cst), 'C') AS SeniorCost,  
    FORMAT(100.0 * SUM(GE65_Tot_Clms) / SUM(Tot_Clms), 'N1') AS SeniorClaimPct  
FROM dbo.Clean_PartD_Prescribers  
WHERE GE65_Sprsn_Flag = '#' AND Tot_Clms > 0  
GROUP BY Prscrbr_Type  
ORDER BY SeniorCost DESC;  

-- 4. Geographic Cost Variation  
WITH StateData AS (  
    SELECT  
        Prscrbr_State_Abrvtn,  
        SUM(Tot_Drug_Cst) AS TotalCost,  
        AVG(1.0 * Tot_Drug_Cst / Tot_Clms) AS AvgCostPerClaim  
    FROM dbo.Clean_PartD_Prescribers  
    WHERE Tot_Clms > 0  
    GROUP BY Prscrbr_State_Abrvtn  
)  
SELECT  
    Prscrbr_State_Abrvtn AS State,  
    FORMAT(TotalCost, 'C') AS TotalCost,  
    FORMAT(AvgCostPerClaim, 'C') AS AvgCostPerClaim,  
    FORMAT(AvgCostPerClaim - (SELECT AVG(1.0 * Tot_Drug_Cst / Tot_Clms)   
        FROM dbo.Clean_PartD_Prescribers WHERE Tot_Clms > 0), 'C') AS CostVariance  
FROM StateData  
ORDER BY CostVariance DESC;  

-- 5. Provider Prescribing Efficiency  
SELECT  
    Prscrbr_NPI,  
    Prscrbr_Last_Org_Name,  
    Prscrbr_Type,  
    SUM(Tot_Drug_Cst) AS TotalCost,  
    SUM(Tot_Day_Suply) AS TotalSupply,  
    FORMAT(SUM(Tot_Drug_Cst) / SUM(Tot_Day_Suply), 'C') AS CostPerDay,  
    RANK() OVER (ORDER BY SUM(Tot_Drug_Cst) / SUM(Tot_Day_Suply) DESC) AS CostRank  
FROM dbo.Clean_PartD_Prescribers  
WHERE Tot_Day_Suply > 0  
GROUP BY Prscrbr_NPI, Prscrbr_Last_Org_Name, Prscrbr_Type  
HAVING SUM(Tot_Day_Suply) > 1000;  

-- 6. 30-Day Fill Rate Analysis  
SELECT  
    Prscrbr_Type,  
    FORMAT(100.0 * SUM(Tot_30day_Fills) / SUM(Tot_Clms), 'N1') AS OverallFillRate,  
    FORMAT(100.0 * SUM(GE65_Tot_30day_Fills) / SUM(GE65_Tot_Clms), 'N1') AS SeniorFillRate,  
    FORMAT((100.0 * SUM(Tot_30day_Fills) / SUM(Tot_Clms)) -  
        (100.0 * SUM(GE65_Tot_30day_Fills) / SUM(GE65_Tot_Clms)), 'N1') AS FillRateDiff  
FROM dbo.Clean_PartD_Prescribers  
WHERE Tot_Clms > 0 AND GE65_Tot_Clms > 0  
GROUP BY Prscrbr_Type;  

-- 7. Cost Concentration Analysis  
WITH ProviderCosts AS (  
    SELECT  
        Prscrbr_NPI,  
        SUM(Tot_Drug_Cst) AS TotalCost  
    FROM dbo.Clean_PartD_Prescribers  
    GROUP BY Prscrbr_NPI  
)  
SELECT  
    'Top 1%' AS Category,  
    FORMAT(SUM(TotalCost), 'C') AS TotalCost,  
    FORMAT(100.0 * SUM(TotalCost) / (SELECT SUM(Tot_Drug_Cst) FROM dbo.Clean_PartD_Prescribers), 'N1') AS CostShare  
FROM (  
    SELECT TOP 1 PERCENT TotalCost  
    FROM ProviderCosts  
    ORDER BY TotalCost DESC  
) AS Top1  
UNION ALL  
SELECT  
    'Bottom 99%',  
    FORMAT(SUM(TotalCost), 'C'),  
    FORMAT(100.0 * SUM(TotalCost) / (SELECT SUM(Tot_Drug_Cst) FROM dbo.Clean_PartD_Prescribers), 'N1')  
FROM ProviderCosts  
WHERE Prscrbr_NPI NOT IN (  
    SELECT TOP 1 PERCENT Prscrbr_NPI   
    FROM ProviderCosts   
    ORDER BY TotalCost DESC  
);  

-- 8. Therapy Intensity by Drug  
SELECT  
    Brnd_Name,  
    FORMAT(AVG(1.0 * Tot_Day_Suply / NULLIF(Tot_Clms, 0)), 'N1') AS AvgDaysPerClaim,  
    FORMAT(AVG(1.0 * GE65_Tot_Day_Suply / NULLIF(GE65_Tot_Clms, 0)), 'N1') AS SeniorDaysPerClaim,  
    FORMAT(AVG(1.0 * Tot_Drug_Cst / NULLIF(Tot_Day_Suply, 0)), 'C') AS CostPerDay  
FROM dbo.Clean_PartD_Prescribers  
WHERE Tot_Clms > 100 AND Brnd_Name IS NOT NULL  
GROUP BY Brnd_Name  
HAVING AVG(1.0 * Tot_Day_Suply / NULLIF(Tot_Clms, 0)) > 0;  

-- 9. Prescriber Type Benchmarking  
SELECT  
    Prscrbr_Type,  
    FORMAT(AVG(1.0 * Tot_Drug_Cst / Tot_Clms), 'C') AS AvgCostPerClaim,  
    FORMAT(STDEV(1.0 * Tot_Drug_Cst / Tot_Clms), 'C') AS StDevCost,  
    FORMAT(AVG(1.0 * Tot_Day_Suply / Tot_Clms), 'N1') AS AvgDaysPerClaim,  
    FORMAT(100.0 * SUM(GE65_Tot_Clms) / SUM(Tot_Clms), 'N1') AS SeniorClaimPct  
FROM dbo.Clean_PartD_Prescribers  
WHERE Tot_Clms > 50  
GROUP BY Prscrbr_Type  
ORDER BY AvgCostPerClaim DESC;  

-- 10. State-Level Senior Drug Utilization  
SELECT  
    Prscrbr_State_Abrvtn AS State,  
    FORMAT(SUM(GE65_Tot_Drug_Cst), 'C') AS SeniorDrugCost,  
    FORMAT(100.0 * SUM(GE65_Tot_Drug_Cst) / SUM(Tot_Drug_Cst), 'N1') AS SeniorCostPct,  
    FORMAT(SUM(GE65_Tot_Clms) * 1.0 / SUM(GE65_Tot_Day_Suply), 'N2') AS ClaimsPerSupplyDay,  
    RANK() OVER (ORDER BY SUM(GE65_Tot_Drug_Cst) DESC) AS CostRank  
FROM dbo.Clean_PartD_Prescribers  
WHERE GE65_Sprsn_Flag = '#' AND Tot_Drug_Cst > 0  
GROUP BY Prscrbr_State_Abrvtn;  

-- 11. High-Cost Drug Identification  
SELECT  
    Brnd_Name,  
    FORMAT(SUM(Tot_Drug_Cst), 'C') AS TotalCost,  
    FORMAT(AVG(1.0 * Tot_Drug_Cst / Tot_Clms), 'C') AS AvgCostPerClaim,  
    COUNT(DISTINCT Prscrbr_NPI) AS PrescriberCount,  
    FORMAT(SUM(Tot_Clms), 'N0') AS TotalClaims,  
    FORMAT(100.0 * SUM(GE65_Tot_Clms) / SUM(Tot_Clms), 'N1') AS SeniorPrescriptionRate  
FROM dbo.Clean_PartD_Prescribers  
WHERE Brnd_Name IS NOT NULL AND Tot_Clms > 0  
GROUP BY Brnd_Name  
HAVING SUM(Tot_Drug_Cst) > 1000000  
ORDER BY AvgCostPerClaim DESC;  

-- 12. Supply Chain Efficiency  
SELECT  
    Prscrbr_State_Abrvtn AS State,  
    FORMAT(SUM(Tot_Day_Suply) / SUM(Tot_Clms), 'N1') AS DaysPerClaim,  
    FORMAT(SUM(GE65_Tot_Day_Suply) / SUM(GE65_Tot_Clms), 'N1') AS SeniorDaysPerClaim,  
    FORMAT(100.0 * SUM(Tot_30day_Fills) / SUM(Tot_Clms), 'N1') AS ThirtyDayFillRate,  
    FORMAT(SUM(Tot_Drug_Cst) / SUM(Tot_Day_Suply), 'C') AS CostPerDay  
FROM dbo.Clean_PartD_Prescribers  
WHERE Tot_Clms > 0  
GROUP BY Prscrbr_State_Abrvtn  
ORDER BY DaysPerClaim DESC;  

-- 13. Beneficiary Cost Burden  
SELECT  
    Prscrbr_Type,  
    FORMAT(AVG(1.0 * Tot_Drug_Cst / NULLIF(Tot_Benes, 0)), 'C') AS CostPerBeneficiary,  
    FORMAT(AVG(1.0 * GE65_Tot_Drug_Cst / NULLIF(GE65_Tot_Clms, 0)), 'C') AS SeniorCostPerClaim,  
    FORMAT(AVG(1.0 * Tot_Day_Suply / NULLIF(Tot_Benes, 0)), 'N1') AS DaysPerBeneficiary  
FROM dbo.Clean_PartD_Prescribers  
WHERE Tot_Benes > 10 AND GE65_Tot_Clms > 0  
GROUP BY Prscrbr_Type  
ORDER BY CostPerBeneficiary DESC;  

-- 14. Provider Productivity  
SELECT  
    Prscrbr_State_Abrvtn AS State,  
    FORMAT(AVG(1.0 * Tot_Clms / NULLIF(Tot_Benes, 0)), 'N1') AS ClaimsPerBeneficiary,  
    FORMAT(AVG(1.0 * Tot_Day_Suply / NULLIF(Tot_Benes, 0)), 'N1') AS DaysPerBeneficiary,  
    FORMAT(AVG(1.0 * Tot_Drug_Cst / NULLIF(Tot_Benes, 0)), 'C') AS CostPerBeneficiary  
FROM dbo.Clean_PartD_Prescribers  
WHERE Tot_Benes > 10  
GROUP BY Prscrbr_State_Abrvtn  
HAVING AVG(1.0 * Tot_Clms / NULLIF(Tot_Benes, 0)) IS NOT NULL;  

-- 15. Therapy Consistency Analysis  
SELECT  
    Prscrbr_Type,  
    FORMAT(AVG(1.0 * Tot_30day_Fills / Tot_Clms), 'P0') AS ThirtyDayFillRate,  
    FORMAT(AVG(1.0 * GE65_Tot_30day_Fills / GE65_Tot_Clms), 'P0') AS SeniorThirtyDayFillRate,  
    FORMAT(CORR(1.0 * Tot_30day_Fills / Tot_Clms, 1.0 * Tot_Day_Suply / Tot_Clms), 'N2') AS FillSupplyCorrelation  
FROM dbo.Clean_PartD_Prescribers  
WHERE Tot_Clms > 50 AND GE65_Tot_Clms > 10  
GROUP BY Prscrbr_Type;  

-- 16. Cost Efficiency Outliers  
WITH ProviderStats AS (  
    SELECT  
        NPI,  
        Provider_Name,  
        Total_Drug_Cost,  
        dbo.Calculate_CostPerDay(Total_Day_Supply, Total_Drug_Cost) AS CostPerDay,  
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY dbo.Calculate_CostPerDay(Total_Day_Supply, Total_Drug_Cost))   
            OVER () AS MedianCostPerDay  
    FROM dbo.Clean_PartD_Prescribers  
)  
SELECT TOP 20 *  
FROM ProviderStats  
WHERE CostPerDay > 2 * MedianCostPerDay  
ORDER BY CostPerDay DESC;  

-- 17. Brand vs Generic Market Penetration  
SELECT  
    State,  
    100.0 * SUM(CASE WHEN Brand_Name IS NULL THEN Total_Drug_Cost END) / SUM(Total_Drug_Cost) AS Generic_Market_Share,  
    SUM(CASE WHEN Brand_Name IS NOT NULL THEN Total_Drug_Cost END) AS Brand_Cost,  
    SUM(CASE WHEN Brand_Name IS NULL THEN Total_Drug_Cost END) AS Generic_Cost  
FROM dbo.Clean_PartD_Prescribers  
GROUP BY State;  

-- 18. Therapy Adherence Analysis  
SELECT  
    Provider_Type,  
    dbo.Calculate_FillRate(SUM(Total_30Day_Fills), SUM(Total_Claims)) AS Overall_Fill_Rate,  
    dbo.Calculate_FillRate(SUM(GE65_Total_30day_Fills), SUM(GE65_Total_Claims)) AS Senior_Fill_Rate,  
    CASE WHEN SUM(Total_Claims) > 100 THEN   
        SUM(Total_Day_Supply) / SUM(Total_Claims)   
        ELSE NULL END AS Avg_Therapy_Days  
FROM dbo.Clean_PartD_Prescribers  
GROUP BY Provider_Type;  

-- 19. High-Cost Drug Prescribers  
SELECT  
    NPI,  
    Provider_Name,  
    Brand_Name,  
    Total_Claims,  
    Total_Drug_Cost,  
    RANK() OVER (PARTITION BY Brand_Name ORDER BY Total_Drug_Cost DESC) AS Prescriber_Rank  
FROM dbo.Clean_PartD_Prescribers  
WHERE Brand_Name IS NOT NULL  
    AND Total_Drug_Cost > 100000;  

-- 20. Beneficiary Cost Burden  
SELECT  
    State,  
    AVG(Total_Drug_Cost / NULLIF(Total_Beneficiaries, 0)) AS Avg_Cost_Per_Beneficiary,  
    CORR(Total_Claims * 1.0, Total_Drug_Cost) AS Claims_Cost_Correlation  
FROM dbo.Clean_PartD_Prescribers  
WHERE Total_Beneficiaries > 10  
GROUP BY State;  

-- 21. Therapy Day Consistency  
SELECT  
    Generic_Name,  
    STDEV(Total_Day_Supply * 1.0 / NULLIF(Total_Claims, 0)) AS StdDev_DaysPerClaim,  
    AVG(Total_Day_Supply * 1.0 / NULLIF(Total_Claims, 0)) AS Avg_DaysPerClaim  
FROM dbo.Clean_PartD_Prescribers  
WHERE Total_Claims > 50  
GROUP BY Generic_Name  
HAVING STDEV(Total_Day_Supply * 1.0 / NULLIF(Total_Claims, 0)) > 5;  

-- 22. Senior Care Disparities  
SELECT  
    State,  
    SUM(GE65_Total_Drug_Cost) * 100.0 / SUM(Total_Drug_Cost) AS Senior_Cost_Share,  
    SUM(GE65_Total_Claims) * 100.0 / SUM(Total_Claims) AS Senior_Claim_Share,  
    (SUM(GE65_Total_Drug_Cost) / NULLIF(SUM(GE65_Total_Claims),0)) -   
        (SUM(Total_Drug_Cost) / NULLIF(SUM(Total_Claims),0)) AS Cost_Per_Claim_Difference  
FROM dbo.Clean_PartD_Prescribers  
GROUP BY State;  

-- 23. Provider Productivity Clusters  
WITH KMeansData AS (  
    SELECT  
        NPI,  
        Total_Claims,  
        Total_Drug_Cost,  
        NTILE(4) OVER (ORDER BY Total_Claims) AS Claims_Quartile,  
        NTILE(4) OVER (ORDER BY Total_Drug_Cost) AS Cost_Quartile  
    FROM dbo.Clean_PartD_Prescribers  
)  
SELECT  
    Claims_Quartile,  
    Cost_Quartile,  
    COUNT(*) AS Provider_Count,  
    AVG(Total_Claims) AS Avg_Claims,  
    AVG(Total_Drug_Cost) AS Avg_Cost  
FROM KMeansData  
GROUP BY Claims_Quartile, Cost_Quartile  
ORDER BY Claims_Quartile, Cost_Quartile;  

-- 24. Drug Cost Forecasting  
SELECT  
    Generic_Name,  
    YEAR(GETDATE()) AS Current_Year,  
    SUM(Total_Drug_Cost) AS Current_Cost,  
    SUM(Total_Drug_Cost) * 1.07 AS Next_Year_Forecast,  
    SUM(Total_Drug_Cost) * POWER(1.07, 3) AS Three_Year_Forecast  
FROM dbo.Clean_PartD_Prescribers  
GROUP BY Generic_Name  
HAVING SUM(Total_Drug_Cost) > 1000000;  

-- 25. Anomaly Detection  
WITH Stats AS (  
    SELECT  
        AVG(Total_Drug_Cost) AS Avg_Cost,  
        STDEV(Total_Drug_Cost) AS StdDev_Cost  
    FROM dbo.Clean_PartD_Prescribers  
    WHERE Provider_Type = 'Family Practice'  
)  
SELECT  
    NPI,  
    Provider_Name,  
    Total_Drug_Cost,  
    (Total_Drug_Cost - s.Avg_Cost) / s.StdDev_Cost AS Z_Score  
FROM dbo.Clean_PartD_Prescribers p, Stats s  
WHERE Provider_Type = 'Family Practice'  
    AND ABS((Total_Drug_Cost - s.Avg_Cost) / s.StdDev_Cost) > 3;
