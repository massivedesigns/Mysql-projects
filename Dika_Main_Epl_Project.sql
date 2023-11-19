-- To start this project we begin we data cleaning of all tables imported 

-- 1. DATA CLEANING
SELECT *
FROM  epl_league_stats;
-- this table is data is in a good format 

-- ii. We move to the next table 
SELECT *
FROM  eplmatches_stats;

-- eplmatches_stats tables date column is in text or varchar format and needs to be converted to date column

-- DATE EXTRACTION
SELECT date_GMT, STR_TO_DATE(date_GMT, '%b %d %Y') AS main_date1
FROM eplmatches_stats;

-- TIME EXTRACTION
SELECT date_GMT, STR_TO_DATE(SUBSTRING_INDEX(date_GMT, '-', -1), '%h:%i %p') AS main_time1
FROM eplmatches_stats;

-- alternatively  we do this for the time too

SELECT STR_TO_DATE(SUBSTRING(date_GMT,14, 16), '%h:%i %p')
FROM eplmatches_stats;

  -- updating the table with the date value 
ALTER TABLE eplmatches_stats
ADD Main_date DATE;

-- code below didnt work 
UPDATE eplmatches_stats
SET Main_date = STR_TO_DATE(date_GMT, '%b %d %Y');

-- this one worrked by adding time specifier to match the whole value in date_GMT column
UPDATE eplmatches_stats
SET Main_date = STR_TO_DATE(date_GMT, '%b %d %Y - %l:%i%p');


SELECT date_GMT, Main_date
FROM eplmatches_stats;

-- updating the table with the new time value 
ALTER TABLE eplmatches_stats
ADD Main_time TIME;

UPDATE eplmatches_stats
SET Main_time = STR_TO_DATE(SUBSTRING_INDEX(date_GMT, '-', -1), '%h:%i %p');




-- ANALYSIS --------------------------------------------------------------------------

-- checking the top 20 matches with the highest attendance 2018/2019 season
SELECT attendance, home_team_name, away_team_name, referee, date_GMT, Main_date, Main_time, stadium_name
FROM eplmatches_stats
ORDER BY attendance DESC
LIMIT 20;

SELECT attendance, home_team_name, away_team_name, referee, date_GMT, Main_date, Main_time
FROM eplmatches_stats
WHERE attendance >= 50000 AND TIME(Main_time) > '14:00:00'
ORDER BY attendance DESC;











