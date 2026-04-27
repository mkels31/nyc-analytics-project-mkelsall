-- Clean and standardize 311 rodent complaint data
-- One row per complaint

WITH source AS (
SELECT *
FROM {{ source('raw', 'rodent_complaints') }}
),

cleaned AS (
SELECT
-- Keep all other columns except ones we are transforming
* EXCEPT (
address_type,
agency,
agency_name,
borough,
city,
community_board,
complaint_type,
created_date,
descriptor,
latitude,
location_type,
longitude,
park_borough
),



-- Date/Time
CAST(created_date AS TIMESTAMP) AS created_date,

-- Request details
CAST(agency AS STRING) AS agency,
CAST(agency_name AS STRING) AS agency_name,
CAST(complaint_type AS STRING) AS complaint_type,
CAST(descriptor AS STRING) AS descriptor,
CAST(address_type AS STRING) AS address_type,
CAST(community_board AS STRING) AS community_board,
CAST(city AS STRING) AS city,
CAST(location_type AS STRING) AS location_type,

-- Standardize borough
CASE
WHEN UPPER(TRIM(borough)) IN ('MANHATTAN', 'NEW YORK COUNTY') THEN 'Manhattan'
WHEN UPPER(TRIM(borough)) IN ('BRONX', 'THE BRONX') THEN 'Bronx'
WHEN UPPER(TRIM(borough)) IN ('BROOKLYN', 'KINGS COUNTY') THEN 'Brooklyn'
WHEN UPPER(TRIM(borough)) IN ('QUEENS', 'QUEEN', 'QUEENS COUNTY') THEN 'Queens'
WHEN UPPER(TRIM(borough)) IN ('STATEN ISLAND', 'RICHMOND COUNTY') THEN 'Staten Island'
ELSE 'Unknown'
END AS borough,

-- Standardize borough
CASE
WHEN UPPER(TRIM(park_borough)) IN ('MANHATTAN', 'NEW YORK COUNTY') THEN 'Manhattan'
WHEN UPPER(TRIM(park_borough)) IN ('BRONX', 'THE BRONX') THEN 'Bronx'
WHEN UPPER(TRIM(park_borough)) IN ('BROOKLYN', 'KINGS COUNTY') THEN 'Brooklyn'
WHEN UPPER(TRIM(park_borough)) IN ('QUEENS', 'QUEEN', 'QUEENS COUNTY') THEN 'Queens'
WHEN UPPER(TRIM(park_borough)) IN ('STATEN ISLAND', 'RICHMOND COUNTY') THEN 'Staten Island'
ELSE 'Unknown'
END AS park_borough,

-- Address + coordinates
CAST(latitude AS FLOAT64) AS latitude,
CAST(longitude AS FLOAT64) AS longitude,

-- Metadata
CURRENT_TIMESTAMP() AS _stg_loaded_at

FROM source

-- Filters (clean dataset)
WHERE created_date IS NOT NULL
AND DATE(SAFE_CAST(created_date AS TIMESTAMP)) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 YEAR)
AND borough IS NOT NULL


)

SELECT *
FROM cleaned

