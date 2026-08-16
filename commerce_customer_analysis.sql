-- COMMERCE CUSTOMER & REVENUE INTELLIGENCE
-- Master SQL Analysis File | MySQL 8.0+
-- Database: commerce_intelligence | Table: online_retail

USE commerce_intelligence;

-- ============================================================
-- 01. DATA VALIDATION
-- ============================================================
-- Query 01
SELECT DATABASE() AS current_database;

-- Query 02
DESCRIBE online_retail;

-- Query 03
SELECT COUNT(*) AS total_rows FROM online_retail;

-- Query 04
SELECT MIN(InvoiceDate) AS first_transaction, MAX(InvoiceDate) AS last_transaction
FROM online_retail;

-- Query 05
SELECT IsCancelled, COUNT(*) AS transaction_count
FROM online_retail
GROUP BY IsCancelled
ORDER BY IsCancelled;

-- ============================================================
-- 02. REVENUE ANALYSIS
-- ============================================================
-- Query 06: Total revenue
SELECT ROUND(SUM(Revenue),2) AS total_revenue
FROM online_retail WHERE IsCancelled = 0;

-- Query 07: Revenue by year
SELECT YEAR(InvoiceDate) AS sales_year, ROUND(SUM(Revenue),2) AS total_revenue
FROM online_retail WHERE IsCancelled = 0
GROUP BY YEAR(InvoiceDate) ORDER BY sales_year;

-- Query 08: Monthly revenue
SELECT YearMonth, ROUND(SUM(Revenue),2) AS monthly_revenue
FROM online_retail WHERE IsCancelled = 0
GROUP BY YearMonth ORDER BY YearMonth;

-- Query 09: Orders, revenue and AOV
SELECT COUNT(DISTINCT InvoiceNo) AS total_orders,
       ROUND(SUM(Revenue),2) AS total_revenue,
       ROUND(SUM(Revenue)/NULLIF(COUNT(DISTINCT InvoiceNo),0),2) AS average_order_value
FROM online_retail WHERE IsCancelled = 0;

-- Query 10: Revenue by country
SELECT Country, ROUND(SUM(Revenue),2) AS total_revenue,
       COUNT(DISTINCT InvoiceNo) AS total_orders
FROM online_retail WHERE IsCancelled = 0
GROUP BY Country ORDER BY total_revenue DESC;

-- Query 11: Top customers by revenue
SELECT CustomerID, ROUND(SUM(Revenue),2) AS total_revenue,
       COUNT(DISTINCT InvoiceNo) AS total_orders
FROM online_retail WHERE IsCancelled = 0 AND CustomerID IS NOT NULL
GROUP BY CustomerID ORDER BY total_revenue DESC LIMIT 10;

-- ============================================================
-- 03. PRODUCT ANALYSIS
-- ============================================================
-- Query 12
SELECT StockCode, Description, ROUND(SUM(Revenue),2) AS total_revenue
FROM online_retail WHERE IsCancelled = 0
GROUP BY StockCode, Description ORDER BY total_revenue DESC LIMIT 10;

-- Query 13
SELECT StockCode, Description, SUM(Quantity) AS total_quantity
FROM online_retail WHERE IsCancelled = 0
GROUP BY StockCode, Description ORDER BY total_quantity DESC LIMIT 10;

-- Query 14
SELECT StockCode, Description, SUM(Quantity) AS total_quantity,
       ROUND(SUM(Revenue),2) AS total_revenue,
       ROUND(SUM(Revenue)/NULLIF(SUM(Quantity),0),2) AS revenue_per_unit
FROM online_retail WHERE IsCancelled = 0
GROUP BY StockCode, Description ORDER BY total_revenue DESC LIMIT 20;

-- Query 15
SELECT StockCode, Description, ROUND(SUM(Revenue),2) AS product_revenue,
       ROUND(100*SUM(Revenue)/(SELECT SUM(Revenue) FROM online_retail WHERE IsCancelled=0),2)
       AS revenue_contribution_pct
FROM online_retail WHERE IsCancelled = 0
GROUP BY StockCode, Description ORDER BY product_revenue DESC LIMIT 20;

-- Query 16
SELECT COUNT(*) AS negative_revenue_transactions, ROUND(SUM(Revenue),2) AS negative_revenue
FROM online_retail WHERE Revenue < 0;

-- ============================================================
-- 04. CUSTOMER ANALYSIS
-- ============================================================
-- Query 17
SELECT CustomerID, ROUND(SUM(Revenue),2) AS total_revenue,
       COUNT(DISTINCT InvoiceNo) AS total_orders, SUM(Quantity) AS total_units,
       ROUND(SUM(Revenue)/NULLIF(COUNT(DISTINCT InvoiceNo),0),2) AS average_order_value
FROM online_retail WHERE IsCancelled=0 AND CustomerID IS NOT NULL
GROUP BY CustomerID ORDER BY total_revenue DESC;

-- Query 18
SELECT CustomerID, MIN(InvoiceDate) AS first_transaction,
       MAX(InvoiceDate) AS last_transaction
FROM online_retail WHERE IsCancelled=0 AND CustomerID IS NOT NULL
GROUP BY CustomerID ORDER BY last_transaction;

-- Query 19
SELECT CustomerID, COUNT(DISTINCT InvoiceNo) AS total_orders,
       ROUND(SUM(Revenue),2) AS total_revenue
FROM online_retail WHERE IsCancelled=0 AND CustomerID IS NOT NULL
GROUP BY CustomerID ORDER BY total_orders DESC LIMIT 10;

-- Query 20
WITH customer_revenue AS (
    SELECT CustomerID, SUM(Revenue) AS total_revenue
    FROM online_retail WHERE IsCancelled=0 AND CustomerID IS NOT NULL
    GROUP BY CustomerID
), ranked_customers AS (
    SELECT CustomerID, total_revenue,
           NTILE(10) OVER (ORDER BY total_revenue DESC) AS decile
    FROM customer_revenue
)
SELECT decile, COUNT(*) AS customers, ROUND(SUM(total_revenue),2) AS revenue
FROM ranked_customers GROUP BY decile ORDER BY decile;

-- ============================================================
-- 05. RFM ANALYSIS
-- ============================================================
-- Query 21: RFM base
WITH reference_date AS (
    SELECT MAX(InvoiceDate) AS analysis_date FROM online_retail WHERE IsCancelled=0
), customer_rfm AS (
    SELECT CustomerID,
           DATEDIFF((SELECT analysis_date FROM reference_date),MAX(InvoiceDate)) AS Recency,
           COUNT(DISTINCT InvoiceNo) AS Frequency, SUM(Revenue) AS Monetary
    FROM online_retail WHERE IsCancelled=0 AND CustomerID IS NOT NULL
    GROUP BY CustomerID
)
SELECT CustomerID, Recency, Frequency, ROUND(Monetary,2) AS Monetary
FROM customer_rfm ORDER BY Monetary DESC;

-- Query 22: RFM scores
WITH customer_rfm AS (
    SELECT CustomerID,
           DATEDIFF((SELECT MAX(InvoiceDate) FROM online_retail WHERE IsCancelled=0),MAX(InvoiceDate)) AS Recency,
           COUNT(DISTINCT InvoiceNo) AS Frequency, SUM(Revenue) AS Monetary
    FROM online_retail WHERE IsCancelled=0 AND CustomerID IS NOT NULL
    GROUP BY CustomerID
), rfm_scores AS (
    SELECT *, NTILE(5) OVER (ORDER BY Recency DESC) AS R_Score,
              NTILE(5) OVER (ORDER BY Frequency) AS F_Score,
              NTILE(5) OVER (ORDER BY Monetary) AS M_Score
    FROM customer_rfm
)
SELECT CustomerID, Recency, Frequency, ROUND(Monetary,2) AS Monetary,
       R_Score,F_Score,M_Score,CONCAT(R_Score,F_Score,M_Score) AS RFM_Score
FROM rfm_scores ORDER BY Monetary DESC;

-- Query 23: RFM segments
WITH customer_rfm AS (
    SELECT CustomerID,
           DATEDIFF((SELECT MAX(InvoiceDate) FROM online_retail WHERE IsCancelled=0),MAX(InvoiceDate)) AS Recency,
           COUNT(DISTINCT InvoiceNo) AS Frequency, SUM(Revenue) AS Monetary
    FROM online_retail WHERE IsCancelled=0 AND CustomerID IS NOT NULL
    GROUP BY CustomerID
), rfm_scores AS (
    SELECT *, NTILE(5) OVER (ORDER BY Recency DESC) AS R_Score,
              NTILE(5) OVER (ORDER BY Frequency) AS F_Score,
              NTILE(5) OVER (ORDER BY Monetary) AS M_Score
    FROM customer_rfm
)
SELECT CustomerID, Recency, Frequency, ROUND(Monetary,2) AS Monetary,
       CASE WHEN R_Score>=4 AND F_Score>=4 AND M_Score>=4 THEN 'Champions'
            WHEN R_Score>=3 AND F_Score>=4 THEN 'Loyal Customers'
            WHEN R_Score<=2 AND F_Score>=3 AND M_Score>=3 THEN 'At Risk'
            WHEN R_Score>=4 AND F_Score<=2 THEN 'New Customers'
            ELSE 'Regular Customers' END AS Customer_Segment
FROM rfm_scores;

-- Query 24: RFM segment summary
WITH customer_rfm AS (
    SELECT CustomerID,
           DATEDIFF((SELECT MAX(InvoiceDate) FROM online_retail WHERE IsCancelled=0),MAX(InvoiceDate)) AS Recency,
           COUNT(DISTINCT InvoiceNo) AS Frequency, SUM(Revenue) AS Monetary
    FROM online_retail WHERE IsCancelled=0 AND CustomerID IS NOT NULL
    GROUP BY CustomerID
), rfm_scores AS (
    SELECT *, NTILE(5) OVER (ORDER BY Recency DESC) AS R_Score,
              NTILE(5) OVER (ORDER BY Frequency) AS F_Score,
              NTILE(5) OVER (ORDER BY Monetary) AS M_Score
    FROM customer_rfm
), segmented AS (
    SELECT *, CASE WHEN R_Score>=4 AND F_Score>=4 AND M_Score>=4 THEN 'Champions'
                   WHEN R_Score>=3 AND F_Score>=4 THEN 'Loyal Customers'
                   WHEN R_Score<=2 AND F_Score>=3 AND M_Score>=3 THEN 'At Risk'
                   WHEN R_Score>=4 AND F_Score<=2 THEN 'New Customers'
                   ELSE 'Regular Customers' END AS Customer_Segment
    FROM rfm_scores
)
SELECT Customer_Segment, COUNT(*) AS customers,
       ROUND(SUM(Monetary),2) AS revenue, ROUND(AVG(Monetary),2) AS avg_customer_revenue
FROM segmented GROUP BY Customer_Segment ORDER BY revenue DESC;

-- ============================================================
-- 06. CHURN ANALYSIS
-- Churn definition: more than 90 days since last purchase
-- ============================================================
-- Query 25
WITH customer_last_purchase AS (
    SELECT CustomerID, MAX(InvoiceDate) AS last_purchase
    FROM online_retail WHERE IsCancelled=0 AND CustomerID IS NOT NULL
    GROUP BY CustomerID
)
SELECT CustomerID,last_purchase,
       DATEDIFF((SELECT MAX(InvoiceDate) FROM online_retail WHERE IsCancelled=0),last_purchase) AS days_since_last_purchase,
       CASE WHEN DATEDIFF((SELECT MAX(InvoiceDate) FROM online_retail WHERE IsCancelled=0),last_purchase)>90
            THEN 'Churned' ELSE 'Active' END AS churn_status
FROM customer_last_purchase;

-- Query 26
WITH customer_status AS (
    SELECT CustomerID,
           DATEDIFF((SELECT MAX(InvoiceDate) FROM online_retail WHERE IsCancelled=0),MAX(InvoiceDate)) AS days_since_last_purchase
    FROM online_retail WHERE IsCancelled=0 AND CustomerID IS NOT NULL
    GROUP BY CustomerID
)
SELECT CASE WHEN days_since_last_purchase>90 THEN 'Churned' ELSE 'Active' END AS churn_status,
       COUNT(*) AS customers
FROM customer_status GROUP BY churn_status;

-- Query 27
WITH customer_status AS (
    SELECT CustomerID,
           DATEDIFF((SELECT MAX(InvoiceDate) FROM online_retail WHERE IsCancelled=0),MAX(InvoiceDate)) AS days_since_last_purchase
    FROM online_retail WHERE IsCancelled=0 AND CustomerID IS NOT NULL
    GROUP BY CustomerID
)
SELECT COUNT(*) AS total_customers,
       SUM(days_since_last_purchase>90) AS churned_customers,
       ROUND(100*SUM(days_since_last_purchase>90)/COUNT(*),2) AS churn_rate_pct
FROM customer_status;

-- Query 28
WITH customer_summary AS (
    SELECT CustomerID,MAX(InvoiceDate) AS last_purchase,SUM(Revenue) AS total_revenue
    FROM online_retail WHERE IsCancelled=0 AND CustomerID IS NOT NULL
    GROUP BY CustomerID
)
SELECT COUNT(*) AS churned_customers,ROUND(SUM(total_revenue),2) AS churned_customer_revenue
FROM customer_summary
WHERE DATEDIFF((SELECT MAX(InvoiceDate) FROM online_retail WHERE IsCancelled=0),last_purchase)>90;

-- Query 29
WITH customer_summary AS (
    SELECT CustomerID,MAX(InvoiceDate) AS last_purchase,
           SUM(Revenue) AS total_revenue,COUNT(DISTINCT InvoiceNo) AS total_orders
    FROM online_retail WHERE IsCancelled=0 AND CustomerID IS NOT NULL
    GROUP BY CustomerID
)
SELECT CustomerID,last_purchase,total_orders,ROUND(total_revenue,2) AS total_revenue
FROM customer_summary
WHERE DATEDIFF((SELECT MAX(InvoiceDate) FROM online_retail WHERE IsCancelled=0),last_purchase)>90
ORDER BY total_revenue DESC LIMIT 20;

-- Query 30
WITH customer_summary AS (
    SELECT CustomerID,MAX(InvoiceDate) AS last_purchase,SUM(Revenue) AS total_revenue
    FROM online_retail WHERE IsCancelled=0 AND CustomerID IS NOT NULL
    GROUP BY CustomerID
), churn_summary AS (
    SELECT SUM(CASE WHEN DATEDIFF((SELECT MAX(InvoiceDate) FROM online_retail WHERE IsCancelled=0),last_purchase)>90
                    THEN total_revenue ELSE 0 END) AS churned_revenue,
           SUM(total_revenue) AS total_revenue
    FROM customer_summary
)
SELECT ROUND(churned_revenue,2) AS churned_revenue,ROUND(total_revenue,2) AS total_revenue,
       ROUND(100*churned_revenue/NULLIF(total_revenue,0),2) AS revenue_exposure_pct
FROM churn_summary;

-- ============================================================
-- 07. BUSINESS INSIGHTS
-- ============================================================
-- Query 31: High-value customer concentration
WITH customer_revenue AS (
    SELECT CustomerID,SUM(Revenue) AS total_revenue
    FROM online_retail WHERE IsCancelled=0 AND CustomerID IS NOT NULL
    GROUP BY CustomerID
), ranked AS (
    SELECT *,NTILE(5) OVER (ORDER BY total_revenue DESC) AS value_group
    FROM customer_revenue
)
SELECT COUNT(*) AS high_value_customers,ROUND(SUM(total_revenue),2) AS high_value_revenue,
       ROUND(100*COUNT(*)/(SELECT COUNT(*) FROM customer_revenue),2) AS customer_share_pct,
       ROUND(100*SUM(total_revenue)/(SELECT SUM(total_revenue) FROM customer_revenue),2) AS revenue_share_pct
FROM ranked WHERE value_group=1;

-- Query 32
SELECT Country,ROUND(SUM(Revenue),2) AS revenue,
       ROUND(100*SUM(Revenue)/(SELECT SUM(Revenue) FROM online_retail WHERE IsCancelled=0),2) AS revenue_share_pct
FROM online_retail WHERE IsCancelled=0
GROUP BY Country ORDER BY revenue DESC LIMIT 10;

-- Query 33: Month-over-month growth
WITH monthly_revenue AS (
    SELECT YearMonth,SUM(Revenue) AS revenue
    FROM online_retail WHERE IsCancelled=0 GROUP BY YearMonth
)
SELECT YearMonth,ROUND(revenue,2) AS revenue,
       ROUND(100*(revenue-LAG(revenue) OVER (ORDER BY YearMonth))/NULLIF(LAG(revenue) OVER (ORDER BY YearMonth),0),2) AS month_over_month_growth_pct
FROM monthly_revenue ORDER BY YearMonth;

-- Query 34
SELECT StockCode,Description,ROUND(SUM(Revenue),2) AS revenue,SUM(Quantity) AS units_sold
FROM online_retail WHERE IsCancelled=0
GROUP BY StockCode,Description ORDER BY revenue DESC LIMIT 20;

-- Query 35
SELECT CustomerID,COUNT(DISTINCT InvoiceNo) AS total_orders,
       ROUND(SUM(Revenue),2) AS total_revenue,
       ROUND(SUM(Revenue)/NULLIF(COUNT(DISTINCT InvoiceNo),0),2) AS average_order_value
FROM online_retail WHERE IsCancelled=0 AND CustomerID IS NOT NULL
GROUP BY CustomerID HAVING total_orders<=3
ORDER BY total_revenue DESC LIMIT 20;

-- ============================================================
-- 08. RECOMMENDATION SUPPORT
-- ============================================================
-- Query 36
WITH customer_summary AS (
    SELECT CustomerID,MAX(InvoiceDate) AS last_purchase,
           COUNT(DISTINCT InvoiceNo) AS total_orders,SUM(Revenue) AS total_revenue
    FROM online_retail WHERE IsCancelled=0 AND CustomerID IS NOT NULL
    GROUP BY CustomerID
)
SELECT CustomerID,last_purchase,total_orders,ROUND(total_revenue,2) AS total_revenue,
       DATEDIFF((SELECT MAX(InvoiceDate) FROM online_retail WHERE IsCancelled=0),last_purchase) AS days_inactive
FROM customer_summary
WHERE DATEDIFF((SELECT MAX(InvoiceDate) FROM online_retail WHERE IsCancelled=0),last_purchase)>60
ORDER BY total_revenue DESC;

-- Query 37
WITH customer_summary AS (
    SELECT CustomerID,MAX(InvoiceDate) AS last_purchase,
           COUNT(DISTINCT InvoiceNo) AS total_orders,SUM(Revenue) AS total_revenue
    FROM online_retail WHERE IsCancelled=0 AND CustomerID IS NOT NULL
    GROUP BY CustomerID
)
SELECT CustomerID,total_orders,ROUND(total_revenue,2) AS total_revenue,
       DATEDIFF((SELECT MAX(InvoiceDate) FROM online_retail WHERE IsCancelled=0),last_purchase) AS days_since_last_purchase
FROM customer_summary
WHERE DATEDIFF((SELECT MAX(InvoiceDate) FROM online_retail WHERE IsCancelled=0),last_purchase) BETWEEN 60 AND 180
ORDER BY total_revenue DESC LIMIT 50;

-- Query 38: Executive KPI summary
WITH customer_summary AS (
    SELECT CustomerID,MAX(InvoiceDate) AS last_purchase,SUM(Revenue) AS total_revenue
    FROM online_retail WHERE IsCancelled=0 AND CustomerID IS NOT NULL
    GROUP BY CustomerID
)
SELECT
    (SELECT COUNT(*) FROM online_retail) AS total_transactions,
    (SELECT COUNT(DISTINCT CustomerID) FROM online_retail WHERE IsCancelled=0 AND CustomerID IS NOT NULL) AS total_customers,
    (SELECT COUNT(DISTINCT InvoiceNo) FROM online_retail WHERE IsCancelled=0) AS total_orders,
    ROUND((SELECT SUM(Revenue) FROM online_retail WHERE IsCancelled=0),2) AS total_revenue,
    (SELECT COUNT(*) FROM customer_summary
     WHERE DATEDIFF((SELECT MAX(InvoiceDate) FROM online_retail WHERE IsCancelled=0),last_purchase)>90) AS churned_customers;

-- ============================================================
-- END OF MASTER SQL ANALYSIS
-- ============================================================
