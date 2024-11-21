--Задание 1 с использованием group by
select 
	sh."SHOPNUMBER", 
	sh."CITY", 
	sh."ADDRESS", 
	SUM(sa."QTY") sum_qty, 
	SUM(sa."QTY" * g."PRICE") as sum_qty_price
from 
	"WB5_schema".sales sa
left join
	"WB5_schema".shops sh
using
	("SHOPNUMBER")
left join
	"WB5_schema".goods g 
using("ID_GOOD")

where 
	sa."DATE" = '2016-01-01'
group by 
	sh."SHOPNUMBER", sh."CITY", sh."ADDRESS";
	
--------------------------------------------------
--Задание 1 с использованием оконных функций
select 
	distinct on(sh."SHOPNUMBER") --для того чтобы каждый магазин выводился 1 раз
	sh."SHOPNUMBER",
	sh."CITY", 
	sh."ADDRESS", 
	--собираем штуки проданных товаров по окну (разделение по shopnumber)
	SUM(sa."QTY") over(partition by sh."SHOPNUMBER")sum_qty ,  
	--собираем сумму проданных товаров по окну (разделение по shopnumber)
	SUM(sa."QTY" * g."PRICE") over(partition by sh."SHOPNUMBER") as sum_qty_price --
from 
	"WB5_schema".sales sa
left join
	"WB5_schema".shops sh
using
	("SHOPNUMBER")
left join
	"WB5_schema".goods g 
using("ID_GOOD")

where 
	sa."DATE" = '2016-01-01';
	
-------------------------------------------------
--Задание 2
select 
	sa."DATE",
	--делим сумму товаров по датам на сумму суммы товаров за все время
	SUM(sa."QTY" * g."PRICE") / SUM(SUM(sa."QTY" * g."PRICE")) OVER() as sum_sales_rel
from 
	"WB5_schema".sales sa
left join
	"WB5_schema".shops sh
using
	("SHOPNUMBER")
left join
	"WB5_schema".goods g 
using("ID_GOOD")

where 
	g."CATEGORY" = 'ЧИСТОТА'
group by	
	sa."DATE";



-----------------------------------------------------------
--Задание 3


--Создаем CTE с количеством проданных товаров 
--в конкретную дату в конкретном магазине

with goods_sales as(
	select 
		sa."DATE",  
		sh."SHOPNUMBER", 
		g."ID_GOOD", 
		count(*) as sales_count
	from 
		"WB5_schema".sales sa
	left join
		"WB5_schema".shops sh using("SHOPNUMBER")
	left join
		"WB5_schema".goods g using("ID_GOOD")
	
	group by	
		sa."DATE",  sh."SHOPNUMBER", g."ID_GOOD"),
		
		
--CTE где мы даем порядковый номер в зависимости от количества проданных штук товара		
ranked_good as (
select 
	"DATE",  
	"SHOPNUMBER", 
	"ID_GOOD", 
	ROW_NUMBER() OVER(
		partition by "DATE",  "SHOPNUMBER" 
		order by  sales_count desc
		) as ranked_goods
from 
	goods_sales
)
--Выводим только те комбинации date shopnumber id_good где "ранг" < 4
select 
	"DATE" as "DATE_",
	"SHOPNUMBER",
	"ID_GOOD"
from 
	ranked_good
where 
	ranked_goods < 4;

----------------------------

--Задание 4

--CTE где мы указываем total_sale для магазинов в спб по категориям и датам
with sales_cat_shop_date AS(
select 
	sh."SHOPNUMBER", 
	g."CATEGORY",
	sa."DATE",
	SUM(sa."QTY" * g."PRICE") as total_sales
from 
	"WB5_schema".sales sa
left join
	"WB5_schema".shops sh
using
	("SHOPNUMBER")
left join
	"WB5_schema".goods g 
using("ID_GOOD")

where 
	sh."CITY" = 'СПб'
group by	
	sh."SHOPNUMBER", 
	g."CATEGORY", 
	sa."DATE")

	
	
	
select 
	"DATE" as "DATE_",
	"SHOPNUMBER",
	"CATEGORY",
	--выводим за пред дату total_sale, если не было продаж то выводим 0
	coalesce(LAG(total_sales) OVER(
		partition by 
			"SHOPNUMBER", 
			"CATEGORY"
		order by 
			"DATE"), 0) as prev_sales
from 
	sales_cat_shop_date
order by 3, 1, 2;

