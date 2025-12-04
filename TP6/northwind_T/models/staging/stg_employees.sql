{{ config(materialized='table') }}

with source_data as (
    select
        employee_id,
        first_name,
        last_name,
        title
    from {{ source('staging_dlt', 'employees') }}
),

renamed as (
    select
        {{ dbt_utils.generate_surrogate_key(['employee_id']) }} as employee_pk,
        employee_id,
        first_name,
        last_name,
        title
    from source_data
)

select * from renamed