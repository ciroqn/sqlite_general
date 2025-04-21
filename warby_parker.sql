SELECT * 
FROM survey
LIMIT 10;

-- How many people answered each question
SELECT 
  question,
  COUNT(DISTINCT user_id)
FROM survey
GROUP BY question;

-- Count by style
SELECT 
  style,
  COUNT(DISTINCT user_id)
FROM quiz
GROUP BY style;

# Count by style, fit, shape (finding most popular)
SELECT 
  style,
  fit, 
  shape,
  COUNT(DISTINCT user_id)
FROM quiz
GROUP BY style, fit, shape;

-- See Excel table for drop-off in customer answers for each question.

-- Examine first five rows of each table
SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;

-- Create new table from above.
SELECT 
  q.user_id, 
  hto.user_id IS NOT NULL AS 'is_home_try_on', hto.number_of_pairs, 
  p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'hto'
  ON q.user_id = hto.user_id
LEFT JOIN purchase AS 'p'
  ON hto.user_id = p.user_id
LIMIT 10;

-- Find useful home_try_on stats for funnel
WITH funnel AS (
  SELECT 
    q.user_id, 
    hto.user_id IS NOT NULL AS 'is_home_try_on', 
    hto.number_of_pairs, 
    p.user_id IS NOT NULL AS 'is_purchase'
  FROM quiz AS 'q'
  LEFT JOIN home_try_on AS 'hto'
    ON q.user_id = hto.user_id
  LEFT JOIN purchase AS 'p'
  ON hto.user_id = p.user_id
)
SELECT number_of_pairs, SUM(is_home_try_on) AS 'tot_home_try_on', SUM(is_purchase) AS 'num_purchased'
FROM funnel
GROUP BY number_of_pairs;
