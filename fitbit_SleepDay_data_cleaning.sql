-- sleepday表中只有24名不同用户 在 2016-04-12 和 2016-05-12 期间的睡眠跟踪情况。

select COUNT(distinct Id) AS num_users,
       min(SleepDay) as min_date,
       max(SleepDay) as max_date
       
  FROM top-gantry-233512.FitBit_Fitness_Tracker_Data.sleepDay_merged

select *
FROM top-gantry-233512.FitBit_Fitness_Tracker_Data.sleepDay_merged
where TotalSleepRecords != 1

select count(distinct Id)
FROM top-gantry-233512.FitBit_Fitness_Tracker_Data.sleepDay_merged
where TotalSleepRecords != 1

-- 其中有12名用户有时在一天中会有2次或3次的睡眠记录，

SELECT 
  round(AVG(TotalMinutesAsleep)/60,2) AS avg_hours_asleep,
  round(AVG(TotalTimeInBed)/60,2)  AS avg_time_in_bed,
  round(AVG(TotalMinutesAsleep) / AVG(TotalTimeInBed) * 100,2) AS pct_sleeping_in_bed,
  round(min(TotalMinutesAsleep) /60,2) AS min_hours_asleep,
  round(max(TotalMinutesAsleep) /60,2) AS max_hours_asleep, 
  round(min(TotalTimeInBed)/60,2)  AS min_time_in_bed, 
  round(max(TotalTimeInBed)/60,2)  AS max_time_in_bed,
  round(STDDEV_SAMP(TotalMinutesAsleep/60),2) as stddev_hours_asleep,
  round(STDDEV_SAMP(TotalTimeInBed/60),2) as stddev_time_in_bed,

FROM top-gantry-233512.FitBit_Fitness_Tracker_Data.sleepDay_merged

/*
The average time asleep is 6.99 hours per night, with a standard deviation of nearly 2 hours(1.97 hours). This indicates that the time spent asleep typically deviates by around 2 hours from the average, suggesting wide variability in sleep duration.
The average time spent in bed is 7.64 hours, with a standard deviation of just over 2 hours (2.12 hours). This reflects even more variability in how much time users spend in bed, with some users potentially spending much more or much less time in bed compared to the average.
*/
