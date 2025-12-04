{{ config(materialized='table') }}

with stg as (
    select
        employee_pk,
        employee_id,
        first_name,
        last_name,
        title
    from {{ ref('stg_employees') }}
)

select
    employee_pk,
    employee_id,
    first_name,
    last_name,
    title,
    first_name || ' ' || last_name as employee_full_name
from stg