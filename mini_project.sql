select * from website_sessions;
-- 1 --------------
select EXTRACT(YEAR_MONTH FROM website_sessions.created_at) as month, 
		count(DISTINCT website_sessions.website_session_id) as sessions, 
        COUNT(orders.order_id) as orders
from website_sessions LEFT JOIN orders 
	ON website_sessions.website_session_id = orders.website_session_id
where utm_source ='gsearch'
and website_sessions.created_at<'2012-11-27'
group by MONTH(website_sessions.created_at);

-- 2 -------------------------
CREATE TEMPORARY TABLE temp
select 	YEAR(website_sessions.created_at) as year,
		MONTH(website_sessions.created_at) as month, 
		count(DISTINCT CASE WHEN utm_campaign ='brand' THEN website_sessions.website_session_id ELSE NULL END) as branded_sessions, 
        COUNT(DISTINCT CASE WHEN utm_campaign ='brand' THEN orders.order_id ELSE NULL END) as branded_orders,
        count(DISTINCT CASE WHEN utm_campaign ='nonbrand' THEN website_sessions.website_session_id ELSE NULL END) as nonbranded_sessions, 
        COUNT(DISTINCT CASE WHEN utm_campaign ='nonbrand' THEN orders.order_id ELSE NULL END) as nonbranded_orders
from website_sessions LEFT JOIN orders 
	ON website_sessions.website_session_id = orders.website_session_id
where utm_source ='gsearch'
and website_sessions.created_at<'2012-11-27'
group by 1,2;

select temp.year, temp.month,  sum(branded_sessions) as branded_sessions, sum(branded_orders) as branded_orders,
		SUM(nonbranded_sessions) as nonbranded_sessions, SUM(nonbranded_orders) as nonbranded_orders
from temp
group by 1,2;

DROP TABLE temp;
select * from website_sessions;

-- 3 ----------------------------------
CREATE TEMPORARY TABLE temp1 
select EXTRACT(year_month from website_sessions.created_at) as year_mo, website_sessions.device_type, 
		count(DISTINCT website_sessions.website_session_id) as sessions,
        count(DISTINCT orders.order_id) as orders
from website_sessions LEFT JOIN orders
	ON website_sessions.website_session_id = orders.website_session_id
where utm_source='gsearch'
and utm_campaign ='nonbrand'
and website_sessions.created_at<'2012-11-27'
group by 1,2;

DROP TABLE temp1;
select year_mo, device_type, sum(sessions), sum(orders)
from temp1
group by 1,2;

-- 4 ----------------------------------

select * from website_sessions;
DROP TABLE temp2;

CREATE TEMPORARY TABLE temp2
select EXTRACT(year_month from website_sessions.created_at) as year_mo, utm_source,
		COUNT(DISTINCT website_sessions.website_session_id) as sessions, count(orders.order_id) as orders
from website_sessions LEFT JOIN orders
	ON website_sessions.website_session_id = orders.website_session_id
where website_sessions.created_at < '2012-11-27'
and utm_source IS NOT NULL
group by 1,2;

select year_mo, utm_source, SUM(sessions), sum(orders)
from temp2
group by year_mo, utm_source;

-- 5 -------------------------

select * from website_sessions;
select * from orders;

select year(website_sessions.created_at) as year,
		month(website_sessions.created_at) as month,
		count(DISTINCT website_sessions.website_session_id) as sessions,
		count(orders.order_id) as orders
from website_sessions LEFT JOIN orders
	ON website_sessions.website_session_id = orders.website_session_id
where website_sessions.created_at<'2012-11-27'
group by 1,2;

-- 6 ---------------------
















-- 7 --------------------------------------
select MAX(s.website_session_id) as most_recent
 from website_sessions s LEFT JOIN website_pageviews 
	ON s.website_session_id = website_pageviews.website_session_id
where utm_source='gsearch'
and utm_campaign = 'nonbrand'
and s.created_at<'2012-11-27'
and pageview_url = '/home';



