## Commerce Customer & Revenue Intelligence

An end-to-end retail analytics project combining Python, SQL, Julius AI, and Power BI to analyze customer behavior, revenue performance, product performance, RFM segments, and customer churn.

## Project Description

This project transforms cleaned online retail transaction data into actionable business intelligence.

## Tools and Purpose

Python / Google Colab — data cleaning, exploratory data analysis, transformation, and analytical preparation

Julius AI — AI-assisted data exploration, pattern discovery, and business-oriented interpretation

MySQL — structured data storage, validation, and SQL business analysis

Power BI — interactive dashboards and decision-focused visualization

## Business Objectives

Measure overall revenue and sales performance

Identify top-performing products and countries

Understand customer purchasing behavior

Identify high-value customers

Segment customers using RFM analysis

Detect customers at risk of churn

Quantify churn and revenue exposure

Convert analytical findings into business recommendations

Present findings through interactive Power BI dashboards

## Project Workflow
Raw Retail Dataset
        ↓
Python / Google Colab
        ↓
Data Cleaning + EDA + Transformation
        ↓
Julius AI
        ↓
AI-Assisted Pattern Discovery
        ↓
MySQL
        ↓
SQL Business Analysis
        ↓
Revenue Analysis
        ↓
Product Analysis
        ↓
Customer Analysis
        ↓
RFM Analysis
        ↓
Churn Analysis
        ↓
Business Insights
        ↓
Recommendations
        ↓
Power BI Dashboard

## Key Analysis Areas

Revenue Analysis

Total revenue

Revenue by year

Monthly revenue trends

Average order value

Revenue by country

Top revenue-generating customers

## Product Analysis

Top products by revenue

Top products by quantity sold

Revenue per unit

Product-level revenue contribution

Negative-revenue transactions

## Customer Analysis

Customer-level metrics include:

Total revenue

Total orders

Total units purchased

Average order value

First purchase date

Last purchase date

## RFM Analysis

Customers are evaluated using:

Recency — how recently the customer purchased

Frequency — how often the customer purchased

Monetary — how much revenue the customer generated

## Customer segments include:

Champions

Loyal Customers

At Risk

New Customers

Regular Customers

Churn Analysis

For this project, a customer is classified as Churned when more than 90 days have passed since their last purchase.


## Dashboard Screenshots

### Executive Overview

![Executive Overview](<img width="1122" height="641" alt="Screenshot 2026-08-17 011647" src="https://github.com/user-attachments/assets/f985d5a7-7987-48a6-b340-b5c903365d46" />
)

### Product Analysis

![Product Analysis](<img width="1122" height="621" alt="Screenshot 2026-08-17 011857" src="https://github.com/user-attachments/assets/a602a0df-86ae-49ea-bb02-a5a6f1709b50" />
)

### Customer Analysis

![Customer Analysis](<img width="1140" height="647" alt="image" src="https://github.com/user-attachments/assets/7cb8a7a2-398a-4434-be5c-7bf059e90482" />
)

### Customer Churn Analysis

![Customer Churn Analysis](<img width="1110" height="628" alt="image" src="https://github.com/user-attachments/assets/100e43ab-0b0f-4cde-baa1-29c72cf6cccd" />
)

### RFM Analysis

![RFM Analysis](<img width="1135" height="640" alt="image" src="https://github.com/user-attachments/assets/e12f6b72-6823-4fcc-91c7-7dc3412ac5b3" />
)

---

## Power BI Development Preview

The following screenshots show the dashboards directly inside Power BI Desktop, providing a view of the actual dashboard development environment.

### Executive Overview — Development View

![Executive Overview Development](<img width="1915" height="961" alt="image" src="https://github.com/user-attachments/assets/7fb6ce32-000c-4b6a-86bf-37dc84a9f0d7" />
)

### Product Analysis — Development View

![Product Analysis Development](<img width="1919" height="981" alt="image" src="https://github.com/user-attachments/assets/0a0714a4-73f7-464e-8d2b-26caa40e4bdf" />
)

### Customer Analysis — Development View

![Customer Analysis Development](<img width="1140" height="650" alt="image" src="https://github.com/user-attachments/assets/a28f0478-a473-42d7-a970-c3604e76acba" />
)

### Customer Churn Analysis — Development View

![Customer Churn Development](<img width="1919" height="964" alt="image" src="https://github.com/user-attachments/assets/80a4191b-451b-4321-a658-2dd6e19fe285" />
)

### RFM Analysis — Development View

![RFM Analysis Development](<img width="1914" height="965" alt="image" src="https://github.com/user-attachments/assets/7daf9921-760f-48ec-9ad0-6da7272bfb61" />
)



# The analysis includes:

Active vs. churned customers

Churn rate

Churned customer revenue

High-value churned customers

Revenue exposure from churned customers

Dataset

The cleaned dataset contains 392,692 transaction records and includes:

InvoiceNo
StockCode
Description
Quantity
InvoiceDate
UnitPrice
CustomerID
Country
IsCancelled
Revenue
YearMonth

# Technology Stack

Technology        ------                 Purpose

Python             ------             Data cleaning, EDA, transformation

Google Colab     ------               Python analysis environment

Julius AI        ------               AI-assisted analysis and pattern discovery

MySQL              ------             Data storage and SQL analysis

SQL           ------                  Business queries and customer/revenue analysis

Power BI         -------               Interactive dashboards and visualization

GitHub        -------                  Version control and portfolio presentation


# Portfolio Summary

Commerce Customer & Revenue Intelligence demonstrates an end-to-end analytics workflow from raw transaction data to business decision-making using Python, Julius AI, SQL, and Power BI.

The project showcases data preparation, exploratory analysis, customer segmentation, RFM analysis, churn analysis, AI-assisted pattern discovery, SQL business intelligence, and interactive dashboard development.

## Conclusion

This project demonstrates an end-to-end analytics workflow, from SQL-based data analysis and transformation to interactive Power BI dashboard development.

The final dashboard provides actionable insights into sales, products, customers, and customer retention.


**One important thing:** don't claim anything in the README that isn't actually in your dashboard. Keep the description aligned with what you built.

---

# 3. Prepare your interview explanation

Don't explain the project by saying:

> "I made some charts in Power BI."

Instead, explain it as an **end-to-end analytics project**.

### 30-second version

> "I worked on an e-commerce sales analytics project using SQL and Power BI. I first cleaned and analyzed the retail transaction data using SQL, where I investigated revenue, orders, products, customers, and purchasing behavior. Then I built an interactive Power BI dashboard with four sections: Executive Overview, Product Analysis, Customer Analysis, and Customer Churn Analysis. For churn, I used a 90-day inactivity definition to identify active and churned customers. The dashboard allows users to analyze revenue, product performance, customer behavior, and retention through KPIs, charts, tables, and slicers."

### If interviewer asks: "Why did you use SQL?"

Say:

> "I used SQL for data exploration, cleaning, aggregation, and business analysis before bringing the data into Power BI. It allowed me to validate the underlying data and calculate important business metrics."

### "Why Power BI?"

> "I used Power BI to convert the SQL analysis into an interactive dashboard. It makes the results easier for business users to explore using KPIs, visualizations, filters, and slicers."

### "How did you define churn?"

This one is important:

> "I defined a customer as churned when they had not made a purchase for more than 90 days from the latest purchase date in the dataset."

### "What did you learn from the project?"

> "The project helped me understand the complete analytics workflow—from data cleaning and SQL analysis to DAX measures, dashboard design, and translating analytical results into business insights."

