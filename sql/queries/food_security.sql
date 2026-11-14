USE zero_hunger;

-- Q: What percentage of a region’s assessed population is experiencing IPC phase 3 or above?

/*
- calculate the IPC phase 3+ percentage for one assessment.
- the assessed population is used as denominator.
- replace NULL with an existing assessment ID once data is available.
*/

SET @assessment_id = NULL;

SELECT fsa.assessment_id,
       r.name AS region_name,
       fsa.assessment_type,
       fsa.period_start,
       fsa.period_end,
       fsa.population_scope,
       fsa.assessed_population,

       SUM(IF(ph.phase_number >= 3, apr.affected_population, 0)
       )      AS phase_3_plus_population,

       ROUND(
               100.0 * SUM(IF(ph.phase_number >= 3, apr.affected_population, 0)
                       ) / NULLIF(fsa.assessed_population, 0), 2
       )      AS phase_3_plus_percentage

FROM food_security_assessment AS fsa
         JOIN region AS r ON r.region_id = fsa.region_id
         JOIN assessment_phase_result AS apr ON apr.assessment_id = fsa.assessment_id
         JOIN ipc_phase AS ph ON ph.phase_id = apr.phase_id

WHERE fsa.assessment_id = @assessment_id

GROUP BY fsa.assessment_id,
         r.name,
         fsa.assessment_type,
         fsa.period_start,
         fsa.period_end,
         fsa.population_scope,
         fsa.assessed_population

-- require all five phases so missing records are not treated as zero
HAVING COUNT(DISTINCT ph.phase_number) = 5;

-- Q: Which region has the highest percentage of its assessed population in IPC phase 3 or above?

/*
- compare the same country, administrative level, source release,
- reporting period and population scope. Return all tied regions.
*/

SET @country_id = NULL;
SET @administrative_level = NULL;
SET @assessment_source_id = NULL;
SET @period_start = NULL;
SET @period_end = NULL;
SET @population_scope = NULL;

WITH regional_rates AS
         (SELECT r.region_id,
                 r.name AS region_name,
                 100.0 * SUM(
                         IF(ph.phase_number >= 3, apr.affected_population, 0)
                         ) / NULLIF(MAX(a.assessed_population), 0)
                        AS phase_3_plus_percentage

          FROM region AS r
                   JOIN food_security_assessment AS a
                        ON a.region_id = r.region_id
                   JOIN assessment_phase_result AS apr
                        ON apr.assessment_id = a.assessment_id
                   JOIN ipc_phase AS ph
                        ON ph.phase_id = apr.phase_id

          WHERE r.country_id = @country_id
            AND r.administrative_level = @administrative_level
            AND a.source_id = @assessment_source_id
            AND a.assessment_type = 'current'
            AND a.period_start = @period_start
            AND a.period_end = @period_end
            AND a.population_scope = @population_scope

          GROUP BY r.region_id,
                   r.name

          -- exclude incomplete assessment groups
          HAVING COUNT(DISTINCT a.assessment_id) = 1
             AND COUNT(DISTINCT ph.phase_number) = 5)

SELECT region_id,
       region_name,
       ROUND(phase_3_plus_percentage, 2)
           AS phase_3_plus_percentage
FROM regional_rates
WHERE phase_3_plus_percentage = (SELECT MAX(phase_3_plus_percentage)
                                 FROM regional_rates)
ORDER BY region_name, region_id;