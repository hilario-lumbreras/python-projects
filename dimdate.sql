IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
	CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
	WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
	       FORMAT_OPTIONS (
			 FIELD_TERMINATOR = ',',
			 USE_TYPE_DEFAULT = FALSE
			))
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'udacitydemo2hqxb_udacitydemo2hqxb_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [udacitydemo2hqxb_udacitydemo2hqxb_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://udacitydemo2hqxb@udacitydemo2hqxb.dfs.core.windows.net' 
	)
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



INSERT INTO dimDate (date_key, date, year, quarter, month, day, week, is_weekend)
SELECT DISTINCT(TO_CHAR(payment_date :: DATE, 'yyyyMMDD')::integer) AS date_key,
       date(payment_date)                                           AS date,
       EXTRACT(year FROM payment_date)                              AS year,
       EXTRACT(quarter FROM payment_date)                           AS quarter,
       EXTRACT(month FROM payment_date)                             AS month,
       EXTRACT(day FROM payment_date)                               AS day,
       EXTRACT(week FROM payment_date)                              AS week,
       CASE WHEN EXTRACT(ISODOW FROM payment_date) IN (6, 7) THEN true ELSE false END AS is_weekend
FROM dbo.StagingPayment (
	[payment_id] bigint,
	[date] datetime2(0),
	[amount] float,
	[rider_id] bigint
	)
