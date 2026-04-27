WITH inspections AS (
    SELECT DISTINCT
        inspection_type,
        action,
        grade
    FROM {{ ref('stg_restaurant_inspection') }}
),

final AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key([
            'inspection_type',
            'action',
            'grade'
        ]) }} AS inspection_key,

        inspection_type,
        action,
        grade
    FROM inspections
)

SELECT *
FROM final
