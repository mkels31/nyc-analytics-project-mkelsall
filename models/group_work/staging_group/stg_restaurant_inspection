-- Clean and standardize Restaurant Inspection Results
-- One row per inspection result

WITH source AS (
SELECT *
FROM {{ source('raw', 'restaurant_inspection_results') }}
),

cleaned AS (
SELECT
-- Keep all other columns except ones we are transforming
* EXCEPT (
action,
bbl,
bin,
boro,
building,
camis,
census_tract,
community_board,
council_district,
critical_flag,
cuisine_description,
dba,
grade,
grade_date,
inspection_date,
inspection_type,
latitude,
longitude,
nta,
phone,
record_date,
score,
street,
violation_code,
violation_description
),



-- Date/Time
CAST(inspection_date AS TIMESTAMP) AS inspection_date,
CAST(grade_date AS TIMESTAMP) AS grade_date,
CAST(record_date AS TIMESTAMP) AS record_date,

-- Request details
CAST(action AS STRING) AS action,
CAST(bbl AS STRING) AS bbl,
CAST(bin AS STRING) AS bin,
CAST(building AS STRING) AS building,
CAST(camis AS STRING) AS camis,
CAST(census_tract AS STRING) AS census_tract,
CAST(community_board AS STRING) AS community_board,
CAST(council_district AS STRING) AS council_district,
CAST(critical_flag AS STRING) AS critical_flag,
CAST(cuisine_description AS STRING) AS cuisine_description,
CAST(dba AS STRING) AS dba,
CAST(grade AS STRING) AS grade,
CAST(nta AS STRING) AS nta,
CAST(phone AS STRING) AS phone,
CAST(inspection_type AS STRING) AS inspection_type,
CAST(score AS NUMERIC) AS score,
CAST(street AS STRING) AS street,
CAST(violation_code AS STRING) AS violation_code,
CAST(violation_description AS STRING) AS violation_description


-- Standardize borough
CASE
WHEN UPPER(TRIM(boro)) IN ('MANHATTAN', 'NEW YORK COUNTY') THEN 'Manhattan'
WHEN UPPER(TRIM(boro)) IN ('BRONX', 'THE BRONX') THEN 'Bronx'
WHEN UPPER(TRIM(boro)) IN ('BROOKLYN', 'KINGS COUNTY') THEN 'Brooklyn'
WHEN UPPER(TRIM(boro)) IN ('QUEENS', 'QUEEN', 'QUEENS COUNTY') THEN 'Queens'
WHEN UPPER(TRIM(boro)) IN ('STATEN ISLAND', 'RICHMOND COUNTY') THEN 'Staten Island'
ELSE 'Unknown'
END AS borough,


-- Address + coordinates
CAST(latitude AS FLOAT64) AS latitude,
CAST(longitude AS FLOAT64) AS longitude,

-- Metadata
CURRENT_TIMESTAMP() AS _stg_loaded_at

FROM source

-- Filters (clean dataset)
WHERE inspection_date IS NOT NULL
AND DATE(SAFE_CAST(inspection_date AS TIMESTAMP)) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 YEAR)
AND borough IS NOT NULL


)

SELECT *
FROM cleaned

