-- 1. Calculate the number of days user tracked physical activity
 

 SELECT 
       distinct Id,
	  count(ActivityDate) over (partition by id) AS days_activity_recorded
  FROM [bellabeat].[dbo].[dailyActivity]
    order by days_activity_recorded desc

	--2. calculate average minutes for each activity

	select 
	ROUND(AVG(VeryActiveMinutes),0) As AvgVA,
	ROUND(Avg(FairlyActiveMinutes),2) AS FA,
	round(Avg(LightlyActiveMinutes)/60.0,2) AS LHOUR,
	round(Avg(SedentaryMinutes)/60.0,2) AS SHOUR
	from [dbo].[dailyActivity]

--3 how do I determine when users were most active? Calculating average intensity for every hour.
--High intensity or high METS implies more people are active during that time. 


	SELECT DISTINCT (cast(ActivityHour as time)) as activityhour,
	AVG(TotalIntensity) OVER (PARTITION BY DATEPART(HOUR,ActivityHour)) AS average_intensity,
	AVG(METs/10.0) over (PARTITION BY DATEPART(HOUR,ActivityHour)) as average_mets
    FROM [dbo].[hourly_activities$]
	JOIN [dbo].[minuteMETsNarrow_merged] AS METs
	ON hourly_activities$.id = METs.Id And hourly_activities$.ActivityHour = Mets.ActivityMinute
	order by average_intensity desc


	create view user_trackeddays as 
	SELECT 
       distinct Id,
	  count(ActivityDate) over (partition by id) AS days_activity_recorded
  FROM [bellabeat].[dbo].[dailyActivity]
   -- order by days_activity_recorded desc




--4.  calculating number of users and their daily avaerages
--a. tracking their physical activities

select count(distinct id) AS users_tracking_activities,
AVG(TotalSteps) AS average_steps,
AVG(TotalDistance) AS average_distance,
AVG(Calories) AS average_Calories
from [dbo].[dailyActivity]

--b. tracking heart rate
     Select count(distinct id) As users_tracking_heart_rate,
	 Avg(value) AS average_heartrate,
	 Avg(value) AS minimium_heartrate,
	 Avg(value) AS maximum_heartrate
     from [dbo].[heartrate_seconds]

--c tracking sleep
   Select count(distinct id) as users_tracking_sleep,
   AVG(TotalMinutesAsleep)/60 AS average_hours_asleep,
    MIN(TotalMinutesAsleep)/60 AS min_hours_asleep,
	MAX(TotalMinutesAsleep)/60  AS max_hours_asleep,
	AVG(TotalTimeInBed)/60    AS average_hours_inbed 

   from [dbo].[sleepDay_merged]


--d tracking weight
SELECT 
count(distinct id) as users_tracking_weight,
AVG(WeightKg) AS average_weight,
Min(WeightKg)AS minimum_weight,
Max(weightKg) As max_weight
from [dbo].[weightLogInfo_merged]

