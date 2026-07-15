USE olist;
WITH RECURSIVE calender AS(
SELECT '2016-09' AS calender_month
UNION ALL
SELECT DATE_FORMAT(STR_TO_DATE(CONCAT(calender_month,'-01'),'%Y-%m-%d')+INTERVAL 1 MONTH,'%Y-%m')
FROM calender
WHERE calender_month<'2018-08'
),


revenues AS(
SELECT DATE_FORMAT(o.order_purchase_timestamp,'%Y-%m') as months,
SUM(oi.price) AS month_revenue
FROM olist_orders o JOIN olist_order_items oi ON oi.order_id=o.order_id
GROUP BY months
),
complete_timeline AS(
SELECT c.calender_month,
COALESCE(r.month_revenue,0) AS month_revenue
FROM calender c LEFT JOIN revenues r ON r.months=c.calender_month)
SELECT calender_month,
month_revenue,
AVG(month_revenue) OVER(ORDER BY calender_month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_avg
FROM complete_timeline;
-- SELECT c.calender_month,
-- COALESCE(SUM(oi.price),0) AS month_revenue,
-- AVG(COALESCE(SUM(oi.price),0)) OVER(ORDER BY c.calender_month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_avg
-- FROM olist_orders o JOIN
-- olist_order_items oi ON oi.order_id=o.order_id
-- RIGHT JOIN calender c ON DATE_FORMAT(o.order_purchase_timestamp,'%Y-%m')=c.calender_month
-- GROUP BY c.calender_month;