{{
    config(
        materialized='table'
    )
}}

SELECT 
-- from raw orders:
{{ dbt_utils.surrogate_key(['o.orderid','c.customerid','p.productid']) }} as sk_orders,
o.orderid,
o.orderdate,
o.shipdate,
o.shipmode,
o.ordersellingprice - o.ordercostprice AS orderprofit,
o.ordercostprice,
o.ordersellingprice,
--from raw customers:
c.customerid,
c.customername,
c.segment,
c.country,
--from raw product
p.productid,
p.category,
p.productname,
p.subcategory,
d.delivery_team,
{{ markup('ordersellingprice','ordercostprice') }} as markup
from {{ref('raw_order')}} as o
left join {{ ref('raw_customer') }} as c
on o.customerid = c.customerid
left join {{ ref('raw_product') }} as p
on o.productid = p.productid
left join {{ ref('delivery_team') }} as d
on o.shipmode = d.shipmode
{{ limit_data_in_dev('orderdate') }}

