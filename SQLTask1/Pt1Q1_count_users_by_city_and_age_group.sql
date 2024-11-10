select city,
case --группировка по возрастам
	when age < 21 then 'young'
	when age between 21 and 49 then 'adult'
	else 'old'
end as age_group, 
count(*) as users_count
from users as u
--группируем сначала по полю город, а потом по возрастным группам
group by city, age_group  
order by city, users_count asc;





