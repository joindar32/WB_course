/*
 * Сначала выбираем только те строки, регистрация в которых произшла в 2022.
 * Затем группируем по seller_id и оставляем только те группы, в которых количество уникальных
 * категорий равно 2 и суммарная выручка превышает 75000.
 * C помощью функции string_agg объединяем названия двух категорий с разделителем ' - '.
 */
select 
	seller_id, string_agg(category, ' - ' order by category) as categoty_pair
from 
	"WB1_schema".sellers s 
where 
	extract(year from date_reg) = 2022
group by 
	seller_id 
having 
	count(distinct category) = 2 and sum(revenue) > 75000;

