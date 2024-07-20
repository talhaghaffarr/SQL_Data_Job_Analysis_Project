-- Get jobs and companies from January
SELECT
job_title_short,
company_id,
job_location
FROM january_jobs

UNION ALL
-- Get jobs and companies from February
SELECT
job_title_short,
company_id,
job_location
FROM february_jobs


UNION ALL

-- Get jobs and companies from March
SELECT
job_title_short,
company_id,
job_location
FROM march_jobs


-- Problem 8

/*
Find job postings from the first quarter that have a salary greater than $7ØK
— Combine job posting tables from the first quarter of 2023 (Jan—Mar)
- Gets job postings with an average yearly salary > $70,000
*/

SELECT 
    quarter_1_job_postings.job_title_short,
    quarter_1_job_postings.job_location,
    quarter_1_job_postings.job_via,
    quarter_1_job_postings.job_posted_date,
    quarter_1_job_postings.salary_year_avg
FROM(
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
) AS quarter_1_job_postings
WHERE quarter_1_job_postings.salary_year_avg>70000 AND 
quarter_1_job_postings.job_title_short='Data Analyst'
ORDER BY quarter_1_job_postings.salary_year_avg DESC