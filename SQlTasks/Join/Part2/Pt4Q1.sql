/*
 * подзапрос q1 вычисляет общуею сумму продаж для каждой категории
 * подзапрос q2 вычисляет продукт с самыми большими объемами продаж
 * и затем находим его категорию (формулировку второго задания я именно понял
 * как то, что сначала нужно найти продукт с макс. проадажами а потом найти его 
 * категорию, а не находждение категории с макс. количеством продаж)
 * подзапрос q3 для каждой категории продуктов ищем продукт с макс суммой продаж
 * 
 * затем я объединяю q1 с q3  с помощью left join по совпадению поля product_category
 * и результат этого join  объединяю с q2 с помощью cross join, т.к. q2 у нас выводит
 * всего одно значение
 */







select q1.*, q3.product_id, q3.product_name as product_max_amount, q3.product_sales, q2.product_category as category_of_product_max_amount
from (
	SELECT 
	        product_category, 
	        SUM(order_amount) AS total_order_amount
	    FROM 
	        products p
	    LEFT JOIN 
	        orders o 
	    ON 
	        p.product_id = o.product_id 
	    GROUP BY 
	        p.product_category
	    ORDER BY 
	        total_order_amount desc) as q1
inner join (
	SELECT 
	        p.product_id, 
	        product_name, 
	        product_category, 
	        SUM(o.order_amount) AS product_sales
	    FROM 
	        products p 
	    INNER JOIN 
	        orders o 
	    ON 
	        p.product_id = o.product_id 
	    GROUP BY 
	        p.product_id, product_name, product_category
	    HAVING 
	        (product_category, SUM(o.order_amount)) IN (
	            SELECT 
	                product_category, 
	                MAX(product_sales)
	            FROM (
	                SELECT 
	                    p.product_id, 
	                    product_category, 
	                    SUM(o.order_amount) AS product_sales
	                FROM 
	                    products p 
	                INNER JOIN 
	                    orders o 
	                ON 
	                    p.product_id = o.product_id 
	                GROUP BY 
	                    p.product_id, product_category
	            ) AS sq
	            GROUP BY 
	                product_category
	        )) as q3
on q1.product_category = q3.product_category
cross join 
	(select product_category
	from products p 
	where product_id = (
	select 
		p.product_id
	from 
		products p inner join orders o 
	on
		p.product_id = o.product_id 
	group by 
		p.product_id
	order by 
		sum(order_amount) desc
	limit 1)) as q2;

