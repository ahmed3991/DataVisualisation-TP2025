{{ config(materialized='table') }}

with source_data as (
    select
        category_id,
        category_name,
        description
    from {{ source('staging_dlt', 'categories') }}
),

renamed as (
    select
        {{ dbt_utils.generate_surrogate_key(['category_id']) }} as category_pk,
        category_id,
        category_name,
        description
    from source_data
)

select * from renamed
