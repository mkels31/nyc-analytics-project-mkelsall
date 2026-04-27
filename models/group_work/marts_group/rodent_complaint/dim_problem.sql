WITH problems AS (
    SELECT DISTINCT
        complaint_type,
        descriptor
    FROM {{ ref('stg_rodent_complaint') }}
    WHERE complaint_type IS NOT NULL
),

final AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key([
            'complaint_type',
            'descriptor'
        ]) }} AS problem_key,

        complaint_type,
        descriptor
    FROM problems
)

SELECT *
FROM final
