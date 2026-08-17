with _customers as (

    select * from {{ ref('stg_jaffle_shop__customers') }}

)

, _orders as (

    select * from {{ ref('fct_orders') }}

)

, _payments as (

    select * from {{ ref('stg_stripe__payment')}}

)

, customer_orders as (

    select
        customer_id

        , min(order_date) as first_order_date
        , max(order_date) as most_recent_order_date
        , count(order_id) as number_of_orders
        , sum(amount) as lifetime_value

    from _orders 
    group by 1

),


final as (

    select
        _customers.customer_id
        , _customers.first_name
        , _customers.last_name
        , customer_orders.first_order_date
        , customer_orders.most_recent_order_date
        , coalesce(customer_orders.number_of_orders, 0) as number_of_orders
        , customer_orders.lifetime_value
    from _customers

    left join customer_orders using (customer_id)


)

select * from final
