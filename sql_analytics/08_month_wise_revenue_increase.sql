WITH RECURSIVE calender AS (
    SELECT '2016-09' AS calender_month
    UNION ALL
    SELECT DATE_FORMAT(STR_TO_DATE(CONCAT(calender_month, '-01'), '%Y-%m-%d') + INTERVAL 1 MONTH, '%Y-%m')
    FROM calender
    WHERE calender_month < '2018-08'
),
month_revenues AS (
SELECT DATE_FORMAT(o.order_purchase_timestamp,'%Y-%m') AS present_month,
SUM(oi.price) AS month_revenue FROM olist_orders o JOIN olist_order_items oi ON oi.order_id=o.order_id
WHERE o.order_status="delivered"
GROUP BY present_month
),
complete_timeline AS (
SELECT c.calender_month AS current_month,
COALESCE(m.month_revenue,0) AS current_month_revenue
FROM calender c LEFT JOIN month_revenues m ON c.calender_month=m.present_month
),
current_and_prev AS(
SELECT *,LAG(current_month_revenue,1) over(ORDER BY current_month) AS prev_month_revenue
FROM complete_timeline
)
SELECT *,ROUND(((current_month_revenue-prev_month_revenue)/prev_month_revenue)*100,2) AS percentage_increase_in_revenue
FROM current_and_prev;