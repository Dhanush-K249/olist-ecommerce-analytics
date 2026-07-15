USE olist;
SELECT c.customer_city AS city,
COUNT( DISTINCT o.order_id) AS total_orders,
AVG(oi.freight_value) AS avg_freight_value,
ROUND((SUM(oi.freight_value)/SUM(oi.price + oi.freight_value))*100,2) AS freight_percentage
FROM olist_customers c 
JOIN olist_orders o
ON c.customer_id=o.customer_id
JOIN olist_order_items oi ON o.order_id=oi.order_id
WHERE o.order_status="delivered"
GROUP BY c.customer_city
HAVING total_orders>20
ORDER BY  freight_percentage DESC;