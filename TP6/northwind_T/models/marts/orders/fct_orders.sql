{{ config(materialized='table') }}

with orders as (
    select 
        order_pk,
        order_id,
        customer_id,
        NULLIF(order_date, 'None')::date as order_date,
        NULLIF(shipped_date, 'None')::date as shipped_date
    from {{ ref('stg_orders') }}
),

customers as (
    select 
        customer_pk,
        customer_id
    from {{ ref('dim_customers') }}
),

details as (
    select 
        order_id,
        product_id,
        unit_price,
        quantity
    from {{ ref('stg_order_details') }}
),

products_dim as (
    select 
        product_pk,
        product_id
    from {{ ref('dim_products') }}
),

joined as (
    select
        orders.order_pk,
        orders.order_id,
        customers.customer_pk,
        products_dim.product_pk,
        details.product_id,

        (details.unit_price * details.quantity)::numeric(18,2) 
            as total_order_value,

        case 
            when orders.shipped_date is not null then 'Shipped'
            else 'Pending'
        end as order_status_flag,

        (orders.shipped_date::date - orders.order_date::date) 
            as shipping_time_days,

        concat(orders.order_pk, '-', products_dim.product_pk) 
            as composite_unique_key

    from orders
    left join customers 
        on orders.customer_id = customers.customer_id
    left join details 
        on orders.order_id = details.order_id
    left join products_dim
        on details.product_id = products_dim.product_id
)

select * from joined
