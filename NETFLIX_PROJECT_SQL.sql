-- NETFLIX DATA ANALYSIS PROJECT
-- Author: [Your Name]
-- Tool Used: PostgreSQL

-- ==========================================
-- 1. SETUP AND SCHEMA
-- ==========================================

DROP TABLE IF EXISTS NETFLIX;
CREATE TABLE NETFLIX
(
    SHOW_ID      VARCHAR(5),
    TYPE         VARCHAR(10),
    TITLE        VARCHAR(250),
    DIRECTOR     VARCHAR(550),
    CASTS        VARCHAR(1050),
    COUNTRY      VARCHAR(550),
    DATE_ADDED   VARCHAR(55),
    RELEASE_YEAR INT,
    RATING       VARCHAR(15),
    DURATION     VARCHAR(15),
    LISTED_IN    VARCHAR(250),
    DESCRIPTION  VARCHAR(550)
);

SELECT * FROM NETFLIX;

-- ==========================================
-- 2. DATA CLEANING
-- ==========================================

-- Check for missing values
SELECT *
FROM NETFLIX
WHERE DIRECTOR IS NULL
   OR COUNTRY IS NULL
   OR TYPE IS NULL
   OR CASTS IS NULL
   OR RELEASE_YEAR IS NULL
   OR RATING IS NULL
   OR DURATION IS NULL
   OR LISTED_IN IS NULL
   OR DESCRIPTION IS NULL;

-- Populate missing data with default values
UPDATE NETFLIX SET DIRECTOR = 'UNKNOWN' WHERE DIRECTOR IS NULL;
UPDATE NETFLIX SET COUNTRY = 'UNKNOWN' WHERE COUNTRY IS NULL;
UPDATE NETFLIX SET CASTS = 'UNKNOWN' WHERE CASTS IS NULL;
UPDATE NETFLIX SET RATING = 'UNKNOWN' WHERE RATING IS NULL;
UPDATE NETFLIX SET DURATION = 'UNKNOWN' WHERE DURATION IS NULL;
UPDATE NETFLIX SET DESCRIPTION = 'UNKNOWN' WHERE DESCRIPTION IS NULL;

-- Convert Date Format
ALTER TABLE NETFLIX
ALTER COLUMN date_added TYPE DATE
USING TO_DATE(date_added, 'Month DD, YYYY');

SELECT * FROM NETFLIX;

-- ==========================================
-- 3. DATA ANALYSIS & BUSINESS PROBLEMS
-- ==========================================

-- 1. Count the Number of Movies vs TV Shows
SELECT
    TYPE,
    COUNT(*)
FROM NETFLIX
GROUP BY TYPE;


-- 2. Find the Most Common Rating for Movies and TV Shows
WITH RatingCounts AS (
    SELECT
        RATING,
        TYPE,
        COUNT(*) AS RATING_COUNT
    FROM NETFLIX
    GROUP BY RATING, TYPE
),
RankedRatings AS (
    SELECT
        RATING,
        TYPE,
        RATING_COUNT,
        DENSE_RANK() OVER (PARTITION BY TYPE ORDER BY RATING_COUNT DESC) AS rank
    FROM RatingCounts
)
SELECT
    RATING,
    TYPE
FROM RankedRatings
WHERE rank = 1;


-- 3. List All Movies Released in a Specific Year (e.g., 2020)
SELECT *
FROM NETFLIX
WHERE TYPE = 'Movie'
  AND RELEASE_YEAR = 2020;


-- 4. Find the Top 5 Countries with the Most Content on Netflix
SELECT
    COUNTRY,
    COUNT(*) AS TOTAL_CONTENT
FROM NETFLIX
WHERE COUNTRY != 'UNKNOWN'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- 5. Find Content Added in the Last 5 Years
SELECT *
FROM NETFLIX
WHERE DATE_ADDED >= CURRENT_DATE - INTERVAL '5 YEARS'
ORDER BY DATE_ADDED DESC;


-- 6. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
SELECT *
FROM NETFLIX
WHERE DIRECTOR ILIKE '%Rajiv Chilaka%';


-- 7. List All TV Shows with More Than 5 Seasons
SELECT *
FROM NETFLIX
WHERE TYPE = 'TV Show'
  AND SPLIT_PART(DURATION, ' ', 1)::INT > 5
ORDER BY SPLIT_PART(DURATION, ' ', 1)::INT DESC;


-- 8. Count the Number of Content Items in Each Genre
SELECT
    UNNEST(STRING_TO_ARRAY(LISTED_IN, ',')) AS GENRE,
    COUNT(*) AS TOTAL_CONTENT
FROM NETFLIX
GROUP BY 1
ORDER BY 2 DESC;


-- 9. Find each year and the average numbers of content release in India on netflix.
-- return top 5 year with highest avg content release!
SELECT
    RELEASE_YEAR,
    COUNT(SHOW_ID) AS TOTAL_RELEASE,
    ROUND(
        COUNT(SHOW_ID)::NUMERIC /
        (SELECT COUNT(DISTINCT RELEASE_YEAR) FROM NETFLIX WHERE COUNTRY = 'India')::NUMERIC, 2
    ) AS AVG_RELEASE
FROM NETFLIX
WHERE COUNTRY = 'India'
GROUP BY RELEASE_YEAR
ORDER BY TOTAL_RELEASE DESC
LIMIT 5;


-- 10. List All Movies that are Documentaries
SELECT *
FROM NETFLIX
WHERE TYPE = 'Movie'
  AND LISTED_IN ILIKE '%DOCUMENTARIES%';


-- 11. Find All Content Without a Director
SELECT *
FROM NETFLIX
WHERE DIRECTOR = 'UNKNOWN';


-- 12. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
SELECT *
FROM NETFLIX
WHERE TYPE = 'Movie'
  AND CASTS ILIKE '%Salman Khan%'
  AND RELEASE_YEAR > EXTRACT(YEAR FROM CURRENT_DATE) - 10;


-- 13. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
SELECT
    ACTOR,
    COUNT(*) AS MOVIE_COUNT
FROM (
    SELECT
        COUNTRY,
        TYPE,
        TRIM(UNNEST(STRING_TO_ARRAY(CASTS, ','))) AS ACTOR
    FROM NETFLIX
) AS subquery
WHERE COUNTRY ILIKE '%India%'
  AND TYPE = 'Movie'
  AND ACTOR != 'UNKNOWN'
GROUP BY ACTOR
ORDER BY MOVIE_COUNT DESC
LIMIT 10;


-- 14. Find the Top 5 Directors for each year based on the number of movies they released.
WITH Unnested_List AS (
    SELECT
        TRIM(UNNEST(STRING_TO_ARRAY(director, ','))) AS director_name,
        release_year
    FROM NETFLIX
    WHERE director != 'UNKNOWN'
),
Yearly_Counts AS (
    SELECT
        director_name,
        release_year,
        COUNT(*) AS movie_count
    FROM Unnested_List
    GROUP BY director_name, release_year
),
Ranked_Directors AS (
    SELECT
        director_name,
        release_year,
        movie_count,
        DENSE_RANK() OVER (PARTITION BY release_year ORDER BY movie_count DESC) AS rank
    FROM Yearly_Counts
)
SELECT *
FROM Ranked_Directors
WHERE rank <= 5
ORDER BY release_year DESC, rank ASC;


-- 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
SELECT
    category,
    COUNT(*) AS content_count
FROM (
    SELECT
        CASE
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM NETFLIX
) AS categorized_content
GROUP BY category;
