select * from website_pageviews;

CREATE TEMPORARY TABLE pv_land
select website_session_id, MIN(website_pageview_id) as pv_landed
from website_pageviews
where created_at<DATE('2012-06-12')
GROUP BY website_session_id;

select * from pv_land;

CREATE TEMPORARY TABLE land_session
select pageview_url, COUNT(pv_land.website_session_id) as sessions
from pv_land LEFT JOIN website_pageviews
on pv_land.pv_landed = website_pageviews.website_pageview_id;

select * from land_session;


CREATE TEMPORARY TABLE single_session
select website_session_id
 from website_pageviews
 where created_at<DATE('2012-06-12')
 GROUP BY website_session_id
 HAVING count(DISTINCT website_pageview_id)=1;
 
 CREATE TEMPORARY TABLE bounce_count
 select COUNT(DISTINCT website_session_id) as count_bounced from single_session;
 
 select sessions from land_session;
 select count_bounced from bounce_count;
 
 select sessions, count_bounced, count_bounced/sessions as bounce_rate
 from land_session, bounce_count;
