{{ config(materialized='table') }}

with customers as (
    select
        customer_pk,
        customer_id,
        company_name,
        address || ', ' || city || ', ' || region || ', ' || country 
            as customer_full_address
    from {{ ref('stg_customers') }}
),

orders as (
    select
        customer_id,
        min(order_date) as first_order_date
    from {{ ref('stg_orders') }}
    group by customer_id
)

select
    c.customer_pk,
    c.customer_id,            
    c.company_name,
    c.customer_full_address,
    o.first_order_date
from customers c
left join orders o
    on c.customer_id = o.customer_id
