# Canadian Rental Market Operations - Data Pipeline

## 📊 Live Dashboard
(https://datastudio.google.com/s/tb7r2sa9dik)

## 🎯 Business Problem
Real estate management companies need visibility into regional pricing, inventory distribution, and square-footage profitability to optimize their portfolios. This project ingests, cleans, and analyzes over 25,000 records from the Canadian rental market to deliver actionable financial insights.

## 🛠️ Technology Stack
* **Python (Pandas):** Handled Data Extraction, Transformation, and Loading (ETL). Executed null imputations using statistical medians and regex pattern matching for text standardization.
* **Google Cloud Platform (BigQuery):** Provisioned a cloud data warehouse for secure, scalable data storage.
* **SQL:** Authored advanced queries utilizing Common Table Expressions (CTEs), SAFE_CAST data type conversions, and CASE WHEN logical segmentations.
* **Looker Studio:** Designed an interactive executive dashboard for non-technical stakeholders to track regional KPIs and average rental costs (CAD).
