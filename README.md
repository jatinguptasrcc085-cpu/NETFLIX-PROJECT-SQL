# NETFLIX-PROJECT-SQL
# 🎬 Netflix Movies & TV Shows Data Analysis using SQL

## 📌 Project Overview
In this project, I used **PostgreSQL** to analyze a dataset of Netflix movies and TV shows. The goal was to solve critical business problems regarding content distribution, creator trends, and platform insights. 

As a **Master of Economics** student, I approached this data to understand not just the *what*, but the *content strategy* behind the numbers—analyzing how Netflix balances its catalog across different regions and genres.

## 📂 Data Structure
The analysis is built on the `NETFLIX` table with the following schema:

```sql
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
```

## 🚀 Key Business Problems Solved
The SQL queries in this project address the following 15 business questions:

1.  **Content Distribution:** Count of Movies vs. TV Shows.
2.  **Rating Analysis:** Most common rating for Movies and TV Shows.
3.  **Yearly Highlights:** List of all movies released in 2020.
4.  **Geographical Insights:** Top 5 countries with the most content.
5.  **Recency Analysis:** Content added in the last 5 years.
6.  **Director Search:** All movies/TV shows by 'Rajiv Chilaka'.
7.  **Long-Form Content:** TV Shows with more than 5 seasons.
8.  **Genre Trends:** Total content items in each genre.
9.  **Market Strategy (India):** Average content released in India per month/year.
10. **Documentary Focus:** List of all documentaries.
11. **Data Auditing:** Finding content without a director.
12. **Actor Metrics:** 'Salman Khan' movies in the last 10 years.
13. **Local Talent:** Top 10 actors in Indian movies.
14. **Creator Consistency:** Top 5 directors by release count per year.
15. **Content Classification:** Categorizing content as 'Bad' (Violence) vs 'Good' using keyword analysis.

## 🛠️ Technical Skills Demonstrated

- **Advanced SQL Functions:** `CTE`, `DENSE_RANK`, `UNNEST`, `STRING_TO_ARRAY`.
- **Data Cleaning:** Handling NULL values (`COALESCE` logic) and date formatting (`TO_DATE`).
- **Text Analysis:** Using `SPLIT_PART` and string matching (`ILIKE`) for pattern recognition.
- **Aggregation:** Complex `GROUP BY` and filter logic.

## 📊 Sample Insights

* **Content Strategy:** Movies dominate the platform, but TV shows have seen a significant rise in production value and duration since 2018.
* **Regional Focus:** India and the US remain top contributors, with a specific spike in content addition during the holiday season (Q4).
* **Rating Trends:** `TV-MA` and `TV-14` are the most dominant ratings, indicating a shift towards mature audiences.

## 📜 Full Analysis Code
[**Click here to view the full SQL script**](https://github.com/[YourGitHubUsername]/Netflix_SQL_Analysis/blob/main/analysis.sql)

---

## 👤 Author
**JATIN GUPTA** 
**Master of Economics|Delhi School of Economics** 
**Bachelor in Economics|Shri Ram College of Commerce|**

- **Email:** jatinguptasrcc085@gmail.com

*Open to feedback and collaboration!*
