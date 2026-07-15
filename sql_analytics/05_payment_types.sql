USE olist;
SELECT 
    op.payment_type,
    COUNT(DISTINCT o.order_id) AS total_transactions, 
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue,
    ROUND(AVG(oi.price + oi.freight_value), 2) AS average_order_value,
    ROUND(AVG(op.payment_installments), 2) AS average_installments
FROM olist_orders o
JOIN olist_order_payments op ON o.order_id = op.order_id
JOIN olist_order_items oi    ON oi.order_id = o.order_id

WHERE LOWER(o.order_status) NOT IN ('canceled', 'unavailable', 'unknown') 
GROUP BY op.payment_type;