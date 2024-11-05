-- Step 1: Check the number of unique users and the date range in the sleepDay table
-- The sleepDay table contains sleep tracking data for only 24 unique users between April 12, 2016, and May 12, 2016.

SELECT COUNT(DISTINCT Id) AS num_users,
       MIN(SleepDay) AS min_date,
       MAX(SleepDay) AS max_date
FROM `top-gantry-233512.FitBit_Fitness_Tracker_Data.sleepDay_merged`;

-- Step 2: Handle NULL values in sleep-related columns
-- Fill missing values in the columns for sleep minutes and time in bed with 0 to ensure data completeness.
SELECT 
    Id AS user_id,
    SleepDay AS sleep_date_standardized,
    COALESCE(TotalMinutesAsleep, 0) AS total_sleep_minutes,
    COALESCE(TotalTimeInBed, 0) AS total_time_in_bed
FROM `top-gantry-233512.FitBit_Fitness_Tracker_Data.sleepDay_merged`;

-- Step 3: Identify records where the number of sleep records per day is not equal to 1
-- This checks for users who have more than one sleep record per day, indicating multiple sleep sessions.

SELECT *
FROM `top-gantry-233512.FitBit_Fitness_Tracker_Data.sleepDay_merged`
WHERE TotalSleepRecords != 1;



-- Step 4: Count the number of unique users who have multiple sleep records in a single day
-- There are 12 users who occasionally have 2 or 3 sleep records in a single day.

SELECT COUNT(DISTINCT Id)
FROM `top-gantry-233512.FitBit_Fitness_Tracker_Data.sleepDay_merged`
WHERE TotalSleepRecords != 1;

-- Step 5: Calculate statistics for sleep data
-- Compute the average, minimum, maximum, and standard deviation for sleep duration and time in bed.
-- These metrics help understand the general sleep patterns and variability among users.

SELECT 
  ROUND(AVG(TotalMinutesAsleep) / 60, 2) AS avg_hours_asleep,          -- Average hours asleep per night
  ROUND(AVG(TotalTimeInBed) / 60, 2) AS avg_time_in_bed,               -- Average hours spent in bed per night
  ROUND(AVG(TotalMinutesAsleep) / AVG(TotalTimeInBed) * 100, 2) AS pct_sleeping_in_bed,  -- Percentage of time asleep while in bed
  ROUND(MIN(TotalMinutesAsleep) / 60, 2) AS min_hours_asleep,          -- Minimum hours asleep
  ROUND(MAX(TotalMinutesAsleep) / 60, 2) AS max_hours_asleep,          -- Maximum hours asleep
  ROUND(MIN(TotalTimeInBed) / 60, 2) AS min_time_in_bed,               -- Minimum time spent in bed
  ROUND(MAX(TotalTimeInBed) / 60, 2) AS max_time_in_bed,               -- Maximum time spent in bed
  ROUND(STDDEV_SAMP(TotalMinutesAsleep / 60), 2) AS stddev_hours_asleep,  -- Standard deviation of hours asleep
  ROUND(STDDEV_SAMP(TotalTimeInBed / 60), 2) AS stddev_time_in_bed     -- Standard deviation of time spent in bed
FROM `top-gantry-233512.FitBit_Fitness_Tracker_Data.sleepDay_merged`;

/*
Summary:
- The average sleep duration is approximately 6.99 hours per night, with a standard deviation of 1.97 hours.
  This suggests significant variability in sleep duration, as the time asleep often deviates by around 2 hours from the mean.
- The average time spent in bed is about 7.64 hours, with a standard deviation of 2.12 hours.
  This indicates even more variability in the time users spend in bed, with some users potentially spending much more or much less time in bed compared to the average.
*/

