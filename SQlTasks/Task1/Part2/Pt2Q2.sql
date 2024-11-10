/*
 Сначала я вложенным запросом выбираю seller_id для poor продавцов,
 затем  я нахожу для poor продавцов разницу между макс. кол-вом дней
 для достави и мин. И только затем я делаю основную часть запроса с подсчетом месяцев,
 и еще одним столбцом вывожу результат вложенных запросов
*/

select 
	seller_id,
	date_part('year', age(now(), min(date_reg))) * 12 +
	date_part('month', age(now(), min(date_reg))) as month_from_registration,
	-- второй вложенный запрос
	(select 
		max(delivery_days) - min(delivery_days)
	from 
		"WB1_schema".sellers
	where 
		category <> 'Bedding'
		and seller_id in
		-- первый вложенный запрос
		(select  
			seller_id
		from 
			"WB1_schema".sellers
		where 
			category <> 'Bedding'
		group by 
			seller_id
		having 
			count(category) < 2 or sum(revenue) <= 50000)
	) as max_delivery_difference
	
from 
	"WB1_schema".sellers
where 
	category <> 'Bedding'
group by 
	seller_id
having 
	count(category) < 2 or sum(revenue) <= 50000
order by 
	seller_id; 
