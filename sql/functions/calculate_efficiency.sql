CREATE FUNCTION dbo.Calculate_Efficiency (@Claims INT, @Cost DECIMAL(15,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN CASE 
        WHEN @Claims > 1000 THEN @Cost / @Claims 
        ELSE NULL END;
END;
