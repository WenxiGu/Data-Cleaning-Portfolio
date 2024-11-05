/*
Daily activity data for users between March 12, 2016 - April 11, 2016 is stored in `daily_activity_1`, 
and data from April 12, 2016 - May 12, 2016 is in `daily_activity_2`.
Both tables have matching columns and data types, allowing them to be merged using UNION ALL if necessary.
*/

-- Step 1: Check if user_ids in both tables are consistent
SELECT COUNT(DISTINCT Id)
FROM `top-gantry-233512.FitBit_Fitness_Tracker_Data.Daily_Activity_1`; -- Result: 35 unique users

SELECT COUNT(DISTINCT Id)
FROM `top-gantry-233512.FitBit_Fitness_Tracker_Data.Daily_Activity_2`; -- Result: 33 unique users

-- Step 2: Examine the correspondence of user IDs between tables to ensure sample consistency
SELECT DISTINCT(Daily_Activity_1.Id)
FROM `top-gantry-233512.FitBit_Fitness_Tracker_Data.Daily_Activity_1` AS Daily_Activity_1
LEFT JOIN 
`top-gantry-233512.FitBit_Fitness_Tracker_Data.Daily_Activity_2` AS Daily_Activity_2
ON Daily_Activity_1.Id = Daily_Activity_2.Id 
WHERE Daily_Activity_2.Id IS NULL;
-- Result: There are 2 user IDs in `daily_activity_1` that are not present in `daily_activity_2` (IDs: 2891001357 and 6391747486).

-- Step 3: Exclude these two users from further analysis for consistency
-- Creating a combined table with only common users
CREATE TABLE `top-gantry-233512.FitBit_Fitness_Tracker_Data.Daily_Activity_Total` AS 
SELECT *
FROM `top-gantry-233512.FitBit_Fitness_Tracker_Data.Daily_Activity_1` AS Daily_Activity_1 -- Data from March to April
WHERE Daily_Activity_1.Id != 2891001357 AND Daily_Activity_1.Id != 6391747486
UNION ALL
SELECT *
FROM `top-gantry-233512.FitBit_Fitness_Tracker_Data.Daily_Activity_2` AS Daily_Activity_2; -- Data from April to May

-- Step 4: Verify the combined table by checking ID and ActivityDate combinations
SELECT Id, ActivityDate
FROM `top-gantry-233512.FitBit_Fitness_Tracker_Data.Daily_Activity_Total`
GROUP BY Id, ActivityDate
ORDER BY Id, ActivityDate;
-- Result: Total row count is 1380.

-- Step 5: Check for missing values in key columns in the combined table
SELECT
  COUNT(*) AS total_rows,
  COUNTIF(Id IS NULL) AS missing_Id,
  COUNTIF(ActivityDate IS NULL) AS missing_ActivityDate,
  COUNTIF(TotalSteps IS NULL) AS missing_steps,
  COUNTIF(Calories IS NULL) AS missing_calories,
  COUNTIF(TotalDistance IS NULL) AS missing_distance,
  COUNTIF(VeryActiveMinutes IS NULL) AS missing_minutes
FROM `top-gantry-233512.FitBit_Fitness_Tracker_Data.Daily_Activity_Total`;
-- Result: 1380 total rows, no missing values in key columns.

-- Step 6: Identify outliers where SedentaryMinutes = 1440 (24 hours sedentary in a single day)
SELECT DISTINCT Id,
       COUNT(*) AS num_activities
FROM `top-gantry-233512.FitBit_Fitness_Tracker_Data.Daily_Activity_Total`
WHERE SedentaryMinutes = 1440 
GROUP BY 1
ORDER BY 2;
-- Result: 19 users with SedentaryMinutes = 1440, ranging from 1 to 24 days.

-- Step 7: Further investigate records with SedentaryMinutes = 1440 for potential anomalies
WITH total_prep AS 
(
  SELECT Id,
         ActivityDate,
         TotalSteps,
         Calories,
         TotalDistance,
         VeryActiveMinutes,
         COUNT(*) OVER (PARTITION BY Id ORDER BY ActivityDate) AS num_activities
  FROM `top-gantry-233512.FitBit_Fitness_Tracker_Data.Daily_Activity_Total`
  WHERE SedentaryMinutes = 1440
);
/*
Analysis: When SedentaryMinutes = 1440, there are 132 records.
Some users have other metrics set to 0, likely due to login errors or default settings.
For example, users like 1844505072, 1927972279, and 2320127002 have consistent calorie values but no other recorded activities,
likely due to manual entries or device malfunctions.
Some users show metrics even when SedentaryMinutes is 1440, potentially due to manual inputs or recording errors.
*/

-- Step 8: Identify records where Calories = 0, as other metrics (except SedentaryMinutes) are also 0.
-- These cases (9 records) may be default settings or login errors, and should be filtered out in further analyses to avoid skewed averages.
SELECT *
FROM `top-gantry-233512.FitBit_Fitness_Tracker_Data.Daily_Activity_Total`
WHERE Calories = 0;

-- Step 9: Examine other metrics when SedentaryMinutes = 1440, focusing on cases with recorded steps
SELECT COUNT(*) AS num_cases_not_active, 
       COUNT(CASE WHEN TotalSteps > 0 THEN TotalSteps ELSE NULL END) AS num_cases_not_active_with_steps
FROM `top-gantry-233512.FitBit_Fitness_Tracker_Data.Daily_Activity_Total`
WHERE SedentaryMinutes = 1440;
/*
Result: There are cases where Calories > 0 but other metrics are 0, likely due to users manually entering only calorie values.
In 132 records with SedentaryMinutes = 1440, 17 records show recorded steps, possibly due to manual entry or device issues 
where other activities were not recorded.
*/



## User Count and Activity Distribution, this part is dedicated to data aggregation(TotalSteps,VeryActiveMinutes,SedentaryMinutes,Calories). 

SELECT
  MIN(Calories) AS min_calories,
  MAX(Calories) AS max_calories,
  AVG(Calories) AS avg_calories
FROM top-gantry-233512.FitBit_Fitness_Tracker_Data.Daily_Activity_Total
where Calories != 0


## min_calories = 50, max_calories = 4900, avg_calories = 2280.960374639

SELECT
  MIN(VeryActiveMinutes) AS min_active_minutes,
  MAX(VeryActiveMinutes) AS max_active_minutes,
  AVG(VeryActiveMinutes) AS avg_active_minutes
FROM top-gantry-233512.FitBit_Fitness_Tracker_Data.Daily_Activity_Total
WHERE SedentaryMinutes < 1440 and Calories != 0

## min_active_minutes =0, max_active_minutes = 210, avg_active_minutes = 21.991987179487

SELECT *
FROM top-gantry-233512.FitBit_Fitness_Tracker_Data.Daily_Activity_Total
WHERE TotalSteps = 0 AND SedentaryMinutes < 1440
--There are 11 records where TotalSteps is 0 while SedentaryMinutes is less than 1440, which may indicate that these steps were not recorded. Therefore, these records will not be included in the following calculations.

SELECT 
  MIN(TotalSteps) AS min_steps,
  MAX(TotalSteps) AS max_steps,
  AVG(TotalSteps) AS avg_steps
FROM top-gantry-233512.FitBit_Fitness_Tracker_Data.Daily_Activity_Total
WHERE TotalSteps > 0 

## min_steps = 4, max_steps = 36019, avg_steps = 8096.6459330143


SELECT
  MIN(SedentaryMinutes) AS min_sedentary_minutes,
  MAX(SedentaryMinutes) AS max_sedentary_minutes,
  AVG(SedentaryMinutes) AS avg_sedentary_minutes
FROM top-gantry-233512.FitBit_Fitness_Tracker_Data.Daily_Activity_Total
WHERE SedentaryMinutes < 1440 AND SedentaryMinutes > 0

--min_sedentary_minutes = 2, max_sedentary_minutes = 1439, avg_sedentary_minutes = 942.66507177033452, it looks abnormal, could be some issues when recorded, the data in this field is not convincing enough to be taken for further analisis.


## Daily Activity Trends (on cleaned data)

-- SELECT
--   DATE(ActivityDate) AS date,
--   AVG(Calories) AS avg_daily_calories,
--   AVG(VeryActiveMinutes) AS avg_daily_very_active_minutes,
--   AVG(CASE WHEN TotalSteps > 0 THEN TotalSteps ELSE NULL END) AS avg_daily_steps
-- FROM `top-gantry-233512.FitBit_Fitness_Tracker_Data.daily_activity_total_cleaned` 
-- GROUP BY date
-- ORDER BY date

## Weekday vs. Weekend Patterns (on cleaned data)

-- Extract day of the week and calculate average activity metrics
-- SELECT
--   FORMAT_TIMESTAMP('%A', ActivityDate) AS day_of_week,
--   AVG(Calories) AS avg_calories,
--   AVG(VeryActiveMinutes) AS avg_active_minutes,
--   AVG(CASE WHEN TotalSteps > 0 THEN TotalSteps ELSE NULL END) AS avg_steps
-- FROM `top-gantry-233512.FitBit_Fitness_Tracker_Data.daily_activity_total_cleaned`
-- GROUP BY day_of_week
-- ORDER BY
--   CASE
--     WHEN day_of_week = 'Monday' THEN 1
--     WHEN day_of_week = 'Tuesday' THEN 2
--     WHEN day_of_week = 'Wednesday' THEN 3
--     WHEN day_of_week = 'Thursday' THEN 4
--     WHEN day_of_week = 'Friday' THEN 5
--     WHEN day_of_week = 'Saturday' THEN 6
--     WHEN day_of_week = 'Sunday' THEN 7
--   END;
