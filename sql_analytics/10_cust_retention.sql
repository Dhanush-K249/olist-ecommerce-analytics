USE olist;
WITH RECURSIVE calender AS(
    SELECT '2016-09' AS calender_month
    UNION ALL
    SELECT DATE_FORMAT(STR_TO_DATE(CONCAT(calender_month,'-01'), '%Y-%m-%d') + INTERVAL 1 MONTH,'%Y-%m')
    FROM calender 
    WHERE calender_month < '2018-08'
),
cohort_customers AS(
    SELECT c.customer_unique_id,
           DATE_FORMAT(MIN(o.order_purchase_timestamp),'%Y-%m') AS cohort_month
    FROM olist_customers c 
    JOIN olist_orders o ON o.customer_id=c.customer_id
    WHERE o.order_status="delivered"
    GROUP BY c.customer_unique_id
)
SELECT 
cal.calender_month AS cohort_month,
COUNT(DISTINCT CASE WHEN cc.cohort_month = cal.calender_month THEN cc.customer_unique_id END) AS cust_gained,
COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.order_purchase_timestamp,'%Y-%m') = DATE_FORMAT(STR_TO_DATE(CONCAT(cal.calender_month,'-01'), '%Y-%m-%d') + INTERVAL 1 MONTH,'%Y-%m') THEN cc.customer_unique_id END) AS month_1_retention,
COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.order_purchase_timestamp,'%Y-%m') = DATE_FORMAT(STR_TO_DATE(CONCAT(cal.calender_month,'-01'), '%Y-%m-%d') + INTERVAL 2 MONTH,'%Y-%m') THEN cc.customer_unique_id END) AS month_2_retention,
COUNT(DISTINCT CASE WHEN DATE_FORMAT(o.order_purchase_timestamp,'%Y-%m') = DATE_FORMAT(STR_TO_DATE(CONCAT(cal.calender_month,'-01'), '%Y-%m-%d') + INTERVAL 3 MONTH,'%Y-%m') THEN cc.customer_unique_id END) AS month_3_retention
FROM cohort_customers cc 
RIGHT JOIN calender cal ON cal.calender_month = cc.cohort_month
LEFT JOIN olist_customers cust ON cust.customer_unique_id = cc.customer_unique_id
LEFT JOIN olist_orders o ON o.customer_id = cust.customer_id AND o.order_status = 'delivered'
GROUP BY cal.calender_month
ORDER BY cal.calender_month;