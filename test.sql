CREATE EXTERNAL TABLE dbo.factpayment (
    payment_id INT,
    date_key DATE,
    rider_id INT,
    amount_payment DECIMAL(10, 2)
    start_
)
WITH (
    LOCATION     = 'factpayment',
    DATA_SOURCE = [udacitydemo2hqxb_udacitydemo2hqxb_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
);

-- AS
-- SELECT sr.[rider_id] AS rider_id, sr.[first] AS first, sr.[last] AS last, sr.[birthday] AS birthday, sr.[is_member] AS member, sr.[account_start_date] AS start_date, sr.[account_end_date] AS end_date, sr.[address] AS address
-- FROM [dbo].[StagingRider]sr ;
-- GO

As 
SELECT sp.[payment_id] AS payment_id, sp.[date] as date_key, sp.[amount]amount_payment, sp.[rider_id]
FROM [dbo].[StagingPayment]sp;


SELECT sr.[rider_id], sr.[first], sr.[last], sr.[address], sr.[birthday], sr.[account_start_date], sr.[account_end_date], sr.[is_member]
FROM [dbo].[StagingRider]sr;
