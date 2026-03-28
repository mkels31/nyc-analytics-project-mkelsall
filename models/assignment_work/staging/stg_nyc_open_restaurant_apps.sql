-- Clean and standardize 311 DOT service request data
-- One row per service request

WITH source AS (
   SELECT * FROM {{ source('raw', 'source_nyc_open_restaurant_apps') }}
), -- Easier to refer to the dbt reference to a long name table this way

cleaned AS (
   SELECT
       -- Get all columns from source, except ones we're transforming below
       -- To do cleaning on them or explicitly cast them as types just in case
       * EXCEPT (
           time_of_submission,
           zip,
                    borough,
           street,
           latitude,
           longitude,
           approved_for_roadway_seating,
           approved_for_sidewalk_seating,
           bbl,
           bin,
           bulding_number,
           business_address,
           census_tract,
           community_board,
           council_district,
           doing_business_as_dba,
           food_service_establishment,
           --globalid,
           healthcompliance_terms,
           landmark_district_or_building,
           landmarkdistrict_terms,
           legal_business_name,
           nta,
           objectid,
           qualify_alcohol,
           restaurant_name,
           roadway_dimensions_area,
           roadway_dimensions_length,
           roadway_dimensions_width,
           seating_interest_sidewalk,
           sidewalk_dimensions_area,
           sidewalk_dimensions_length,
           sidewalk_dimensions_width,
           sla_license_type,
           sla_serial_number
       ),

       -- Date/Time
       CAST(time_of_submission AS TIMESTAMP) AS time_of_submission,

       -- Request details
       CAST(approved_for_roadway_seating AS STRING) as approved_for_roadway_seating,
       CAST(approved_for_sidewalk_seating AS STRING) as approved_for_sidewalk_seating,
       CAST(bbl AS STRING) as bbl,
       CAST(bin AS STRING) as bin,
       CAST(bulding_number AS STRING) as bulding_number,
       CAST(business_address AS STRING) as business_address,
       CAST(census_tract AS STRING) as census_tract,
       CAST(community_board AS STRING) as community_board,
       CAST(council_district AS STRING) as council_district,
       CAST(doing_business_as_dba AS STRING) as doing_business_as_dba,
       CAST(food_service_establishment AS STRING) as food_service_establishment,
       --CAST(globalid AS STRING) as globalid,
       CAST(healthcompliance_terms AS STRING) as healthcompliance_terms,
       CAST(landmark_district_or_building AS STRING) as landmark_district_or_building,
       CAST(landmarkdistrict_terms AS STRING) as landmarkdistrict_terms,
       CAST(legal_business_name AS STRING) as legal_business_name,
       CAST(nta AS STRING) as nta,
       CAST(objectid AS STRING) as objectid,
       CAST(qualify_alcohol AS STRING) as qualify_alcohol,
       CAST(restaurant_name AS STRING) as restaurant_name,
       CAST(roadway_dimensions_area AS STRING) as roadway_dimensions_area,
       CAST(roadway_dimensions_length AS STRING) as roadway_dimensions_length,
       CAST(roadway_dimensions_width AS STRING) as roadway_dimensions_width,
       CAST(seating_interest_sidewalk AS STRING) as seating_interest_sidewalk,
       CAST(sidewalk_dimensions_area AS STRING) as sidewalk_dimensions_area,
       CAST(sidewalk_dimensions_length AS STRING) as sidewalk_dimensions_length,
       CAST(sidewalk_dimensions_width AS STRING) as sidewalk_dimensions_width,
       CAST(sla_license_type AS STRING) as sla_license_type,
       CAST(sla_serial_number AS STRING) as sla_serial_number,




       -- Location - clean zip code, handling several common zip code data problems
       CASE
           WHEN UPPER(TRIM(CAST(zip AS STRING))) IN ('N/A', 'NA') THEN NULL
           WHEN UPPER(TRIM(CAST(zip AS STRING))) = 'ANONYMOUS' THEN 'Anonymous'
           WHEN LENGTH(CAST(zip AS STRING)) = 5 THEN CAST(zip AS STRING)
           WHEN LENGTH(CAST(zip AS STRING)) = 9 THEN CAST(zip AS STRING)
           WHEN LENGTH(CAST(zip AS STRING)) = 10
               AND REGEXP_CONTAINS(CAST(zip AS STRING), r'^\d{5}-\d{4}')
           THEN CAST(zip AS STRING)
           ELSE NULL
       END AS zip,

       -- Location - standardized borough, just in case
       CASE
           WHEN UPPER(TRIM(borough)) IN ('MANHATTAN', 'NEW YORK COUNTY') THEN 'Manhattan'
           WHEN UPPER(TRIM(borough)) IN ('BRONX', 'THE BRONX') THEN 'Bronx'
           WHEN UPPER(TRIM(borough)) IN ('BROOKLYN', 'KINGS COUNTY') THEN 'Brooklyn'
           WHEN UPPER(TRIM(borough)) IN ('QUEENS', 'QUEEN', 'QUEENS COUNTY') THEN 'Queens'
           WHEN UPPER(TRIM(borough)) IN ('STATEN ISLAND', 'RICHMOND COUNTY') THEN 'Staten Island'
           ELSE 'UNKNOWN or CITYWIDE'
       END AS borough,

       CAST(street AS STRING) AS street,
       CAST(latitude AS DECIMAL) AS latitude,
       CAST(longitude AS DECIMAL) AS longitude,


       -- Metadata
       CURRENT_TIMESTAMP() AS _stg_loaded_at

   FROM source

   -- Filters
   --WHERE (agency = 'DOT' OR agency_name LIKE '%Transportation%')
   --AND unique_key IS NOT NULL
   --AND created_date IS NOT NULL
   --AND CAST(created_date AS DATE) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 YEAR)
   --AND borough IS NOT NULL

   -- Deduplicate
   --QUALIFY ROW_NUMBER() OVER (PARTITION BY unique_key ORDER BY created_date DESC) = 1
)

SELECT * FROM cleaned
-- All should be part of this table: stg_nyc_open_restaurant_apps
