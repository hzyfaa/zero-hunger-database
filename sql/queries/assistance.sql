USE zero_hunger;

-- Q: Which organizations have active assistance programs in a particular region?

/*
- returns one row per organization
- assumes active programs use the status value 'active'
- set the region ID using an existing record before running
*/

SET @region_id = NULL;
SET @as_of_date = CURRENT_DATE();

SELECT DISTINCT o.organization_id, o.name AS organization_name, o.website, o.contact_email
FROM organization AS o
         JOIN program AS p ON p.organization_id = o.organization_id
         JOIN program_region AS pr ON pr.program_id = p.program_id
WHERE pr.region_id = @region_id
  AND p.status = 'active'
  AND p.start_date <= @as_of_date
  AND (p.end_date IS NULL OR p.end_date >= @as_of_date)
ORDER BY o.name, o.organization_id;