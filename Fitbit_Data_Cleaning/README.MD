# Fitbit Data Cleaning Project

This project focuses on cleaning and preparing daily activity and sleep data from Fitbit for analysis. The SQL scripts perform various transformations to ensure data quality and consistency.

## Data Cleaning Steps

### 1. Daily Activity Data Cleaning
- **File**: `fitbit_daily_activity_data_cleaning.sql`
- **Steps**:
  - Standardize date formats to ensure consistency.
  - Remove duplicates based on unique user and date combinations.
  - Fill missing values in relevant columns (if applicable).
  - Calculate derived metrics such as total active minutes or categorize activity levels.

### 2. Sleep Data Cleaning
- **File**: `fitbit_SleepDay_data_cleaning.sql`
- **Steps**:
  - Convert timestamp formats to standard date-time format.
  - Remove duplicates based on unique user and sleep date combinations.
  - Handle NULL values in sleep data columns.
  - Integrate or prepare data for merging with daily activity data.

## Usage

To run these scripts, execute them within a PostgreSQL environment where the Fitbit data tables are stored. Ensure the table names and schema match those referenced in the scripts.

## Notes

Each SQL script includes step-by-step comments explaining each transformation. Adjustments may be necessary depending on the structure of the raw data.

