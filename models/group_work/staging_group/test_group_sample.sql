 -- Quick test to verify source connection works
SELECT
    camis,
    dba,
    boro,
    zipcode,
    inspection_date,
    cuisine_description,
    score,
    grade
FROM {{ source('raw', 'restaurant_inspection_results') }}
LIMIT 10
