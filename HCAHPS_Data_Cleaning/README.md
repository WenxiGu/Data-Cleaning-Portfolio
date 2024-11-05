
# HCAHPS Data Cleaning Project

This project involves cleaning and preparing the HCAHPS (Hospital Consumer Assessment of Healthcare Providers and Systems) dataset 
for further analysis. The data cleaning steps have been implemented in SQL and involve several transformations to standardize 
and organize the data effectively.

## Data Cleaning Steps

1. **Standardizing Columns**:
   - The `provider_ccn` column is padded with leading zeros to ensure a consistent 6-digit format.
   - Date columns (`fiscal_year_begin_date` and `fiscal_year_end_date`) are converted to a standard date format (YYYY-MM-DD).
   
2. **Handling Duplicates**:
   - Using a window function with `row_number()` to rank records by `provider_ccn` and filter for the latest entry per provider.
   
3. **Joining Data**:
   - Joining the cleaned hospital beds data with HCAHPS data to enrich records with additional hospital-specific details, such as 
     number of beds and reporting period.

## SQL Code Structure

The SQL file follows a step-by-step approach with comments added at each step to clarify the purpose of each transformation. 
The script first cleans the hospital beds data and then merges it with the HCAHPS data.

## Usage

To run this script, execute it within a PostgreSQL environment that has access to the HCAHPS and hospital beds tables. 
Ensure that these tables are in the `Hospital_Data` schema under the `postgres` database.

## Notes

This data cleaning is tailored for the HCAHPS dataset and may need adjustments for other datasets with different structures.
