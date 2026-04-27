WITH all_locations AS (

-- From 311 complaints staging
SELECT DISTINCT
--city,
--address_type,
borough,
--park_borough,
--location_type,
CAST(null as STRING) as zip_code
FROM {{ ref('stg_rodent_complaint') }}
WHERE borough IS NOT NULL

UNION DISTINCT

-- From restaurant inspections staging
SELECT DISTINCT
--null as city,
--null as address_type,
boro as borough,
--boro as park_borough,
--null as location_type,
zipcode AS zip_code
FROM {{ ref('stg_restaurant_inspection') }}
WHERE boro IS NOT NULL

),

location_dimension AS (
SELECT
{{ dbt_utils.generate_surrogate_key(['borough', 'zip_code']) }} AS location_key,
borough,
zip_code
FROM all_locations
)

SELECT *
FROM location_dimension
