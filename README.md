# Healthcare Data Analytics Project

## Project Overview
This project focuses on analyzing a comprehensive healthcare database to derive actionable insights. By leveraging advanced SQL techniques, the analysis covers patient demographics, encounter histories, insurance payer performance, medical procedure frequencies, and financial metrics.

## Dataset Details
The database consists of the following primary tables:
- **patients**: Contains patient demographic information.
- **encounters**: Records detailed visit history and timing.
- **procedures**: Tracks medical procedures performed on patients.
- **organizations**: Stores information regarding hospitals and clinics.
- **payers**: Manages insurance provider details.

## Key Analysis Performed
- **Patient Retention**: Identified patients who returned for care after a gap of more than one year.
- **Procedure Popularity**: Analyzed the most frequent medical procedures based on patient demographics.
- **Monthly Trends**: Conducted time-series analysis to track encounter volume per month.
- **Cost Outliers**: Identified high-value encounters exceeding the average total claim cost.
- **Payer Efficiency**: Compared average processing times across different insurance payers.
- **Medical Insights**: Tracked top-frequency medical conditions and procedures.
- **Patient Summary Report**: Utilized Window Functions (`ROW_NUMBER()`) to generate comprehensive patient summaries, including total costs and favorite healthcare organizations.

## Tech Stack
- **Database Management System**: PostgreSQL
- **SQL Editor**: DBeaver
- **Key SQL Skills Applied**: Complex Joins, Aggregation, Subqueries, CTEs (Common Table Expressions), and Window Functions.

## How to Use
1. Set up your database environment with the provided schema.
2. Execute the scripts contained in the `healthcare_data_analysis_queries.sql` file within your SQL editor.
3. Review the generated results in the output console.

## Project Highlights
- Developed scalable queries for large healthcare datasets.
- Optimized performance using Window Functions instead of traditional subqueries where applicable.
- Cleaned and interpreted complex, multi-table relationships to ensure data integrity.

## Author - Suraj Dadwal
Data Analyst Portfolio | Passionate about SQL and Data-driven decision making.
