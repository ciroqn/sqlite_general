SELECT *
FROM stream
LIMIT 20;

SELECT *
FROM chat
LIMIT 20;

-- unique games
SELECT DISTINCT game
FROM stream;

-- unique channels
SELECT DISTINCT channel
FROM stream;

-- most popular games
SELECT 
  game,
  COUNT(*)
FROM stream
GROUP BY game
ORDER BY 2 DESC;

-- where most viewers of LoL are from
SELECT
  country,
  COUNT(*)
FROM stream
WHERE game = 'League of Legends'
GROUP BY country
ORDER BY 2 DESC;

-- device type that twitch streams are viewed on
SELECT 
  player,
  COUNT(*)
FROM stream
GROUP BY player
ORDER BY 2 DESC;

-- create new 'genre' column
SELECT game,
  CASE
    WHEN game = 'Dota 2'
      THEN 'MOBA'
    WHEN game = 'League of Legends'
      THEN 'MOBA'
    WHEN game = 'Heroes of the Storm'
      THEN 'MOBA'
    WHEN game = 'Counter-Strike: Global Offensive'
      THEN 'FPS'
    WHEN game = 'DayZ'
      THEN 'Survival'
    WHEN game = 'ARK: Survival Evolved'
      THEN 'Survival'
    ELSE 'Other'
    END AS 'genre',
  COUNT(*)
FROM stream
GROUP BY 1
ORDER BY 3 DESC;

-- Check 'time' col
SELECT time
FROM stream
LIMIT 10;

-- find how viewing changes with the hour in US
SELECT 
  strftime('%H', time),
  COUNT(*)
FROM stream
WHERE country = 'US'
GROUP BY 1;

-- join tables at common column
SELECT *
FROM stream
JOIN chat
  ON stream.device_id = chat.device_id;
