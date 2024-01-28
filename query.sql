--Most common job titles
SELECT Simple_Work_Position_Names, COUNT(*) as Count
FROM job_data
GROUP BY Simple_Work_Position_Names
ORDER BY Count DESC;

--
SELECT Search_Term, COUNT(*) as Count
FROM job_data
WHERE Search_Term <> 'FALSE'
GROUP BY Search_Term
ORDER BY Count DESC;

--Companies with the most job listings
SELECT Company, COUNT(*) as Count
FROM job_data
GROUP BY Company
ORDER BY Count DESC;

-- Average validity period for job listings
SELECT AVG(DATEDIFF(day, Date_posted, Valid_until)) as AvgValidityDays 
FROM job_data;

--Most common education requirements
SELECT Education_requirements, COUNT(*) as Count
FROM job_data
GROUP BY Education_requirements
ORDER BY Count DESC;

--Seniority level distribution
SELECT Seniority, COUNT(*) as Count
FROM job_data
GROUP BY Seniority
ORDER BY Count DESC;

--Most common locations
SELECT Location, COUNT(*) as Count
FROM job_data
GROUP BY Location
ORDER BY Count DESC;

--Most frequently mentioned technologies (Top 15)
WITH TechList AS (
  SELECT 
    LTRIM(RTRIM(value)) AS tech
  FROM job_data
  CROSS APPLY STRING_SPLIT(LOWER(technology), ',')
)

SELECT TOP 15
  tech,
  COUNT(*) AS tech_frequency
FROM TechList
GROUP BY tech
ORDER BY tech_frequency DESC;

--Job listings with online interview mention
SELECT COUNT(*) as OnlineInterviewCount
FROM job_data
WHERE Online_Interview = 1;

--Acceptance rate for student applicants
SELECT COUNT(*) as Accepts_Students_Count
FROM job_data
WHERE Accepts_Students = 1;

--Most common technology for each job title
WITH TechList AS (
  SELECT 
    Simple_Work_Position_Names,
    LTRIM(RTRIM(value)) AS tech
  FROM job_data
  CROSS APPLY STRING_SPLIT(LOWER(technology), ',')
)

SELECT 
  Simple_Work_Position_Names,
  tech,
  COUNT(*) AS tech_frequency
FROM TechList
WHERE tech <> 'n/a'
GROUP BY Simple_Work_Position_Names, tech
ORDER BY Simple_Work_Position_Names, tech_frequency DESC;

--
WITH TechList AS (
  SELECT 
    Search_Term,
    LTRIM(RTRIM(value)) AS tech
  FROM job_data
  CROSS APPLY STRING_SPLIT(LOWER(technology), ',')
)

SELECT 
  Search_Term,
  tech,
  COUNT(*) AS tech_frequency
FROM TechList
WHERE tech <> 'n/a' AND Search_Term <> 'FALSE'
GROUP BY Search_Term, tech
ORDER BY Search_Term, tech_frequency DESC;

--Top 5 skills per seniority
WITH TechListWithRank AS (
  SELECT 
    seniority,
    LTRIM(RTRIM(value)) AS tech,
    ROW_NUMBER() OVER (PARTITION BY seniority ORDER BY COUNT(*) DESC) AS skill_rank
  FROM job_data
  CROSS APPLY STRING_SPLIT(LOWER(Technology), ',')
  WHERE LTRIM(RTRIM(value)) <> 'N/A'
  GROUP BY seniority, LTRIM(RTRIM(value))
)

SELECT 
  seniority,
  tech,
  COUNT(*) AS tech_frequency
FROM TechListWithRank
WHERE skill_rank <= 5
GROUP BY seniority, tech
ORDER BY seniority, tech_frequency DESC;