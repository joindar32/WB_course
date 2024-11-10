select category, round(avg(price), 2) as avg_price
from products
where name ~* '\yhair\y' OR name ~* '\yhome\y'
group by category;

