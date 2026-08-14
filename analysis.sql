SELECT
    MIN(InvoiceDate) AS first_transaction,
    MAX(InvoiceDate) AS last_transaction,
    SUM(Revenue) AS total_revenue
FROM online_retail
WHERE IsCancelled = 0;