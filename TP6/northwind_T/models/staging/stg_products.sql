{{ config(materialized='table') }}

with source_products as (
    select
        product_id,
        product_name,
        supplier_id,
        category_id,               -- مهم جداً
        quantity_per_unit,
        unit_price,
        units_in_stock
    from {{ source('staging_dlt', 'products') }}
),

renamed as (
    select
        {{ dbt_utils.generate_surrogate_key(['product_id']) }} as product_pk,
        product_id,
        product_name,
        supplier_id,
        category_id,               -- مهم جداً
        quantity_per_unit,
        unit_price,
        units_in_stock
    from source_products
)

select * from renamed
