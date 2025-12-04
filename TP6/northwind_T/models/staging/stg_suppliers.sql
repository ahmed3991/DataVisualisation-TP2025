{{ config(materialized='table') }}

with source_data as (
    select
        supplier_id,
        company_name,
        contact_name,
        contact_title,
        address,
        city,
        region,
        postal_code,
        country,
        phone,
        fax,
        home_page
    from {{ source('staging_dlt', 'suppliers') }}
),

renamed as (
    select
        {{ dbt_utils.generate_surrogate_key(['supplier_id']) }} as supplier_pk,
        supplier_id,
        company_name,
        contact_name,
        contact_title,
        address,
        city,
        region,
        postal_code,
        country,
        phone,
        fax,
        home_page
    from source_data
)

select * from renamed
