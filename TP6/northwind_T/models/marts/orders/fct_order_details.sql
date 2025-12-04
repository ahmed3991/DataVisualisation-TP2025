{{ config(materialized='table') }}

with order_details as (
    select
        order_id,
        product_id,
        unit_price,
        quantity,
        discount
    from {{ ref('stg_order_details') }}
),

orders as (
    select
        order_pk,
        order_id,
        customer_id,
        employee_id,
        order_date,
        shipped_date
    from {{ ref('stg_orders') }}
),

products as (
    select
        product_pk,
        product_id,
        category_id
    from {{ ref('dim_products') }}
),

customers as (
    select
        customer_pk,
        customer_id
    from {{ ref('dim_customers') }}
),

employees as (
    select
        employee_pk,
        employee_id
    from {{ ref('dim_employees') }}
),

categories as (
    select
        category_pk,
        category_id
    from {{ ref('dim_categories') }}
),

final as (
    select
        {{ dbt_utils.generate_surrogate_key([
            'order_details.order_id',
            'order_details.product_id'
        ]) }} as order_detail_pk,

        -- Foreign Keys
        orders.order_pk,
        customers.customer_pk,
        employees.employee_pk,
        products.product_pk,
        categories.category_pk,

        -- Natural keys
        order_details.order_id,
        order_details.product_id,

        -- Fact Measures
        order_details.unit_price,
        order_details.quantity,
        order_details.discount,

        (order_details.unit_price * order_details.quantity * (1 - order_details.discount))::numeric(18,2)
            as extended_price,

        -- Dates
NULLIF(orders.order_date, 'None')::date as order_date,
NULLIF(orders.shipped_date, 'None')::date as shipped_date,

(
    NULLIF(orders.shipped_date, 'None')::date 
    - NULLIF(orders.order_date, 'None')::date
) as shipping_delay_days


    from order_details
    left join orders
        on order_details.order_id = orders.order_id
    left join products
        on order_details.product_id = products.product_id
    left join customers
        on orders.customer_id = customers.customer_id
    left join employees
        on orders.employee_id = employees.employee_id
    left join categories
        on products.category_id = categories.category_id
)

select * from final
