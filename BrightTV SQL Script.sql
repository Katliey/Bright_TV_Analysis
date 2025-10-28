SELECT *
FROM USER_PROFILES;

SELECT COUNT (*) AS row_count,
        COUNT (DISTINCT userid) AS Subs
FROM user_profiles;

SELECT DISTINCT gender
FROM user_profiles;

CREATE OR REPLACE TEMP TABLE Users AS
SELECT userid,
COUNT (DISTINCT userid) AS number_of_Users,
age,
CASE
      WHEN age = 0 THEN 'Unknown'
      WHEN age >= 1 AND age <= 3 THEN '1-2 Toddler'
      WHEN age > 3 AND age < 13 THEN '3-12 Child'
      WHEN age BETWEEN 13 AND 19 THEN '13-19 Teenager'
      WHEN age BETWEEN 20 AND 45 THEN '20-45 Adult'
      WHEN age BETWEEN 46 AND 59 THEN '46-59 Senior'
      ELSE '60+ Pensioner'
  END AS Age_Group,
CASE
    WHEN gender IS NULL THEN 'Unknown'
    WHEN gender = 'None' THEN 'Unknown'
    ELSE gender
    END AS gender,

CASE
    WHEN race IS NULL THEN 'Unspecified'
    WHEN race IN ('None', 'other') THEN 'Unspecified'
    ELSE race
    END AS race,

CASE
    WHEN province IS NULL THEN 'Uncategorized'
    WHEN province = 'None' THEN 'Uncategorized'
    ELSE province
    END AS province
FROM user_profiles
GROUP BY ALL;


SELECT * 
FROM users;

SELECT *
FROM viewership
LIMIT 10;

SELECT DISTINCT channel2
FROM viewership;

CREATE OR REPLACE TEMP TABLE Views AS
SELECT
    userid,
        COUNT (DISTINCT userid) AS number_of_Views,
    channel2,
    DATEADD(HOUR, 2,TO_TIMESTAMP(RECORDDATE2, 'YYYY/MM/DD HH24:MI')) AS record_ts_SAST,
    TO_TIME (record_ts_SAST) AS watch_time,
    HOUR (watch_time) AS Hour,
    CASE
        WHEN HOUR BETWEEN 0 AND 5 THEN '0-5 Midnight'
        WHEN HOUR BETWEEN 6 AND 11 THEN '6-11 Morning'
        WHEN HOUR BETWEEN 12 AND 16 THEN '12-16 Afternoon'
        WHEN HOUR BETWEEN 17 AND 20 THEN '17-20 Evening'
        ELSE '21-23 Night'
        END AS Time_Buckets,
    TO_DATE(record_ts_SAST) AS watch_date,
    DAYNAME (record_ts_SAST) AS day_name,
    CASE
        WHEN day_name IN ('Sat', 'Sun') THEN 'weekend'
        ELSE 'weekday'
        END AS day_of_week_classification,
    MONTHNAME (record_ts_SAST) AS month_name,
    duration2
FROM viewership
GROUP BY ALL;

SELECT *
FROM Views;   

SELECT COALESCE(A.userid,B.userid) AS UserID, 
        COALESCE(A.number_of_Views, B.number_of_Users) AS no_of_views,
        A.channel2, A.record_ts_SAST, A.watch_time, A.Hour, A.time_buckets, A.watch_date, A.day_name, A.day_of_week_classification, A.month_name, A.duration2,
        B.age, B.Age_Group, B.gender, B.race, B.province
FROM Views AS A
LEFT JOIN Users AS B
ON A.userid = B.userid
GROUP BY ALL;
