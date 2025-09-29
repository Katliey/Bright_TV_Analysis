SELECT COUNT(
    DISTINCT coalesce(A.UserID, B.UserID)
  ) AS SUBS,
  A.Channel2,
  A.RecordDate2,
  to_date(
    try_to_timestamp(RecordDate2, 'yyyy/MM/dd HH:mm')
  ) AS Watch_Date,
dayname(
    to_date(
      try_to_timestamp(RecordDate2, 'yyyy/MM/dd HH:mm')
    )
  ) AS Day_Name,
dayofmonth(
    to_date(
      try_to_timestamp(RecordDate2, 'yyyy/MM/dd HH:mm')
    )
  ) AS Day_Of_Month,
to_char(
    to_date(
      try_to_timestamp(RecordDate2, 'yyyy/MM/dd HH:mm')
    ),
    'MMM'
  ) AS Month_Name,
date_format(
    from_utc_timestamp(
      try_to_timestamp(RecordDate2, 'yyyy/MM/dd HH:mm'),
      'Africa/Johannesburg'
    ),
    'HH:mm:ss'
  ) AS Watching_Time,
CASE
  WHEN hour(
    from_utc_timestamp(
      try_to_timestamp(RecordDate2, 'yyyy/MM/dd HH:mm'),
      'Africa/Johannesburg'
    )
  ) BETWEEN 0 AND 5 THEN 'Midnight'
  WHEN hour(
    from_utc_timestamp(
      try_to_timestamp(RecordDate2, 'yyyy/MM/dd HH:mm'),
      'Africa/Johannesburg'
    )
  ) BETWEEN 6 AND 11 THEN 'Morning'
  WHEN hour(
    from_utc_timestamp(
      try_to_timestamp(RecordDate2, 'yyyy/MM/dd HH:mm'),
      'Africa/Johannesburg'
    )
  ) BETWEEN 12 AND 16 THEN 'Afternoon'
  WHEN hour(
    from_utc_timestamp(
      try_to_timestamp(RecordDate2, 'yyyy/MM/dd HH:mm'),
      'Africa/Johannesburg'
    )
  ) BETWEEN 17 AND 19 THEN 'Evening'
  WHEN hour(
    from_utc_timestamp(
      try_to_timestamp(RecordDate2, 'yyyy/MM/dd HH:mm'),
      'Africa/Johannesburg'
    )
  ) BETWEEN 20 AND 23 THEN 'Night'
  ELSE 'Unknown'
END AS Time_Buckets,
  A.Duration2,
  to_date(
    try_to_timestamp(Duration2, 'yyyy/MM/dd HH:mm')
  ) AS End_Date,
date_format(
    from_utc_timestamp(
      try_to_timestamp(Duration2, 'yyyy/MM/dd HH:mm'),
      'Africa/Johannesburg'
    ),
    'HH:mm:ss'
  ) AS Duration,
  B.Gender,
  B.Race,
  B.Age,
  CASE
      WHEN B.Age = 0 THEN 'Unknown'
      WHEN B.Age >= 1 AND B.Age <= 3 THEN 'Toddler'
      WHEN B.Age > 3 AND B.Age < 13 THEN 'Child'
      WHEN B.Age BETWEEN 13 AND 19 THEN 'Teenager'
      WHEN B.Age BETWEEN 20 AND 35 THEN 'Youth'
      WHEN B.Age BETWEEN 35 AND 45 THEN 'Adlut'
      WHEN B.Age BETWEEN 46 AND 59 THEN 'Senior'
      ELSE 'Pensioner'
  END AS AGE_GROUP,
  B.Province
FROM
  `workspace`.`default`.`bright_tv_viewership` A
INNER JOIN
  `workspace`.`default`.`bright_tv_user_profiles` B
    ON A.`UserID` = B.`UserID`
GROUP BY ALL;
