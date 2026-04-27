WITH restaurants AS (
    SELECT DISTINCT
        dba,
        camis,
        phone,
        cuisine_description
    FROM {{ ref('stg_restaurant_inspection') }}
),

final AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key([
            'camis',
            'phone'
        ]) }} AS restaurant_key,

        dba,
        camis,
        phone,
        cuisine_description
    FROM restaurants
)

SELECT *
FROM final
