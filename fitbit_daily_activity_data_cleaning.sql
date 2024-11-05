/*
daily_activity_1 和 daily_activity_2 表分别对应了用户在2016年3月12号-4月11号， 和2016年 4月12号-5月12号的日常活动情况。
两个表的列都相对应，并且数据类型相同，之后也许可以用 union all 将两个表合并。
*/

--查看两个table中的user_id 是否一致
SELECT COUNT(DISTINCT Id)
FROM `top-gantry-233512.FitBit_Fitness_Tracker_Data.Daily_Activity_1` -- 结果：35个user

SELECT COUNT(DISTINCT Id)
FROM `top-gantry-233512.FitBit_Fitness_Tracker_Data.Daily_Activity_2` -- 结果： 33个user

--为了保持调研样本的一致性和其活动的延续性，需要看看这些用户号的对应情况。

SELECT DISTINCT(Daily_Activity_1.Id)
FROM `top-gantry-233512.FitBit_Fitness_Tracker_Data.Daily_Activity_1` AS Daily_Activity_1
LEFT JOIN 
`top-gantry-233512.FitBit_Fitness_Tracker_Data.Daily_Activity_2` AS Daily_Activity_2
ON Daily_Activity_1.Id = Daily_Activity_2.Id 
WHERE Daily_Activity_2.Id IS NULL --in the daily_activity_1 table there are 2 more user IDs, the rest are the same as that in the daily_activity_1 table, those 2 ids are : 2891001357 and 6391747486

--这两个用户将被剔除，不参与后续分析。

--新建一个daily_activity 的总表
CREATE TABLE `top-gantry-233512.FitBit_Fitness_Tracker_Data.Daily_Activity_Total` as 
SELECT *
FROM `top-gantry-233512.FitBit_Fitness_Tracker_Data.Daily_Activity_1` as Daily_Activity_1 -- 3到4月数据
WHERE Daily_Activity_1.Id != 2891001357 AND Daily_Activity_1.Id != 6391747486
UNION ALL
SELECT *
FROM `top-gantry-233512.FitBit_Fitness_Tracker_Data.Daily_Activity_2`as Daily_Activity_2;-- 4到5月数据


select Id, ActivityDate
from top-gantry-233512.FitBit_Fitness_Tracker_Data.Daily_Activity_Total -- 总行数 1380
group by Id,ActivityDate
order by Id,ActivityDate

--开始数据清洗

--查看是否这个总表有重要数据空缺的情况

SELECT
  COUNT(*) as total_rows,
COUNTIF('Id' IS NULL) as missing_Id,
COUNTIF('ActivityDate' IS NULL) as missing_ActivityDate,
COUNTIF('TotalSteps' IS NULL) as missing_steps,
COUNTIF('Calories' IS NULL) as missing_calories,
COUNTIF('TotalDistance' IS NULL) as missing_distance,
COUNTIF('VeryActiveMinutes' IS NULL) as missing_minutes,
FROM top-gantry-233512.FitBit_Fitness_Tracker_Data.Daily_Activity_Total

--总行数为1380，未发现有重要数据空缺的情况

--看看是否有outliers 
select distinct id,
       count(*) as num_activities
FROM top-gantry-233512.FitBit_Fitness_Tracker_Data.Daily_Activity_Total
WHERE SedentaryMinutes = 1440 
group by 1
order by 2
-- 共有19名用户存在SedentaryMinutes = 1440，即记录中一天的静止时间为24小时的特殊情况，其中最少为1天，最多为24天。

WITH total_prep as 
( SELECT Id,
       ActivityDate,
       TotalSteps,
       Calories,
       TotalDistance,
       VeryActiveMinutes,
       count(*) over (partition by id order by ActivityDate) as num_activities
FROM top-gantry-233512.FitBit_Fitness_Tracker_Data.Daily_Activity_Total
WHERE SedentaryMinutes = 1440
)
/* 当SedentaryMinutes = 1440时， 一共有132条记录。 
其中有用户其他重要指标都是0，可能存在login错误，或者默认设定等情况。
1844505072，1927972279，2320127002等这些用户其他指标是0，但是卡路里那一栏总是呈相似指数，可能是由于其多次手动输入相关值。但是没有在其他运动时间使用设备。
其他用户有一些记录是有其他指标的记录的，但是SedentaryMinutes = 1440，所以可能是手动输入其他指标，或者是设备记录存在故障
*/


--当卡路里为0时，其他指标除了 SedentaryMinutes 也都是0，这个情况有9条记录，可能是login 错位，或者是默认设置。为了之后对于指标平均值的计算，需要在之后过滤出其不为0的记录。

SELECT *,
FROM top-gantry-233512.FitBit_Fitness_Tracker_Data.Daily_Activity_Total
WHERE  Calories = 0

--看看当SedentaryMinutes = 1440时，看看其他指标的状态
SELECT COUNT(*) AS num_cases_not_active, COUNT(CASE WHEN TotalSteps >0 THEN TotalSteps ELSE NULL END) AS num_cases_not_active_with_steps
FROM top-gantry-233512.FitBit_Fitness_Tracker_Data.Daily_Activity_Total
WHERE SedentaryMinutes = 1440 
--因为有卡路里大于0，但是其他指标为0 的情况，很有可能时用户自己手动只输入了卡路里。 在SedentaryMinutes = 1440时，在132条记录中，有17条记录显示用户有记录步数，这很有可能时因为他们自己只手动输入了步数，或者是由于系统故障，其他的活动没有被记录到。


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
--有11条记录显示SedentaryMinutes < 1440的情况下，TotalSteps 为0，可能是没有记录到，这些记录就不包括在以下的计算里了。


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