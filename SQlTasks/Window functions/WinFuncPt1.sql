-- Max без оконок 


--Я исходил из того, что в одной индустрии может быть несколько
--человек с макс и мин зп, для обрабатывания таких ситуаций пришлось
-- делать подзапросы в разделе select внешнего запроса, также в одном из
-- внутренних подзапросов ставить limit 1
select 
	s.first_name, 
	s.last_name, 
	s.salary, 
	s.industry,
	(select  --подзапрос для определения 1 сотрдуника с макс зп
		concat(s2.first_name, ' ', s2.last_name)
	from 
		"WB4_schema".salary s2
	where 
		s.industry = s2.industry and s2.salary =
		(select max(s3.salary) -- позапрос для выбора макс зп для индустрии
		from "WB4_schema".salary s3
		where s3.industry = s.industry)
		limit 1) as max_salary_emp
from 
	"WB4_schema".salary s 
order by 
	s.industry, s.salary;
	
	
-- Min без оконок 
select 
	s.first_name, 
	s.last_name, 
	s.salary, 
	s.industry,
	(select --подзапрос для определения 1 сотрдуника с мин зп
		concat(s2.first_name, ' ', s2.last_name)
	from 
		"WB4_schema".salary s2
	where 
		s.industry = s2.industry and s2.salary =
		(select min(s3.salary)-- позапрос для выбора мин зп для индустрии
		from "WB4_schema".salary s3
		where s3.industry = s.industry)
		limit 1) as min_salary_emp
from 
	"WB4_schema".salary s 
order by 
	s.industry, s.salary;
	

--Max  с помощью оконок
select 
	s.first_name,
	s.last_name,
	s.salary,
	s.industry,
	max(salary) over (partition by industry) as highest_paid_employee,
	--партиции по индустрии, берем первое значение предварительно сортируя по salary по убыванию
	first_value(concat(s.first_name, ' ', s.last_name)) over (partition by industry order by salary desc, first_name ) as emp_with_max_sal
from 
	"WB4_schema".salary s
order by
	industry, salary;


--Min  с помощью оконок	
select 
	s.first_name,
	s.last_name,
	s.salary,
	s.industry,
	min(salary) over (partition by industry) lowest_paid_employee,
	--партиции по индустрии, берем первое значение предварительно сортируя по salary по возрастанию
	first_value(concat(s.first_name, ' ', s.last_name)) over (partition by industry order by salary asc, first_name ) emp_with_min_sal
from 
	"WB4_schema".salary s
order by
	industry, salary;
	

