# Introduction
# Project Title: Analysis of 2023 Job Data Set

## 1. Introduction
This project aims to uncover valuable insights into the Data Analyst job market for remote positions in 2023. By leveraging PostgreSQL and SQL, I performed various analyses to answer key questions such as identifying the top-paying jobs, the most sought-after skills, and the optimal skills for maximizing job opportunities and salary potential.

Check out the SQL here here in [project_sql folder](/project_sql/)

## 2. Background
The questions I aimed to answer with this project include:
1. **Top Paying Jobs**: Which jobs offer the highest salaries?
2. **Top Paying Skills**: Which skills offer the highest salaries?
3. **Top Demanded Skills**: What are the most sought-after skills in the job market?
4. **Top Paying Skills**: Which skills are associated with the highest paying jobs?
5. **Optimal Skills**: What skills should one focus on to maximize job opportunities and salary potential?

## 3. Tools I Used
- **SQL**: To query and analyze the data.
- **PostgreSQL**: To store and manage the data set.
- **VS Code**: As the code editor for writing and running SQL queries.
- **Git**: For version control to manage the project's development.
- **GitHub**: To host the project repository and collaborate on code.

## 4. Analysis
### 1. Top Paying Data Analyst Jobs
I analyzed and filtered the **Data analyst** remote positions based on the average annual salary. The query identify the highest paying jobs in 2023.

``` sql
SELECT
    job_id,
    job_title,
    job_title_short,
    job_location,
    job_country,
    salary_year_avg,
    job_posted_date,
    name AS Company_Name
FROM job_postings_fact
LEFT JOIN company_dim
ON job_postings_fact.company_id = company_dim.company_id
WHERE job_title_short='Data Analyst' AND 
    job_location='Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC

LIMIT 10;
```
The highest-paying Data Analyst job is at Mantys in India, offering $650,000 annually. In the US, top roles like "Director of Analytics" at Meta and "Associate Director - Data Insights" at AT&T offer $336,500 and $255,829.5 respectively. High salaries reflect the value of advanced analytics and leadership skills.

![Top Paying Roles](/assets/top_paying_jobs.png)
*This bar chart visualize the top paying jobs.*

### 2. Skills for Top Paying Job

The skills that are most frequently associated with high-paying Data Analyst Remote jobs include SQL, Python, R, Azure, Databricks, and Go. These skills are highly valued in the job market and are often linked to roles with higher salary potentials.
```sql
WITH top_paying_jobs AS(
    SELECT
        job_id,
        job_title,
        job_title_short,
        salary_year_avg,
        name AS Company_Name
    FROM job_postings_fact
    LEFT JOIN company_dim
    ON job_postings_fact.company_id = company_dim.company_id
    WHERE job_title_short='Data Analyst' AND 
        job_location='Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10
)
SELECT
    skills_dim.skills,
    COUNT(skills_job_dim.skill_id) AS skill_count,
    ROUND(AVG(top_paying_jobs.salary_year_avg), 0) AS avg_salary
FROM top_paying_jobs
INNER JOIN skills_job_dim
ON top_paying_jobs.job_id= skills_job_dim.job_id
INNER JOIN skills_dim
ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY
    skills_dim.skills
ORDER BY
    skill_count DESC;
```


| Skill       | Skill Count | Average Salary ($) |
|-------------|--------------|--------------------|
| sql         | 8            | 207,320            |
| python      | 7            | 205,937            |
| tableau     | 6            | 214,260            |
| r           | 4            | 215,313            |
| snowflake   | 3            | 193,436            |
| pandas      | 3            | 215,610            |
| excel       | 3            | 215,610            |
| atlassian   | 2            | 189,155            |
| jira        | 2            | 189,155            |
| aws         | 2            | 222,569            |


![Top Paying Skills](/assets/skills.png)
*This bar chart visualize the count of skills for high paying jobs.*

### 3. Top In-Demand Skills For Data Analysts
This query help me identify the top skills in demand for data analyst positions.


```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id

INNER JOIN skills_dim
ON skills_job_dim.skill_id=skills_dim.skill_id
WHERE
    job_title_short='Data Analyst' AND job_work_from_home=TRUE
GROUP BY
    skills 
ORDER BY
    demand_count DESC
LIMIT 10
```

Here's the breakdown of the most demanded skills for data analysts:

- **SQL and Excel** lead the demand, highlighting the necessity for robust data processing and spreadsheet manipulation skills.

- **Programming Languages** like Python and **Visualization Tools** such as Tableau and Power BI are crucial, underscoring the growing importance of technical skills in data analysis and storytelling.

- **Statistical Analysis Tools** including R and SAS have moderate demand, indicating their specific yet significant role in advanced data analysis.

- **Niche Skills** like Looker, Azure, and PowerPoint are less in demand but remain relevant for specialized tasks and supplementary analysis needs.

| skills     |   demand_count |
|:-----------|---------------:|
| sql        |           7291 |
| excel      |           4611 |
| python     |           4330 |
| tableau    |           3745 |
| power bi   |           2609 |
| r          |           2142 |
| sas        |           1866 |
| looker     |            868 |
| azure      |            821 |
| powerpoint |            819 |




### 4. Top Paying Skills
Exploring average annual salaries based on the skills for Data Analyst remote roles.

```sql
SELECT 
    skills,
   -- COUNT(skills_job_dim.job_id) AS demand_count,
   ROUND (AVG(salary_year_avg),0) AS avg_yearly_salary
FROM job_postings_fact
INNER JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id

INNER JOIN skills_dim
ON skills_job_dim.skill_id=skills_dim.skill_id
WHERE
    job_title_short='Data Analyst' AND salary_year_avg IS NOT NULL
    
    AND job_work_from_home=TRUE
GROUP BY
    skills
ORDER BY
    avg_yearly_salary  DESC
LIMIT 25
```

| Skill       | Average Yearly Salary ($) |
|-------------|---------------------------|
| PySpark     | 208,172                   |
| Bitbucket   | 189,155                   |
| Couchbase   | 160,515                   |
| Watson      | 160,515                   |
| DataRobot   | 155,486                   |
| GitLab      | 154,500                   |
| Swift       | 153,750                   |
| Jupyter     | 152,777                   |
| Pandas      | 151,821                   |
| Elasticsearch| 145,000                  |
*Table of the top 10 highest paying skills*



### 5. Most Optimal Skills to Learn
I identified the skills that job seekers should focus on to maximize their job opportunities and salary potential. This involved analyzing the intersection of high-demand and high-paying skills.
```sql
WITH skill_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim
        ON job_postings_fact.job_id = skills_job_dim.job_id

    INNER JOIN skills_dim
    ON skills_job_dim.skill_id=skills_dim.skill_id
    WHERE
        job_title_short='Data Analyst' AND job_work_from_home=TRUE AND salary_year_avg IS NOT NULL
    GROUP BY
        skills_dim.skill_id


), avg_salary AS (
        SELECT 
        skills_job_dim.skill_id,
    -- COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND (AVG(salary_year_avg),0) AS avg_yearly_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim
        ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim
    ON skills_job_dim.skill_id=skills_dim.skill_id
    WHERE
        job_title_short='Data Analyst' AND salary_year_avg IS NOT NULL
        AND job_work_from_home=TRUE
    GROUP BY
        skills_job_dim.skill_id
    
)

SELECT 
    avg_salary.skill_id,
    skill_demand.skills,
    demand_count,
    avg_yearly_salary
FROM skill_demand
INNER JOIN avg_salary ON skill_demand.skill_id = avg_salary.skill_id
WHERE
    demand_count>10
ORDER BY
        avg_yearly_salary DESC,
    demand_count DESC
LIMIT 25
```

- **Python (236)**: The highest in demand, indicating its critical role in data analysis for scripting, data manipulation, and machine learning.
- **Tableau (230)**: Reflects the importance of data visualization and dashboard creation in data analysis.
- **R (148)**: Signifies its use in statistical analysis and data modeling, essential for analytical tasks.
- **SAS (63)**: Used for advanced analytics, business intelligence, and data management.


| Skill       | Demand Count | Average Yearly Salary ($) |
|-------------|---------------|---------------------------|
| go          | 27            | 115,320                   |
| confluence  | 11            | 114,210                   |
| hadoop      | 22            | 113,193                   |
| snowflake   | 37            | 112,948                   |
| azure       | 34            | 111,225                   |
| bigquery    | 13            | 109,654                   |
| aws         | 32            | 108,317                   |
| java        | 17            | 106,906                   |
| ssis        | 12            | 106,683                   |
| jira        | 20            | 104,918                   |
| oracle      | 37            | 104,534                   |
| looker      | 49            | 103,795                   |
| nosql       | 13            | 101,414                   |
| python      | 236           | 101,397                   |
| r           | 148           | 100,499                   |

*This table shows the most optimal skills a data analyst should learn*


## 5. What I Learned
I improved my grip over sql while doing this project specifically with:

#### SQL Queries:
- **GROUP BY**: Used for aggregating data by specific columns.
- **Aggregate Functions**: Applied COUNT and AVG to analyze data trends.
- **CTEs (Common Table Expressions)**: Employed for simplifying complex queries and improving readability.
- **JOINs**: Leveraged INNER JOIN, LEFT JOIN to combine data from multiple tables.

#### Data Analysis:
- **Identifying Trends**: Discovered high-demand and high-paying skills for data analysts.
- **Salary Insights**: Analyzed which skills are associated with higher salaries.
- **Demand Patterns**: Understood the market demand for various data analyst skills.

## 6. Conclusion
This project, "Analysis of 2023 Job Data Set," provided an in-depth examination of the job market for Data Analyst roles, focusing on remote positions. By leveraging PostgreSQL and SQL, I was able to extract, analyze, and interpret significant trends from the dataset, offering valuable insights into the top-paying jobs, the most sought-after skills, and the optimal skills for maximizing job opportunities and salary potential.

### Key Findings

1. **Top-Paying Jobs**:
   - The highest paying Data Analyst remote positions in 2023 were identified, with specific emphasis on roles requiring advanced technical skills and experience. These positions were predominantly associated with companies that highly value data-driven decision-making and innovative data solutions.

2. **Top-Paying Skills**:
   - Skills such as PySpark, Bitbucket, Couchbase, and Watson were found to command the highest salaries. These skills are crucial for handling large-scale data processing, version control, advanced database management, and artificial intelligence, respectively.

3. **Top Demanded Skills**:
   - The analysis revealed that Python, SQL, and Tableau are the most in-demand skills for Data Analysts. These tools are fundamental for data manipulation, querying, and visualization, making them indispensable in the data analysis workflow.

4. **Optimal Skills for Maximizing Opportunities**:
   - By combining high-demand and high-paying skills, it was evident that learning and mastering Python, Tableau, and R could significantly enhance a data analyst's job prospects and salary potential. Additionally, proficiency in cloud platforms like Azure and AWS is becoming increasingly valuable.

### Tools and Techniques

Throughout the project, several SQL techniques and tools were employed:
- **GROUP BY and Aggregate Functions**: To aggregate data and compute average salaries and skill demand counts.
- **Common Table Expressions (CTEs)**: For organizing complex queries and improving code readability.
- **JOINs**: To combine data from multiple tables and derive comprehensive insights.
- **SQL Queries**: To filter, sort, and limit data, focusing on the most relevant information.

### Personal Growth and Learning

This project provided substantial learning opportunities, particularly in:
- **SQL Proficiency**: Enhanced my ability to write complex queries, use aggregate functions, and manage data using PostgreSQL.
- **Data Analysis**: Improved my understanding of identifying market trends, analyzing salary data, and determining skill demand.
- **Technical Skills**: Gained insights into the importance of various data analysis tools and technologies, and their impact on the job market.


## 6. Conclusion


### Key Findings

1. **Top-Paying Data Analyst Jobs**: The highest-paying remote Data Analyst job is at Mantys in India, offering $650,000 annually.
2. **Skills for Top-Paying Jobs**: High-paying Data Analyst jobs require proficiency in SQL Python and Tableau.
3. **Most In-Demand Skills**: SQL is the most demanded skill in the Data Analyst job market, followed by Python and Tableau.
4. **Skills with Higher Salaries**: Specialized skills like PySpark and Couchbase command the highest average salaries.
5. **Optimal Skills for Job Market Value**: Combining high-demand and high-paying skills such as Python, Tableau, and SQL maximizes job prospects and salary potential.

### Closing Thoughts

The project highlighted the importance of skills like Python, SQL, and Tableau in the Data Analyst job market. Continuous learning and staying updated with the latest technologies are crucial for career growth. This project enhanced my technical and analytical skills and provided valuable insights into the current job market dynamics for Data Analysts.
