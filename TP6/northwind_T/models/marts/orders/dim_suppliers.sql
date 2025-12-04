{{ config(materialized='table') }}

select
    supplier_pk,
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

from {{ ref('stg_suppliers') }}
