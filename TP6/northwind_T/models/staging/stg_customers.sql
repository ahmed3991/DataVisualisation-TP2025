{{ config(materialized='table') }}

with source_data as (
    select * from {{ source('staging_dlt', 'customers') }}
),

renamed_columns as (
    select
        {{ dbt_utils.generate_surrogate_key(['customer_id']) }} as customer_pk,
        customer_id,
        company_name,
        contact_name,
        contact_title,
        address,
        city,
        region,
        postal_code,
        country,
        phone,
        fax
    from source_data
)

select * from renamed_columns
