CREATE FUNCTION dbo.Calculate_FillRate (@Fills INT, @Claims INT)
RETURNS DECIMAL(5,2)
AS
BEGIN
    RETURN CASE 
        WHEN @Claims > 0 THEN (@Fills * 100.0) / @Claims 
        ELSE 0 END;
END;
