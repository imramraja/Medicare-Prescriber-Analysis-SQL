# Healthcare Analytics: Medicare Part D Prescriber Analysis

## Project Overview
End-to-end healthcare analytics solution that transforms Medicare Part D prescriber data into actionable insights for pharmaceutical strategy optimization. Features automated data processing, advanced analytics, and focused visualizations mirroring industry practices at healthcare analytics firms.

## Dataset Source
[Medicare Part D Prescribers by Provider and Drug](https://data.cms.gov/medicare-part-d-prescribers)  
(CMS Public Dataset)

## Tech Stack
- **Database**: SQL Server 2019+
- **BI Visualization**: Power BI
- **ETL**: SQL Server Integration Services
- **Automation**: SQL Server Agent
- **Version Control**: Git

## Solution Components
### SQL Server Implementation
- Automated data preprocessing pipeline
- Healthcare-specific metric calculations
- Data quality enforcement
- Production-ready refresh scheduling
- 25+ analytical business questions

### Power BI Dashboard (2 Focused Pages)
**1. Prescriber Performance Analysis**  
- Cost efficiency metrics and matrices
- Geographical cost heatmaps
- Outlier detection tables
- Provider segmentation analysis

**2. Drug Utilization & Senior Care**  
- Brand vs generic market analysis
- Senior care cost distribution
- Therapy adherence metrics
- Drug cost forecasting models

## Getting Started
1. Clone repository
2. Run database setup scripts
3. Import Medicare CSV data using SSMS
4. Execute preprocessing procedure
5. Connect Power BI to optimized views
6. Refresh data model and explore reports 

## Key Healthcare Metrics
- **Cost per Day**: Therapy efficiency measurement
- **30-Day Fill Rate**: Medication adherence indicator
- **Senior Cost %**: Medicare utilization analysis
- **Therapy Consistency**: Prescribing pattern evaluation

## Business Value
- Identify cost-saving opportunities
- Optimize prescriber performance
- Analyze senior care utilization
- Forecast drug expenditure
- Improve medication adherence

## Maintenance
- Weekly automated data refresh
- Performance monitoring
- Data quality validation
- Version-controlled updates

## Project Structure
Healthcare-Analytics/<br>
├── sql/<br>
│   ├── create_database.sql<br>
│   ├── create_tables.sql<br>
│   ├── stored_procedures/<br>
│   │   ├── preprocess_data.sql<br>
│   │   ├── refresh_job.sql<br>
│   │   └── quality_check.sql<br>
│   ├── functions/<br>
│   │   ├── calculate_efficiency.sql<br>
│   │   └── calculate_fillrate.sql<br>
│   ├── views/<br>
│   │   ├── powerbi_analysis.sql<br>
│   │   └── senior_care_analysis.sql<br>
│   ├── triggers/<br>
│   │   └── data_validation.sql<br>
│   ├── indexes/<br>
│   │   └── performance_indexes.sql<br>
│   └── business_questions/<br>
│       └── analysis_queries.sql<br>
├── dashboard/<br>
│   └── Medicare_Analytics.pbix<br>
├── docs/<br>
│   └── ERD_Diagram.pdf<br>
├── scripts/<br>
│   └── setup_database.ps1<br>
└── README.md

---
## Core Competencies
**Healthcare Analytics** | **SQL Optimization** | **Power BI** | **ETL Development**  

## Contact Information
**Ramraja Yadav**  
📧 [yadavramraja@outlook.com](mailto:yadavramraja@outlook.com)  
👔 [LinkedIn Profile](https://linkedin.com/in/ramrajayadav)<br>
👨‍💻 [GitHub Portfolio](https://github.com/imramraja/DataAnalyst-Portfolio)
