WITH restaurants AS (
    SELECT DISTINCT 
                CAST(inspection_date AS DATE) AS full_date,
                camis,
                phone,
                boro as borough,
                zipcode AS zip_code,
                inspection_type,
                action,
                grade,
                latitude,
                longitude,
                community_board,
                street,
                building,
                council_district,
                critical_flag,
                violation_description,
                violation_code,
                score

    FROM {{ ref('stg_restaurant_inspection') }}
),

final AS (
    SELECT {{ dbt_utils.generate_surrogate_key(['full_date']) }} AS date_key,
           {{ dbt_utils.generate_surrogate_key(['camis', 'phone']) }} AS restaurant_key,
           {{ dbt_utils.generate_surrogate_key(['borough', 'zip_code']) }} AS location_key,
           {{ dbt_utils.generate_surrogate_key(['inspection_type', 'action', 'grade']) }} AS inspection_key,
           latitude,
           longitude,
           community_board,
           street,
           building,
           council_district,
           critical_flag,
           violation_description,
           violation_code,
           score
    
    FROM restaurants


)

SELECT *
FROM final





	