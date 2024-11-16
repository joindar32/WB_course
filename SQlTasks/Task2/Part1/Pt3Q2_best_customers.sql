/*
 * с помощью вложенного цикла отбираем макс. количество заказов
 * дальше выводим всю необходимую информацию для клиентов, чье количество заказов
 * совпало с макс. количеством заказов. 
 */

select on2.customer_id , count(*) as orders_count, avg(on2.shipment_date::timestamp - on2.order_date ::timestamp), sum(order_ammount)
from orders_new on2 natural join
customers_new cn 
group by on2.customer_id 
having count(*) = (
	select count(*)
	from orders_new on2 inner join
	customers_new cn 
	on on2.customer_id = cn.customer_id 
	group by on2.customer_id 
	order by 1 desc
	limit 1
)
order by orders_count desc;
