drop table if exists query;

CREATE TABLE query (
    searchid SERIAL PRIMARY KEY,
    year INT,
    month INT,
    day INT,
    userid INT,
    ts BIGINT,
    devicetype VARCHAR(50),
    deviceid VARCHAR(50),
    query TEXT
);

INSERT INTO query (year, month, day, userid, ts, devicetype, deviceid, query)
VALUES
(2024, 11, 21, 1, 1700544000, 'ios', 'device_001', 'пыл'),
(2024, 11, 21, 2, 1700546000, 'android', 'device_002', 'ноутбук'),
(2024, 11, 21, 3, 1700548000, 'desktop', 'device_003', 'диван'),
(2024, 11, 21, 4, 1700551000, 'ios', 'device_004', 'телевизор'),
(2024, 11, 21, 5, 1700554000, 'android', 'device_005', 'шкаф'),
(2024, 11, 21, 1, 1700544100, 'ios', 'device_001', 'пылесос'),
(2024, 11, 21, 2, 1700546100, 'android', 'device_002', 'ноутбуки'),
(2024, 11, 21, 3, 1700548200, 'desktop', 'device_003', 'диваны'),
(2024, 11, 21, 4, 1700551200, 'ios', 'device_004', 'телевизоры'),
(2024, 11, 21, 5, 1700554300, 'android', 'device_005', 'шкафы'),
(2024, 11, 21, 1, 1700544200, 'ios', 'device_001', 'пылесос робот'),
(2024, 11, 21, 2, 1700546200, 'android', 'device_002', 'ноутбуки игровые'),
(2024, 11, 21, 3, 1700548300, 'desktop', 'device_003', 'диваны кожаные'),
(2024, 11, 21, 4, 1700551300, 'ios', 'device_004', 'телевизоры большие'),
(2024, 11, 21, 5, 1700554400, 'android', 'device_005', 'шкафы купе'),
(2024, 11, 21, 1, 1700549000, 'ios', 'device_001', 'пылесос мощный'),
(2024, 11, 21, 2, 1700549100, 'android', 'device_002', 'ноутбуки бюджетные'),
(2024, 11, 21, 3, 1700549200, 'desktop', 'device_003', 'диваны раскладные'),
(2024, 11, 21, 4, 1700549300, 'ios', 'device_004', 'телевизоры 4к'),
(2024, 11, 21, 5, 1700549400, 'android', 'device_005', 'шкафы с зеркалом');

with query_status AS(
select
	*,
	case 
		when (count(*) over (partition by q.userid, q.deviceid)) = 1 
			or (lead(ts) over(partition by q.userid, q.deviceid)) - ts > 180  then 1 
		when length(lead(query) over(partition by q.userid, q.deviceid)) < length(query)
			and (lead(ts) over(partition by q.userid, q.deviceid)) - ts > 60 then 2
		else 0
	end as is_final,
	lead(query) over (partition by q.userid, q.deviceid) as next_query
from 
	query q)


	
select 
	"year", "month", "day", "userid", "ts" , "devicetype", "deviceid" , "query", "next_query", "is_final"
from 
	query_status
 
where
	"year" = 2024 and "month" = 11 and "day" = 21 and 
	"devicetype" = 'android' and 
	(is_final = 1 or is_final = 2);
	
