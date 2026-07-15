USE olist;
WITH performances AS(
SELECT s.seller_id,AVG(orv.review_score) AS avg_rating,SUM(oi.price) AS total_revenue,
AVG(DATEDIFF(o.order_delivered_customer_date,o.order_purchase_timestamp)) AS average_shipping_days,
COUNT(o.order_id) AS total_orders
FROM olist_sellers s JOIN
olist_order_items oi
ON s.seller_id=oi.seller_id
JOIN olist_orders o 
ON o.order_id=oi.order_id
JOIN olist_order_reviews orv
ON orv.order_id=o.order_id
WHERE o.order_status="delivered"
GROUP BY s.seller_id
),
seller_tiers AS(SELECT seller_id,avg_rating,total_revenue,average_shipping_days,
CASE
   WHEN (avg_rating>=4.3 AND total_revenue>=5000.0 AND average_shipping_days<=10) AND total_orders>7 THEN "Elite"
   WHEN (avg_rating<=3.2 OR total_revenue<=2200 or average_shipping_days>=16) AND total_orders>7 THEN "Low"
   ELSE "Mid" END
AS seller_tier
FROM performances)
SELECT * FROM seller_tiers;