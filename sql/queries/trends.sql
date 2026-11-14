USE zero_hunger;

-- Q: How have food-insecurity levels in a selected region changed over a specified date range?

/*
- uses the latest published current assessment for each period.
- only includes periods fully within the selected date range.
*/

SET @region_id = NULL;
SET @population_scope = NULL;
SET @range_start = NULL;
SET @range_end = NULL;

WITH ranked_assessments
         AS (SELECT a.*,
                    ROW_NUMBER() OVER (
                        PARTITION BY a.period_start, a.period_end
                        ORDER BY
                            a.publication_date DESC,
                            a.analysis_date DESC,
                            a.assessment_id DESC
                        ) AS version_rank
             FROM food_security_assessment AS a
             WHERE a.region_id = @region_id
               AND a.population_scope = @population_scope
               AND a.assessment_type = 'current'
               AND a.period_start >= @range_start
               AND a.period_end <= @range_end)
SELECT a.assessment_id,
       a.period_start,
       a.period_end,
       a.assessed_population,
       ds.dataset_title AS data_source,
       ROUND(
               100.0 * SUM(
                       IF(ph.phase_number >= 3, apr.affected_population, 0)
                       ) / NULLIF(a.assessed_population, 0),
               2
       )                AS phase_3_plus_percentage
FROM ranked_assessments AS a
         JOIN assessment_phase_result AS apr
              ON apr.assessment_id = a.assessment_id
         JOIN ipc_phase AS ph
              ON ph.phase_id = apr.phase_id
         JOIN data_source AS ds
              ON ds.source_id = a.source_id
WHERE a.version_rank = 1
GROUP BY a.assessment_id,
         a.period_start,
         a.period_end,
         a.assessed_population,
         ds.dataset_title
HAVING COUNT(DISTINCT ph.phase_number) = 5
ORDER BY a.period_start, a.period_end;