-- =============================================
-- Description:	Create the DimDate dimension table
-- =============================================

-- DDL for Table DimDate
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'DimDate' AND schema_id = SCHEMA_ID('dbo'))
    DROP TABLE dbo.DimDate;
GO
CREATE TABLE dbo.DimDate (
    date_key INT NOT NULL,
    date DATE NOT NULL,
    day TINYINT NOT NULL,
    month TINYINT NOT NULL,
    year INT NOT NULL,
    quarter TINYINT NOT NULL,
    day_of_week_name VARCHAR(15) NOT NULL,
    month_name VARCHAR(15) NOT NULL,
    is_weekend BIT NOT NULL,
    
    CONSTRAINT PK_DimDate PRIMARY KEY (date_key)
);
GO

-- Populate Data
DECLARE @StartDate DATE = '2020-01-01';
DECLARE @EndDate DATE = '2026-12-31';

SET NOCOUNT ON; 

WHILE @StartDate <= @EndDate
BEGIN
    INSERT INTO dbo.DimDate (
        date_key, 
        date, 
        day, 
        month, 
        year, 
        quarter, 
        day_of_week_name, 
        month_name, 
        is_weekend
    )
    VALUES (
        CAST(FORMAT(@StartDate, 'yyyyMMdd') AS INT),
        @StartDate,
        DAY(@StartDate),
        MONTH(@StartDate),
        YEAR(@StartDate),
        DATEPART(QUARTER, @StartDate),
        DATENAME(WEEKDAY, @StartDate),
        DATENAME(MONTH, @StartDate),
        CASE WHEN DATEPART(WEEKDAY, @StartDate) IN (1, 7) THEN 1 ELSE 0 END -- Sunday(1), Saturday(7) is weekend
    );

    -- Tăng lên 1 ngày
    SET @StartDate = DATEADD(DAY, 1, @StartDate);
END;

SET NOCOUNT OFF;
GO