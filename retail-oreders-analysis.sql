select *
from cleaned_orders co ;

-- Top 10 Renenue Generating Products 
select  product_id , sum(actual_price) as revenue
from cleaned_orders co 
group by product_id 
order by revenue desc 
limit 10;

-- Top 5 Revenue Generating Products by Regin 
with cte as (
select  region,product_id , sum(actual_price) as revenue
from cleaned_orders co 
group by region, product_id 
)
select * from(
select *, row_number() over (partition by region order by revenue desc) as rn
 from cte) a
 where rn <=5;

-- Total saless by month and Year 
with cte as ( 
select year(order_date) as order_year, month(order_date) as order_month, sum(actual_price) as sales
from cleaned_orders co 
group by order_year, order_month
)
select order_month,
sum(case when order_year = 2022 then sales else 0 end) as sales_22
,sum(case when order_year = 2023 then sales else 0 end) as sales_23
from cte
group by order_month
order by order_month;


-- Which category  is the highest revenue generating category in year  and month wise
with cte as (select category , date_format(order_date, "%Y/%M") as Year_wise, sum(actual_price) as revenue
from cleaned_orders co
group by category , Year_wise)
select * from(
select *, row_number () over(partition by category order by revenue desc) as rn
from cte
) a
where rn =1;

-- comparing revune and growth of each sub category
with cte as ( 
select sub_category,year(order_date) as order_year,  sum(actual_price) as sales
from cleaned_orders co 
group by order_year, sub_category
)
, cte2 as(select sub_category
,sum(case when order_year = 2022 then sales else 0 end) as sales_22
,sum(case when order_year = 2023 then sales else 0 end) as sales_23
from cte
group by sub_category
)
select *, 
(sales_23 - sales_22)*100/sales_22 as growth
from cte2
order by growth desc;

















