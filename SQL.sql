#Question:
#Swiggy Case Study-

select * from users;
alter table users
RENAME column name to namess;
# 1. Find customers who have never ordered
select namess 
from users
where user_id not in (select user_id from orders);

#2 average price/dish
select * from menu;
select food.f_name,AVG(menu.price) as 'Avg price'
from menu
join food 
on food.f_id=menu.f_id
group by food.f_name;

#3. Find the top restaurant in terms of the number of orders for a given month
select *,monthname(date) as 'Month' from orders where monthname(date) ='June';
Select r_name,count(*) 
from orders o
join restaurants r 
on o.r_id=r.r_id
where monthname(date) ='June'
group by r_name
order by count(*) desc
limit 1;

# 4. restaurants with monthly sales greater than x for let x=500 and month= june
select r_name,sum(amount) as 'revenue'
from orders o
join restaurants r
on o.r_id=r.r_id
where monthname(date)='June'
group by r.r_name
having revenue>500
order by r_name ;


#5. Show all orders with order details for a particular customer in a particular date range(Ex:- Ankit from 10th of june  to  10th of july )
select o.order_id,r.r_name,f.f_name
from orders o
join restaurants r
on o.r_id=r.r_id
join order_details od 
on o.order_id=od.order_id
Join food f 
on f.f_id=od.f_id
where user_id =(select user_id from users where namess='Ankit')
AND date > '2022-06-10' and date < '2022-07-10';

#6. Find restaurants with max repeated customers 
Select r_name,count(*) as 'Loyal_Customers'
FROM ( 
     select r_id,user_id,count(*) as 'Vistors' 
     from orders
	 Group by r_id,user_id
     Having vistors>1
) t
join restaurants r
on r.r_id=t.r_id
group by r_name
order by Loyal_Customers DESC LIMIT 1;


#7. Month over month revenue growth of swiggy
SELECT month, ((revenue - prev) / prev) * 100
FROM (
    WITH sales AS (
        SELECT DATE_FORMAT(date, '%Y-%m') AS 'month', SUM(amount) AS 'revenue'
        FROM orders
        GROUP BY DATE_FORMAT(date, '%Y-%m')
    )
    SELECT month, revenue, LAG(revenue, 1) OVER (ORDER BY revenue) AS prev
    FROM sales
) t
ORDER BY month;

#8. Customer - favorite food
select o.user_id,od.f_id
from orders o
join order_details od 
on o.order_id=od.order_id
group by o.user_id,od.f_id;

