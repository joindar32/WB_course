/*
 * Используем left join для таблиц orders_new и customers_new
 * С помощью этого join-а для каждой строки из таблицы orders_new
 * сопоставляется строка из таблицы customers_new по совпадению 
 * столбцов customer_id.
 * Затем сортируем по разнице между датой заказа и датой доставки
 * по убыванию. 
 * Чтобы найти клиента с макс. долгим ожиданием осталось только
 * ограничить вывод первой записью, таким образом выведется
 * запись с макс. разницей между заказом и ожиданием
 */

select 
	*, (on2.shipment_date::timestamp - on2.order_date ::timestamp) as max_delivery_time
from 
	orders_new on2 
left join
	customers_new cn 
on 
	on2.customer_id = cn.customer_id 
order by 
	(on2.shipment_date::timestamp - on2.order_date ::timestamp) desc
limit 1;

