-- Calculating churn rates for subscribers over a number of months. Temporary tables are set up in order to do this.

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
    '2016-12-01' as first_day,
    '2016-12-31' as last_day
  UNION
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
  END AS is_canceled_87,
  CASE 
    WHEN (segment = 30) AND (subscription_end BETWEEN first_day AND last_day)
    THEN 1
    ELSE 0
  END AS is_canceled_30
  FROM cross_join
)
SELECT *
FROM status
LIMIT 50;
