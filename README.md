# Data Job Listings Analysis

## Table of Contents

- [Project Overview](#project-overview)
- [Data Sources](#data-sources)
- [Tools](#tools)
- [Data Collection](#data-collection)
- [Data Cleaning](#data-cleaning)
- [Exploratory Data Analysis](#exploratory-data-analysis)
- [Data Analysis](#data-analysis)
- [Data Visualization](#data-visualization)
- [Conclusion](#conclusion)

### Project Overview
---
In this data analysis project, the goal is to examine job listings data sourced from the website [https://www.helloworld.rs](https://www.helloworld.rs) and uncover valuable insights into the employment landscape. Through a comprehensive analysis of different facets of job listings, the aim is to discern patterns, draw actionable insights, and enhance understanding of job market dynamics.

<img src="https://i.imgur.com/NoqfogK.jpeg" height="80%" width="80%" alt="Job Overview Page"/>

### Data Sources
---
The primary dataset for this analysis is the `job_data.csv` file, which includes detailed information about each job listing. The job listings data was collected from the website https://www.helloworld.rs through web scraping in Python, and the corresponding code can be found in the `web_scraping.py` file.

### Tools
---
- Python - Data Collection
- Microsoft Excel - Data Cleaning
- Microsoft SQL Server - Data Analysis
- Microsoft Power BI - Data Visualization

### Data Collection
---
### Tools Used

- **Python**
- **Libraries:**
  - **Beautiful Soup**
  - **Requests**
  - **CSV**
  - **JSON**
  - **re (Regular Expressions)**

### Data Collection Process

1. **Web Scraping Script:** The data collection process is facilitated by a Python script named `web_scraping.py`. This script employs the following key libraries:
   - **Beautiful Soup:** Used for HTML parsing.
   - **Requests:** Utilized for making HTTP requests.
   - **JSON:** Handling JSON data.
   - **re (Regular Expressions):** Employed for pattern matching.
   - **CSV:** Used for reading and writing CSV files.

2. **Source Website:** Job listings data is extracted from the website [https://www.helloworld.rs](https://www.helloworld.rs).

### Data Cleaning
---
During the initial data preparation phase, the following tasks were executed:

1. Loading and inspecting the data.
2. Removing duplicates.
3. Cleaning and formatting the data.
4. Normalizing the data.
5. Introducing two new columns, namely 'Simple Work Position Names' and 'Search Term' to facilitate easier data navigation.

Both original and cleaned data can be found in the `job_data_original.csv` and `job_data.csv` files.

### Exploratory Data Analysis
---
EDA involved exploring the data to answer key questions, such as:

1. What are the most common job titles, and how frequently do they occur?
2. Which companies have the highest number of job listings?
3. What is the average validity period for job listings?
4. What are the most common education requirements for various job positions?
5. How is the distribution of seniority levels in the job listings?
6. Where are the most common locations for job opportunities?
7. What are the most frequently mentioned technologies across all job listings?
8. How many job listings mention an online interview?
9. What is the acceptance rate for student applicants in job listings?
10. What are the most common technologies associated with each job title?
11. What are the most common technologies associated with each seniority level?

### Data Analysis
---
In this section, exploration of key aspects in the job listings dataset is carried out through SQL queries. The focus is placed on extracting meaningful insights, uncovering patterns, and understanding the distribution of information. Presented below are a couple of examples that delve into the technology landscape within the dataset.

### Example Queries

1. **Most Frequently Mentioned Technologies (Top 15):**
   - Identifying the top 15 technologies mentioned across all job listings.

2. **Top 5 Skills Per Seniority:**
   - Ranking and presenting the top 5 skills associated with different seniority levels.

### Code Explanation

```sql
-- Most frequently mentioned technologies (Top 15)
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
```
- This query extracts and counts the frequency of individual technologies mentioned in the "technology" column of the job_data table.
- The STRING_SPLIT function is used to split the comma-separated values in the "technology" column into rows.
- The result is then grouped by technology and the count of each technology is calculated.
- Finally, the top 15 most frequently mentioned technologies are selected and displayed in descending order of frequency.

```sql
-- Top 5 skills per seniority
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
```
- This query ranks and identifies the top 5 skills for each seniority level in the job_data table.
- The STRING_SPLIT function is used to split the comma-separated values in the "Technology" column into rows.
- The ROW_NUMBER() function is employed to assign a rank to each skill within its corresponding seniority group, based on the frequency (count) of each skill.
- The results are filtered to exclude 'N/A' values, and each skill is assigned a rank based on its frequency within each seniority level.
- The final result displays the seniority level, associated skills, their frequencies, and is ordered by seniority and technology frequency in descending order, focusing specifically on the top 5 skills for each seniority level.

### Data Visualization
---
The Power BI dashboard offers an interactive overview of key metrics and trends within the dataset, enabling exploration and analysis of various aspects of job listings, such as:

- Job title ratios, showcasing the distribution of job titles.
- Geographic distribution of job opportunities.
- Seniority levels in demand.
- Education requirements across different positions.

The dashboard can be found in the `visualization.pbix` or `visualization.pdf` files.

### Conclusion
---
Thank you for taking the time to explore my data job listings analysis project. I appreciate your interest and hope you find the insights valuable. If you have any questions or feedback, feel free to reach out.
