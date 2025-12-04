{{ config(materialized='table') }}

with source_data as (
    select
        order_id,
        product_id,
        unit_price,
        quantity,
        discount
    from {{ source('staging_dlt', 'order_details') }}
),

final as (
    select
        {{ dbt_utils.generate_surrogate_key(['order_id']) }} as order_pk,   -- ✔ مهم جداً
        {{ dbt_utils.generate_surrogate_key(['order_id', 'product_id']) }} as order_detail_pk, -- ✔ المفتاح الفريد
        order_id,
        product_id,
        unit_price,
        quantity,
        discount
    from source_data
)

select * from final
