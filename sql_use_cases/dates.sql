SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' date_time,
    EXTRACT(MONTH FROM job_posted_date)  AS month_posted,
    EXTRACT(YEAR FROM job_posted_date)  AS year_posted
FROM job_postings_fact
LIMIT 5



SELECT
    COUNT(job_id) AS job_posted_count,
    EXTRACT(MONTH FROM job_posted_date)  AS month_posted
FROM job_postings_fact
WHERE job_title_short ='Data Analyst'
GROUP BY month_posted
ORDER BY job_posted_count DESC;


--Job posting table for january

CREATE TABLE january_jobs AS 
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH from job_posted_date)=1;

-- Feb
CREATE TABLE february_jobs AS 
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH from job_posted_date) = 2;

-- March
CREATE TABLE march_jobs AS 
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH from job_posted_date) = 3;

--April
CREATE TABLE april_jobs AS 
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH from job_posted_date) = 4;

CREATE TABLE may_jobs AS 
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH from job_posted_date) = 5;

CREATE TABLE june_jobs AS 
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH from job_posted_date) = 6;

CREATE TABLE july_jobs AS 
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH from job_posted_date) = 7;

CREATE TABLE august_jobs AS 
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH from job_posted_date) = 8;

CREATE TABLE september_jobs AS 
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH from job_posted_date) = 9;

CREATE TABLE october_jobs AS 
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH from job_posted_date) = 10;

CREATE TABLE november_jobs AS 
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH from job_posted_date) = 11;

CREATE TABLE december_jobs AS 
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH from job_posted_date) = 12;


select *
from march_jobs
ORDER BY job_posted_date