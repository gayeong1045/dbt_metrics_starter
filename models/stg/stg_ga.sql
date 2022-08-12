with ga as (
    SELECT * FROM {{source('sql_study','ga') }}
),

accounts as (
    select * from {{source('sql_study', 'accounts')}}
)

select * from ga a left join accounts b
    on a.user_id = b.user_id

