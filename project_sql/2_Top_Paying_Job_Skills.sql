/*Question:  What are the top paying skills for Data Analyst jobs
*/

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


/*
 The skills that are most frequently associated with high-paying jobs are:
  SQL, Python, R, Azure, Databricks, GO
  */