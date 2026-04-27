WITH inspections AS (
    SELECT DISTINCT
        CAST(created_date AS DATE) AS full_date,
        complaint_type,
        descriptor,
        borough,
        CAST(null as STRING) as zip_code,
        agency,
        agency_name,
        latitude,
        longitude,
        community_board
    FROM {{ ref('stg_rodent_complaint') }}
),

final AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['full_date', 'complaint_type', 'descriptor', 'agency']) }} AS complaint_key,
        {{ dbt_utils.generate_surrogate_key(['full_date']) }} AS date_key,
        {{ dbt_utils.generate_surrogate_key(['complaint_type', 'descriptor']) }} AS problem_key,
        {{ dbt_utils.generate_surrogate_key(['borough', 'zip_code']) }} AS location_key,
        {{ dbt_utils.generate_surrogate_key(['agency']) }} AS agency_key,

        latitude,
        longitude,
        community_board,
        COUNT(*) as complaint_count
    FROM inspections
)

SELECT *
FROM final





	