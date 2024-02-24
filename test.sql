CREATE EXTERNAL TABLE dbo.factpayment (
    payment_id INT,
    date_key DATE,
    rider_id INT,
    amount_payment DECIMAL(10, 2)
)
WITH (
    LOCATION     = 'factpayment',
    DATA_SOURCE = [udacitydemo2hqxb_udacitydemo2hqxb_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
);

-- SELECT statement for factpayment
INSERT INTO dbo.factpayment (payment_id, date_key, amount_payment, rider_id)
SELECT 
    sp.payment_id AS payment_id, 
    sp.date AS date_key, 
    sp.amount AS amount_payment, 
    sp.rider_id AS rider_id
FROM 
    dbo.StagingPayment sp;

-- SELECT statement for StagingRider
SELECT 
    sr.rider_id, 
    sr.first, 
    sr.last, 
    sr.address, 
    sr.birthday, 
    sr.account_start_date, 
    sr.account_end_date, 
    sr.is_member
FROM 
    dbo.StagingRider sr;
