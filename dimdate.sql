IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
BEGIN
    CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
    WITH (
        FORMAT_TYPE = DELIMITEDTEXT ,
        FORMAT_OPTIONS (
            FIELD_TERMINATOR = ',',
            USE_TYPE_DEFAULT = FALSE
        )
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'udacitydemo2hqxb_udacitydemo2hqxb_dfs_core_windows_net') 
BEGIN
    CREATE EXTERNAL DATA SOURCE [udacitydemo2hqxb_udacitydemo2hqxb_dfs_core_windows_net] 
    WITH (
        LOCATION = 'abfss://udacitydemo2hqxb@udacitydemo2hqxb.dfs.core.windows.net' 
    );
END
GO

CREATE EXTERNAL TABLE dbo.DimDate (
    [DateKey] datetime,
    [Date] nvarchar(4000),
    [Year] nvarchar(4000),
    [Quarter] nvarchar(4000),
    [Month] nvarchar(4000),
    [Day] nvarchar(4000),
    [DayOfWeek] nvarchar(4000),
    [Weekend] nvarchar(4000)
)
GO

INSERT INTO dbo.DimDate (DateKey, [Date], [Year], [Quarter], [Month], [Day], [DayOfWeek], [Weekend])
SELECT DISTINCT
    TO_CHAR(payment_date :: DATE, 'yyyyMMdd')::integer AS DateKey,
    TO_CHAR(payment_date :: DATE, 'yyyy-MM-dd') AS [Date],
    EXTRACT(year FROM payment_date) AS [Year],
    EXTRACT(quarter FROM payment_date) AS [Quarter],
    EXTRACT(month FROM payment_date) AS [Month],
    EXTRACT(day FROM payment_date) AS [Day],
    TO_CHAR(payment_date, 'D') AS [DayOfWeek],
    CASE WHEN TO_CHAR(payment_date, 'D') IN ('6', '7') THEN 'true' ELSE 'false' END AS [Weekend]
FROM dbo.StagingPayment;
