-- HCAHPS Data Cleaning SQL Script
-- This script performs data cleaning and standardization on the HCAHPS data.

-- Step 1: Create a temporary table 'hospital_beds_clean' with standardized provider_ccn and date formats
CREATE TABLE "postgres"."Hospital_Data".Tableau_File as
WITH hospital_beds_clean AS (
    SELECT 
        -- Standardize provider_ccn to ensure consistent 6-digit format
        LPAD(provider_ccn::text, 6, '0') AS provider_ccn,
        hospital_name,
        -- Convert fiscal year start and end dates to standard date format
        TO_DATE(fiscal_year_begin_date, 'MM/DD/YYYY') AS fiscal_year_begin_date,
        TO_DATE(fiscal_year_end_date, 'MM/DD/YYYY') AS fiscal_year_end_date,
        number_of_beds,
        -- Rank rows to select the most recent entry per provider
        ROW_NUMBER() OVER(PARTITION BY provider_ccn ORDER BY TO_DATE(fiscal_year_end_date, 'MM/DD/YYYY') DESC) AS nth_row
    FROM "postgres"."Hospital_Data".hospital_beds
)

-- Step 2: Select only the latest record for each provider (where nth_row = 1)
-- Join hospital beds data with HCAHPS data and standardize additional columns
SELECT 
    -- Standardize provider_ccn in HCAHPS data
    LPAD(facility_id::text, 6, '0') AS provider_ccn,
    TO_DATE(start_date, 'MM/DD/YYYY') AS start_date_converted,
    TO_DATE(end_date, 'MM/DD/YYYY') AS end_date_converted,
    hcahps.*,
    beds.number_of_beds,
    beds.fiscal_year_begin_date AS beds_start_report_period,
    beds.fiscal_year_end_date AS beds_end_report_period
FROM "postgres"."Hospital_Data".hcahps_data AS hcahps
LEFT JOIN hospital_beds_clean AS beds ON hcahps.facility_id = beds.provider_ccn
WHERE beds.nth_row = 1;

