select utm_source, utm_content, http_referer, 
		count(distinct website_sessions.website_session_id) as sessions, 
		count(distinct order_id) as number_orders,
        count(distinct order_id)/count(distinct website_sessions.website_session_id) as CVR
 from website_sessions left join orders
 on website_sessions.website_session_id = orders.website_session_id
 where website_sessions.created_at < date('2012-04-14')
 group by 1,2,3
 order by 4 desc;
 
 select * from website_sessions;
 select * from orders;
 
 SELECT MIN(DATE(created_at)) as week_start_date, COUNT(DISTINCT website_session_id) as sessions 
FROM website_sessions
where utm_source='gsearch'
and utm_campaign='nonbrand'
and created_at < DATE('2012-05-10')
GROUP BY year(created_at), week(created_at);


select * from website_sessions;

select device_type, count(DISTINCT website_sessions.website_session_id) as sessions, COUNT(DISTINCT orders.order_id) as orders, 
		COUNT(DISTINCT orders.order_id)/count(DISTINCT website_sessions.website_session_id) as session_to_order_conv_rate
from website_sessions LEFT JOIN orders
on website_sessions.website_session_id = orders.website_session_id
where website_sessions.created_at < date ('2012-05-11')
and website_sessions.utm_campaign = 'nonbrand'
and website_sessions.utm_source='gsearch'
group by device_type;

select * from website_sessions;

select MIN(DATE(created_at)) as week_start_date,
		COUNT(DISTINCT CASE WHEN device_type='desktop' THEN website_session_id else NULL END) as dtop_sessions, 
        COUNT(DISTINCT CASE WHEN device_type='mobile' THEN website_session_id else NULL END) as mob_sessions
FROM website_sessions
where utm_source='gsearch'
and utm_campaign='nonbrand'
and created_at > DATE('2012-04-15')
and created_at < DATE('2012-06-09')
GROUP BY YEAR(created_at), WEEK(created_at);

SELECT pageview_url, COUNT(DISTINCT website_pageview_id) as sessions
FROM website_pageviews
where created_at < DATE('2012-06-09')
group by pageview_url
order by sessions desc;

select * from website_pageviews;

CREATE TEMPORARY TABLE pv_first_landed
select website_session_id, MIN(website_pageview_id) as pv_landed
from website_pageviews
where created_at < DATE('2012-06-12')
group by website_session_id;

select * from pv_first_landed;

select pageview_url, count(DISTINCT pv_first_landed.website_session_id) as sessions
from pv_first_landed LEFT JOIN website_pageviews
ON pv_first_landed.pv_landed = website_pageviews.website_pageview_id
GROUP BY pageview_url;

