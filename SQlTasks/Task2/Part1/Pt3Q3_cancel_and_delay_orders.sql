/*
 * сначала оставляю только те записи, которые подходят по условиям
 * (либо доставка больше 5 дней либо отмененный заказ),
 * затем группирую по id и name (группирока по name происходит только для того,
 * чтобы можно было вставить имя в вывод, а по сути она избыточна)
 * с помощью count и case условия считаем количество заказов разных категорий,
 * просто count без case бы считал все ненулевые значения, что нам не подходит
 */

select 
	on2.customer_id, cn.name, 
	count(case when (on2.shipment_date::timestamp - on2.order_date ::timestamp) > '5 days' then 1 end) as delay_orders,
	count(case when on2.order_status = 'Cancel' then 1 end) as cancel_orders, 
	sum(case 
		when (on2.shipment_date::timestamp - on2.order_date ::timestamp) > '5 days' or  on2.order_status = 'Cancel' 
		then on2.order_ammount 
		end) 
from 
	orders_new on2 	
left join
	customers_new cn 
on 
	on2.customer_id = cn.customer_id 
where 
	(on2.shipment_date::timestamp - on2.order_date ::timestamp) > '5 days' or on2.order_status = 'Cancel'
group by 
	on2.customer_id, cn.name
order by 
	5 desc
	