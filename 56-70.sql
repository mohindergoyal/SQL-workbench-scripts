-- 56 -----------------------
select MIN(DATE(created_at)),
	   COUNT(DISTINCT CASE WHEN utm_source='gsearch' then website_session_id ELSE NULL END) as g_sessions,
		COUNT(DISTINCT CASE WHEN utm_source ='bsearch' then website_session_id ELSE NULL END) as b_sessions
from website_sessions
where created_at> '2012-08-22'
and created_at <'2012-11-29'
and utm_campaign='nonbrand'
group by yearweek(created_at);

-- 58 -------------------------


select utm_source, 
		COUNT(DISTINCT website_session_id) as sessions,
        COUNT(DISTINCT CASE WHEN device_type='mobile' THEN website_session_id ELSE NULL END) as mobile_sessions,
        COUNT(DISTINCT CASE WHEN device_type='mobile' THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) as mo_perct
from website_sessions
where utm_source IN ('gsearch','bsearch')
		and utm_campaign ='nonbrand'
		and created_at > '2012-08-22'
		and created_at < '2012-11-30'
group by utm_source;


-- 60 --------------------------------


select device_type,
		utm_source,
        COUNT(DISTINCT website_sessions.website_session_id) as sessions,
        COUNT(DISTINCT orders.order_id) as orders,
         COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) as conv_rate
from website_sessions LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
where utm_campaign ='nonbrand'
		and website_sessions.created_at > '2012-08-22'
		and website_sessions.created_at < '2012-09-18'
group by 1,2;


-- 62 ---------------------------------------------
select MIN(DATE(created_at)) as week_start_date,
		COUNT(DISTINCT CASE WHEN utm_source='gsearch' and device_type='desktop' THEN website_session_id ELSE NULL END) as g_dtop_sessions,
        COUNT(DISTINCT CASE WHEN utm_source='bsearch' and device_type='desktop' THEN website_session_id ELSE NULL END) as b_dtop_sessions,
        COUNT(DISTINCT CASE WHEN utm_source='gsearch' and device_type='mobile' THEN website_session_id ELSE NULL END) as g_mob_sessions,
        COUNT(DISTINCT CASE WHEN utm_source='bsearch' and device_type='mobile' THEN website_session_id ELSE NULL END) as b_mob_sessions
from website_sessions
where website_sessions.created_at > '2012-11-04'
		and website_sessions.created_at < '2012-12-22'
        and utm_campaign ='nonbrand'
group by yearweek(created_at);

-- 65 -------------------------------------

select YEAR(created_at) as yr, MONTH(created_at) as mo,
		COUNT(DISTINCT CASE WHEN utm_campaign ='nonbrand' THEN website_session_id ELSE NULL END) as nonbrand,
        COUNT(DISTINCT CASE WHEN utm_campaign ='brand' THEN website_session_id ELSE NULL END) as brand,
        COUNT(DISTINCT CASE WHEN utm_campaign ='brand' THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN utm_campaign ='nonbrand' THEN website_session_id ELSE NULL END) as brand_pct_of_nonbrand,
        COUNT(DISTINCT CASE WHEN utm_campaign IS NULL and http_referer IS NULL  THEN website_session_id ELSE NULL END) as direct,
        COUNT(DISTINCT CASE WHEN utm_campaign IS NULL and http_referer IS NULL  THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN utm_campaign ='nonbrand' THEN website_session_id ELSE NULL END) as direct_pct_of_nonbrand,
        COUNT(DISTINCT CASE WHEN utm_campaign IS NULL AND http_referer IN ('https://www.gsearch.com','https://www.bsearch.com') THEN website_session_id ELSE NULL END) as organic,
        COUNT(DISTINCT CASE WHEN utm_campaign IS NULL AND http_referer IN ('https://www.gsearch.com','https://www.bsearch.com') THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN utm_campaign ='nonbrand' THEN website_session_id ELSE NULL END) as organic_pct_of_nonbrand
from website_sessions
where created_at <'2012-12-23'
GROUP BY 1,2;

-- 68 -------------------------------------------
select YEAR(website_sessions.created_at) as yr, MONTH(website_sessions.created_at) as mo, 
		COUNT(DISTINCT website_sessions.website_session_id) as sessions,
        COUNT(DISTINCT order_id) as orders
from website_sessions LEFT JOIN orders
	ON website_sessions.website_session_id = orders.website_session_id
where website_sessions.created_at<'2013-01-01'
group by 1,2;

select MIN(DATE(website_sessions.created_at)) as start_week_date, 
		COUNT(DISTINCT website_sessions.website_session_id) as sessions,
        COUNT(DISTINCT order_id) as orders
from website_sessions LEFT JOIN orders
	ON website_sessions.website_session_id = orders.website_session_id
where website_sessions.created_at<'2013-01-01'
group by week(website_sessions.created_at)
order by 1;

-- 70 ------------------------------------------
SELECT 
	hr,
    AVG(CASE WHEN wkday=0 THEN website_sessions ELSE NULL END) as mon,
    AVG(CASE WHEN wkday=1 THEN website_sessions ELSE NULL END) as tue,
    AVG(CASE WHEN wkday=2 THEN website_sessions ELSE NULL END) as wed,
    AVG(CASE WHEN wkday=3 THEN website_sessions ELSE NULL END) as thu,
    AVG(CASE WHEN wkday=4 THEN website_sessions ELSE NULL END) as fri,
    AVG(CASE WHEN wkday=5 THEN website_sessions ELSE NULL END) as sat,
    AVG(CASE WHEN wkday=6 THEN website_sessions ELSE NULL END) as sun
FROM (
select 
		DATE(created_at) as created_date,
        WEEKDAY(created_at) as wkday,
        HOUR(created_at) as hr,
        COUNT(DISTINCT website_session_id) as website_sessions
from website_sessions
where created_at between '2012-09-15' and '2012-11-15'
GROUP BY 1,2,3) daily_hourly_sessions
GROUP BY 1
;

