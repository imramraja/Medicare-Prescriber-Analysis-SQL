# Healthcare Analytics: Medicare Part D Prescriber Analysis (SQL Server)

[![SQL Server](https://img.shields.io/badge/SQL%20Server-2019+-CC2927?logo=microsoft-sql-server&logoColor=white)](https://www.microsoft.com/en-us/sql-server)
[![ETL](https://img.shields.io/badge/ETL-SSIS-FF6C37?logo=sqlite&logoColor=white)]()

## 📋 Project Overview
An end-to-end healthcare analytics solution that transforms public Medicare Part D prescriber data into actionable insights for pharmaceutical strategy optimization. This project focuses entirely on **database engineering, automated ETL, and advanced SQL analytics**—mirroring industry practices at healthcare analytics firms.

The primary goal is to analyze prescriber behavior, drug utilization, and cost efficiency using only SQL Server tools (T-SQL, SSIS, SQL Agent) to identify opportunities for cost savings and improved patient adherence.

## 🗃️ Dataset Source
**Medicare Part D Prescribers by Provider and Drug** (Public CMS Dataset)
*   **Scope:** National-level data on prescriptions written by providers and paid for under the Medicare Part D Prescription Drug Program.
*   **Key Fields:** Prescriber details, drug brand/generic names, total claim count, days supplied, total drug costs.

## 🛠️ Technology Stack
*   **Database:** SQL Server 2019+
*   **ETL & Automation:** SQL Server Integration Services (SSIS), SQL Server Agent
*   **Version Control:** Git

## 🏗️ Solution Architecture & Components
The project is structured for production-level robustness, automation, and analytical depth.

### SQL Server Database Layer
A comprehensive SQL implementation ensuring data integrity, performance, and reusability.
*   **Data Definition:** `create_database.sql`, `create_tables.sql` for setting up the relational schema.
*   **ETL & Automation:**
    *   `stored_procedures/preprocess_data.sql`: Cleans and transforms raw CSV data.
    *   `stored_procedures/refresh_job.sql`: Production-ready scheduled refresh using SQL Server Agent.
    *   `scripts/setup_database.ps1`: PowerShell script for one-click environment setup.
*   **Business Logic & Analytics:**
    *   **Functions:** `calculate_efficiency.sql`, `calculate_fillrate.sql` for core healthcare metrics.
    *   **Views:** `powerbi_analysis.sql`, `senior_care_analysis.sql` create optimized datasets for reporting (can be consumed by any BI tool).
    *   **Business Questions:** `business_questions/analysis_queries.sql` contains **25+ analytical queries** solving real-world problems (e.g., top prescribers by cost, generic vs. brand utilization trends).
*   **Data Integrity & Performance:**
    *   `triggers/data_validation.sql`: Enforces data quality rules during insert/update.
    *   `indexes/performance_indexes.sql`: Optimizes query performance for large datasets.

## 📈 Key Healthcare Metrics Defined
*   **Cost per Day:** Calculated as `(Total Drug Cost) / (Total Days Supply)`. A key measure of therapy efficiency.
*   **30-Day Fill Rate:** An indicator of medication adherence, calculated as the proportion of prescriptions with a days supply of 30.
*   **Senior Cost %:** `(Cost for beneficiaries aged 65+) / (Total Cost)`. Crucial for understanding Medicare utilization.
*   **Therapy Consistency:** Evaluating prescribing pattern variations for the same drug class across providers.

## 💡 Business Value & Outcomes
This analysis enables stakeholders to:
*   **Identify Cost-Saving Opportunities:** Pinpoint high-cost prescribers or regions for targeted interventions.
*   **Optimize Prescriber Performance:** Understand which provider segments are most efficient and why.
*   **Analyze Senior Care Utilization:** Gauge the impact of the Medicare population on drug spending.
*   **Forecast Drug Expenditure:** Build data-driven forecasts for budgeting and planning.
*   **Improve Medication Adherence:** Identify patient groups or drugs with low fill rates to design adherence programs.

## ⚙️ Getting Started
1.  **Clone the repository:** `git clone https://github.com/imramraja/Medicare-Prescriber-Analysis-SQL.git`
2.  **Run Database Setup:** Execute `scripts/setup_database.ps1` (PowerShell) or manually run scripts in `/sql` in this order:
    *   `create_database.sql`
    *   `create_tables.sql`
    *   `/indexes/performance_indexes.sql`
3.  **Import Data:** Use SQL Server Management Studio (SSMS) to import the Medicare CSV data into the created tables.
4.  **Run Preprocessing:** Execute the stored procedure `stored_procedures/preprocess_data.sql` to clean and prepare the data.
5.  **Run Analysis:** Execute the queries in `business_questions/analysis_queries.sql` to generate insights.

## 🔄 Maintenance
*   **Automated Refresh:** Configured via SQL Server Agent using `stored_procedures/refresh_job.sql`.
*   **Monitoring:** Regularly check job history and data quality validation reports.
*   **Version Control:** All schema and script changes are tracked in this repository.


## 🏆 Core Competencies Demonstrated
*   **Healthcare Analytics:** Applying domain-specific metrics and questions to real CMS data.
*   **Advanced SQL:** Stored procedures, functions, window queries, CTEs, query optimization.
*   **Database Engineering:** Full schema design with triggers, indexes, and ETL processes.
*   **Data Automation:** Building production-ready pipelines with SSIS and SQL Agent.

## 📬 Contact
**Ramraja Yadav**  
📧 yadavramraja@outlook.com  
👔 [LinkedIn Profile](https://www.linkedin.com/in/iamramraja/)  
👨‍💻 [GitHub Portfolio](https://github.com/imramraja)
