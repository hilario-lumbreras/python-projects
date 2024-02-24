IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
BEGIN
    CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
    WITH (
        FORMAT_TYPE = DELIMITEDTEXT ,
        FORMAT_OPTIONS = (
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

CREATE EXTERNAL TABLE dbo.dimdate (
    [date_key] INT,
    [date] DATE,
    [year] INT,
    [quarter] INT,
    [month] INT,
    [day] INT,
    [day_of_week] INT,
    [weekend] BIT
)
WITH (
    LOCATION     = 'dimdate',
    DATA_SOURCE = [udacitydemo2hqxb_udacitydemo2hqxb_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)
AS
SELECT 
    CONVERT(INT, CONVERT(VARCHAR(8), date, 112)) AS date_key,
    date AS [date],
    DATEPART(YEAR, date) AS [year],
    DATEPART(QUARTER, date) AS [quarter],
    DATEPART(MONTH, date) AS [month],
    DATEPART(DAY, date) AS [day],
    DATEPART(WEEKDAY, date) AS [day_of_week],
    CASE WHEN DATEPART(WEEKDAY, date) IN (6, 7) THEN 1 ELSE 0 END AS [weekend]
FROM dbo.staging_payment;
