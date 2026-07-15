USE olist;
WITH RECURSIVE calender AS (
SELECT '2016-09' AS calender_month
UNION ALL
SELECT DATE_FORMAT(CONCAT(calender_month,'-01')+INTERVAL 1 MONTH,'%Y-%m')
FROM calender
WHERE calender_month<'2018-09'
),
cohort_table AS(
SELECT 
c.customer_unique_id,
DATE_FORMAT(MIN(o.order_purchase_timestamp), '%Y-%m') AS cohort_month,
SUM(oi.price) AS total_revenue
FROM olist_customers c JOIN
olist_orders o ON c.customer_id=o.customer_id
JOIN olist_order_items oi
ON o.order_id=oi.order_id
WHERE o.order_status="delivered"
GROUP BY c.customer_unique_id
)
SELECT c.calender_month AS cohort_month,
COALESCE(COUNT(ct.customer_unique_id),0) AS total_customers_gained,
COALESCE(SUM(ct.total_revenue),0) total_cohort_revenue,
COALESCE(ROUND(AVG(ct.total_revenue)),0) AS average_cohort_revenue
FROM cohort_table ct RIGHT JOIN calender c ON c.calender_month=ct.cohort_month
GROUP BY c.calender_month
ORDER BY c.calender_month
;