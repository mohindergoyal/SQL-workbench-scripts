-- lesson 42

CREATE TEMPORARY TABLE first_pageviews
SELECT
	website_session_id,
    count(website_pageview_id) as cnt_pages
FROM website_pageviews
where created_at <'2012-06-14'
GROUP BY
	website_session_id;
    

select count(DISTINCT website_session_id) as sessions,
		count(CASE when cnt_pages=1 THEN website_session_id ELSE NULL END) as bounced_sessions,
        count(CASE when cnt_pages=1 THEN website_session_id ELSE NULL END)/count(DISTINCT website_session_id) as bounce_rate
from first_pageviews;


-- video 43

CREATE TEMPORARY TABLE part1
select * from website_pageviews
where created_at = 
(select MIN(created_at) as first_created_at
from website_pageviews
where pageview_url ='/lander-1');

-- DROP TABLE part1;
-- DROP TABLE first_pageviews;

CREATE TEMPORARY TABLE first_pageviews
SELECT
	website_pageviews.website_session_id,
    count(website_pageview_id) as cnt_pages
FROM website_pageviews INNER JOIN website_sessions
		ON 	website_pageviews.website_session_id=website_sessions.website_session_id
where website_pageviews.created_at > '2012-06-18 20:35:54' and website_pageviews.created_at<'2012-07-28'
AND utm_source='gsearch'
AND utm_campaign='nonbrand'
GROUP BY
	website_pageviews.website_session_id;

select w1.pageview_url as landing_page, count(w1.website_session_id) as total_sessions,
		count(CASE WHEN cnt_pages=1 THEN t1.website_session_id ELSE NULL END) as bounced_sessions,
        count(CASE WHEN cnt_pages=1 THEN t1.website_session_id ELSE NULL END)/count(w1.website_session_id) as bounce_rate
from first_pageviews t1, website_pageviews w1
where w1.website_session_id = t1.website_session_id
and w1.pageview_url IN ('/home','/lander-1')
group by w1.pageview_url;


-- video 44

CREATE TEMPORARY TABLE first_page
SELECT
	website_pageviews.website_session_id,
    count(website_pageview_id) as cnt_pages,
    FIRST_VALUE(pageview_url) over(partition by website_pageviews.website_session_id order by website_pageview_id) as first_url_visited
FROM website_pageviews INNER JOIN website_sessions
		ON 	website_pageviews.website_session_id=website_sessions.website_session_id
where website_pageviews.created_at > '2012-06-01' and website_pageviews.created_at<'2012-08-31'
AND utm_source='gsearch'
AND utm_campaign='nonbrand'
GROUP BY
	website_pageviews.website_session_id;
    
select first_url_visited, count(website_session_id) 
 from first_page
 group by first_url_visited;
 
 select * from first_page;

select MIN(DATE(created_at)) as week_start_date, 
		COUNT(DISTINCT CASE WHEN first_page.cnt_pages=1 THEN first_page.website_session_id ELSE NULL END)/count(DISTINCT first_page.website_session_id) as bounce_rate,
        COUNT(DISTINCT CASE WHEN first_page.cnt_pages=1 THEN first_page.website_session_id ELSE NULL END) as bounced_sessions,
		COUNT(DISTINCT CASE WHEN first_page.first_url_visited='/home' THEN first_page.website_session_id ELSE NULL END) as home_sessions,
        COUNT(DISTINCT CASE WHEN first_page.first_url_visited='/lander-1' THEN first_page.website_session_id ELSE NULL END) as lander_sessions
from website_pageviews JOIN first_page
ON website_pageviews.website_session_id = first_page.website_session_id
where website_pageviews.created_at > '2012-06-01' and website_pageviews.created_at<'2012-08-31'
group by week(created_at);


-- video 48

CREATE TEMPORARY TABLE temp_table2
select website_pageviews.website_session_id, FIRST_VALUE(pageview_url) over(partition by website_pageviews.website_session_id order by website_pageview_id) as first_page
 from website_pageviews JOIN website_sessions
 ON website_pageviews.website_session_id = website_sessions.website_session_id
where website_pageviews.created_at between '2012-08-05' AND '2012-09-05'
and utm_source='gsearch' and website_sessions.utm_campaign='nonbrand';

CREATE TEMPORARY TABLE temp_table 
select website_session_id,
		CASE WHEN pageview_url='/products' THEN 1 ELSE 0 END AS to_products,
        CASE WHEN pageview_url='/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS to_mrfuzzy,
        CASE WHEN pageview_url='/cart' THEN 1 ELSE 0 END AS to_cart,
        CASE WHEN pageview_url='/shipping' THEN 1 ELSE 0 END AS to_ship,
        CASE WHEN pageview_url like '/billing%' THEN 1 ELSE 0 END AS to_biling,
        CASE WHEN pageview_url like '/thank%' THEN 1 ELSE 0 END AS to_thankyou
from website_pageviews
where website_pageviews.created_at between '2012-08-05' AND '2012-09-05';

select DISTINCT pageview_url from website_pageviews;

CREATE TEMPORARY TABLE temp_table3
select website_session_id, 
		MAX(to_products) as to_products,
        MAX(to_mrfuzzy) as to_mrfuzzy,
        MAX(to_cart) as to_cart,
        MAX(to_ship) as to_ship,
        MAX(to_biling) as to_billing,
        MAX(to_thankyou) as to_thankyou
 from temp_table
 group by website_session_id;
 
 
 select count(DISTINCT temp_table2.website_session_id) as sessions,
		count(DISTINCT CASE WHEN temp_table3.to_products=1 THEN temp_table3.website_session_id ELSE NULL END) as yo_products,
        count(DISTINCT CASE WHEN temp_table3.to_mrfuzzy=1 THEN temp_table3.website_session_id ELSE NULL END) as yo_mrfuzzy,
        count(DISTINCT CASE WHEN temp_table3.to_cart=1 THEN temp_table3.website_session_id ELSE NULL END) as yo_cart,
        count(DISTINCT CASE WHEN temp_table3.to_ship=1 THEN temp_table3.website_session_id ELSE NULL END) as yo_ship,
        count(DISTINCT CASE WHEN temp_table3.to_billing=1 THEN temp_table3.website_session_id ELSE NULL END) as yo_billing,
        count(DISTINCT CASE WHEN temp_table3.to_thankyou=1 THEN temp_table3.website_session_id ELSE NULL END) as yo_thankyou
from temp_table2 JOIN temp_table3 ON temp_table2.website_session_id = temp_table3.website_session_id;
 
 
  select count(DISTINCT temp_table2.website_session_id) as sessions,
		count(DISTINCT CASE WHEN temp_table3.to_products=1 THEN temp_table3.website_session_id ELSE NULL END)/count(DISTINCT temp_table2.website_session_id) as yo_products,
        count(DISTINCT CASE WHEN temp_table3.to_mrfuzzy=1 THEN temp_table3.website_session_id ELSE NULL END)/count(DISTINCT temp_table2.website_session_id) as yo_mrfuzzy,
        count(DISTINCT CASE WHEN temp_table3.to_cart=1 THEN temp_table3.website_session_id ELSE NULL END)/count(DISTINCT temp_table2.website_session_id) as yo_cart,
        count(DISTINCT CASE WHEN temp_table3.to_ship=1 THEN temp_table3.website_session_id ELSE NULL END)/count(DISTINCT temp_table2.website_session_id) as yo_ship,
        count(DISTINCT CASE WHEN temp_table3.to_billing=1 THEN temp_table3.website_session_id ELSE NULL END)/count(DISTINCT temp_table2.website_session_id) as yo_billing,
        count(DISTINCT CASE WHEN temp_table3.to_thankyou=1 THEN temp_table3.website_session_id ELSE NULL END)/count(DISTINCT temp_table2.website_session_id) as yo_thankyou
from temp_table2 JOIN temp_table3 ON temp_table2.website_session_id = temp_table3.website_session_id;


-- video 50

select MIN(created_at) as start_date, MIN(website_pageview_id) as first_pageview_id
 from website_pageviews
where pageview_url='/billing-2';


select website_pageviews.website_session_id,
		website_pageviews.pageview_url as billing_version_seen, orders.order_id
from website_pageviews LEFT JOIN orders 
		ON orders.website_session_id = website_pageviews.website_session_id
where website_pageview_id>=53550
and website_pageviews.created_at <'2012-11-10'
and website_pageviews.pageview_url IN ('/billing','/billing-2');

select 
	billing_version_seen,
    COUNT(DISTINCT website_session_id) as sessions,
    COUNT(DISTINCT order_id) as orders,
    COUNT(DISTINCT order_id)/COUNT(DISTINCT website_session_id) as billing_to_order_rate
from (
	select website_pageviews.website_session_id,
		website_pageviews.pageview_url as billing_version_seen, orders.order_id
from website_pageviews LEFT JOIN orders 
		ON orders.website_session_id = website_pageviews.website_session_id
where website_pageview_id>=53550
and website_pageviews.created_at <'2012-11-10'
and website_pageviews.pageview_url IN ('/billing','/billing-2')
	  ) as billing_order_details
group by billing_version_seen;


