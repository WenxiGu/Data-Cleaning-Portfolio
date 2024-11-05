Welcome to my Data Cleaning Portfolio! This repository showcases several data cleaning projects that demonstrate my ability to prepare and transform raw datasets for analysis. Each project includes detailed steps, methodologies, and outcomes, along with the scripts used for cleaning and preprocessing.

## Projects Overview
| Project Name                  | Dataset Description                              | Tools Used               | Key Cleaning Steps                                 |
|-------------------------------|--------------------------------------------------|--------------------------|----------------------------------------------------|
| [Project 1: HCAHPS Data Cleaning](https://github.com/WenxiGu/Data-Cleaning-Portfolio/tree/main/HCAHPS_Data_Cleaning) | Hospital Patient Satisfaction Data | SQL, PostgreSQL          | Standardized columns, deduplication, data joining  |
| [Project 2: Fitbit Activity Data Cleaning](https://github.com/WenxiGu/Data-Cleaning-Portfolio/tree/main/Fitbit_Data_Cleaning) | Fitness Device Daily Activity Tracking data       | SQL, BigQuery            | Format standardization, outlier treatment, handling missing values |

Each project folder contains:
- **Data cleaning scripts**: SQL, or other relevant code files.
- **README**: Detailed documentation of the data cleaning process, challenges, and final data structure.

---

## Project Summaries

### 1. HCAHPS Data Cleaning
**Description**: This project involves cleaning and standardizing the Hospital Consumer Assessment of Healthcare Providers and Systems (HCAHPS) data to prepare it for analysis on patient satisfaction trends.

- **Tools**: SQL, PostgreSQL
- **Key Steps**:
  - Standardized columns and dates
  - Removed duplicates
  - Merged tables for enriched analysis
- **[Detailed Project README](link_to_project_1_folder/README.md)**

---

### 2. Fitbit Activity Data Cleaning
**Description**: Cleaning and preparation of Fitbit daily activity data, focusing on standardizing timestamps, addressing missing values, and removing anomalies.

- **Tools**: SQL, BigQuery
- **Key Steps**:
  - Formatted dates and standardized metrics
  - Removed duplicates and handled null values
  - Identified and managed outliers
- **[Detailed Project README](link_to_project_2_folder/README.md)**

## Skills Demonstrated

This portfolio demonstrates my skills in:
- **Data Cleaning and Transformation**: Handling missing data, standardizing formats, and deduplication.
- **Outlier Detection and Treatment**: Identifying and handling outliers based on data distribution.
- **Data Integration**: Merging multiple tables and data sources for comprehensive analysis.
- **SQL Proficiency**: Writing complex SQL queries for data cleaning and manipulation.

## Directory Structure

```plaintext
Data_Cleaning_Portfolio
├── Project_1_HCAHPS
│   ├── README.md
│   ├── data_cleaning_HCAHPS.sql
│   └── data_cleaning_HCAHPS_annotated.sql
├── Project_2_Fitbit_Activity
│   ├── README.md
│   ├── fitbit_daily_activity_data_cleaning.sql
│   ├── fitbit_sleep_data_cleaning.sql
