{{ config(materialized='table') }}

with source_data as (
    select * from {{ source('staging_dlt', 'orders') }}
),

renamed_columns as (
    select
        {{ dbt_utils.generate_surrogate_key(['order_id']) }} as order_pk,
        order_id,
        customer_id,
        employee_id,
        order_date,
        required_date,
        shipped_date,
        ship_via,
        freight,
        ship_name,
        ship_address,
        ship_city,
        ship_region,
        ship_postal_code,
        ship_country
    from source_data
)

select * from renamed_columns
