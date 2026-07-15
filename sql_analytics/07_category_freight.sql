USE olist;
WITH orders AS(
SELECT 
p.product_category_name,
SUM(oi.price) AS total_product_revenue,
AVG(oi.freight_value) AS avg_freight_value,
ROUND((SUM(oi.freight_value)/SUM(oi.freight_value + oi.price))*100,2) AS freight_drag_percentage
FROM olist_products p JOIN olist_order_items oi ON p.product_id=oi.product_id
GROUP BY p.product_category_name
)
SELECT
et.product_category_name_english,
total_product_revenue,
avg_freight_value,
freight_drag_percentage
FROM product_category_name_translation et JOIN orders o ON et.product_category_name=o.product_category_name
ORDER BY freight_drag_percentage DESC;