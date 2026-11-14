USE zero_hunger;

-- Q: Which regions have the highest reported poverty rates during a specified period?

/*
- compare the same country, administrative level, source,
- indicator definition, unit and reporting period
*/

SET @country_id = NULL;
SET @administrative_level = NULL;
SET @poverty_source_id = NULL;
SET @poverty_indicator = NULL;
SET @poverty_definition = NULL;
SET @percentage_unit = NULL;
SET @period_start = NULL;
SET @period_end = NULL;

SELECT r.region_id,
       r.name           AS region_name,
       e.value          AS poverty_rate_percentage,
       e.period_start,
       e.period_end,
       ds.dataset_title AS data_source
FROM economic_indicator AS e
         JOIN region AS r
              ON r.region_id = e.region_id
         JOIN data_source AS ds
              ON ds.source_id = e.source_id
WHERE r.country_id = @country_id
  AND r.administrative_level = @administrative_level
  AND e.source_id = @poverty_source_id
  AND e.indicator_type = @poverty_indicator
  AND e.measurement_definition = @poverty_definition
  AND e.unit = @percentage_unit
  AND e.period_start = @period_start
  AND e.period_end = @period_end
ORDER BY e.value DESC,
         r.name,
         r.region_id;