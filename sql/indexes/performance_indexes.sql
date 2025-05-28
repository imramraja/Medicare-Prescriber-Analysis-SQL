CREATE NONCLUSTERED INDEX idx_Provider_Type 
ON dbo.Clean_PartD_Prescribers (Provider_Type);

CREATE NONCLUSTERED INDEX idx_State 
ON dbo.Clean_PartD_Prescribers (State);

CREATE COLUMNSTORE INDEX cstore_all 
ON dbo.Clean_PartD_Prescribers (
    Total_Drug_Cost, 
    Total_Claims, 
    GE65_Total_Drug_Cost,
    Total_Day_Supply
);
