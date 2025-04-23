-- Calculating churn rates for subscribers over a number of months. Temporary tables are set up in order to do this. The subscribers are 
-- from one of two segments (subscriber models): 30 or 87. Hence, the aggregate functions are performed on these separately.

-- inspect table (commented out)
-- SELECT *
-- FROM subscriptions
-- LIMIT 100;

-- see range of months in table in order to create a temp table of months
SELECT MIN(subscription_start), MAX(subscription_end)
FROM subscriptions
LIMIT 100;

-- creating temporary table of months
WITH months as (
  SELECT
    '2017-01-01' as first_day,
    '2016-07-31' as last_day
  UNION
  SELECT
    '2017-02-01' as first_day,
    '2017-02-28' as last_day
  UNION
  SELECT
    '2017-03-01' as first_day,
    '2017-03-31' as last_day
),
-- create temprorary table that joins 'months' and 'subscriptions' tables
cross_join as (
  SELECT *
  FROM subscriptions
  CROSS JOIN months
),
status as (
  SELECT
  id,
  first_day as month,
  CASE
    WHEN (segment = 87) AND (subscription_start < first_day) AND (subscription_end > first_day OR subscription_end IS NULL)
    THEN 1
    ELSE 0
  END AS is_active_87,
  CASE
    WHEN (segment = 30) AND (subscription_start < first_day) AND (subscription_end > first_day OR subscription_end IS NULL)
    THEN 1
    ELSE 0
  END AS is_active_30,
  CASE
    WHEN (segment = 87) AND (subscription_end BETWEEN first_day AND last_day)
    THEN 1
    ELSE 0
  END AS is_cancelled_87,
  CASE 
    WHEN (segment = 30) AND (subscription_end BETWEEN first_day AND last_day)
    THEN 1
    ELSE 0
  END AS is_cancelled_30
  FROM cross_join
),
status_aggregate as (
  SELECT
    SUM(is_active_87) as sum_active_87,
    SUM(is_active_30) as sum_active_30,
    SUM(is_cancelled_87) as sum_cancelled_87,
    SUM(is_cancelled_30) as sum_cancelled_30
  FROM status
)

