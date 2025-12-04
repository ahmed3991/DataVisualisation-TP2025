{{ config(materialized='table') }}

select
    product_pk,
    product_id,
    product_name,
    supplier_id,
    category_id            -- مهم جداً
from {{ ref('stg_products') }}
