CREATE TRIGGER dbo.trg_Data_Validation
ON dbo.Clean_PartD_Prescribers
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE Total_Drug_Cost < 0)
    BEGIN
        RAISERROR('Invalid drug cost: Negative values not allowed', 16, 1);
        ROLLBACK TRANSACTION;
    END

    IF EXISTS (
        SELECT 1 FROM inserted
        WHERE State NOT IN (
            'AL','AK','AZ','AR','CA','CO','CT','DE','FL','GA','HI','ID','IL','IN','IA',
            'KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ',
            'NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VT',
            'VA','WA','WV','WI','WY'
        )
    )
    BEGIN
        RAISERROR('Invalid state abbreviation', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
