/* Question: WHat are the most optimal skills to learn?
i.e Skills which have high demand and high slalary
*/



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