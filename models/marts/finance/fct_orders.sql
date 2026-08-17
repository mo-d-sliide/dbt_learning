with _orders as (

    select * from {{ ref('stg_jaffle_shop__orders')}}

)

, _payments as (

   select * from {{ ref('stg_stripe__payment')}}

)

, order_payments as (

    select
        order_id
        , sum (case when status = 'success' then amount end) as amount
    from _payments
    group by 1

)

, final as (

    select
        _orders.order_id
        , _orders.customer_id
        , _orders.order_date
        , coalesce (order_payments.amount, 0) as amount
    from _orders
    left join order_payments using (order_id)

)

select * from final