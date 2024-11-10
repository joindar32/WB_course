/*
 * В моем случае я исходил из того, что poor - это продавец, который не подходит под условия rich, 
 * а не тот, который продает больше одной категории, но чья суммарная выручка не превышает 50 000,
 * потому что иначе у нас без категории остаются продавцы, у котрых одна категория
 * 
 * Не рассматриваем строки с category = 'Bedding'
 * С помощью case определяем poor или rich
 * Дальше считаем количество категорий для продавца,
 * средн. рейтинг по категориям сумм. выручки и poor или rich
 */

select seller_id, count(category) as total_categ, round(avg(rating), 2) as avg_rating, 
sum(revenue) as total_revenue,
case 
	when count(category) > 1 and sum(revenue) > 50000 then 'rich'
	else 'poor'
end as seller_type

from "WB1_schema".sellers
where category <> 'Bedding'
group by seller_id
order by 1;
