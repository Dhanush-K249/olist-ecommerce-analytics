USE olist;
-- 1. Product Category Translation
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/clean_product_category_name_translation.csv'
INTO TABLE product_category_name_translation
CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

-- 2. Sellers
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_sellers_dataset.csv'
INTO TABLE olist_sellers
CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

-- 3. Customers
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/clean_olist_customers_dataset.csv'
INTO TABLE olist_customers
CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

-- 4. Geolocation 
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/clean_olist_geolocation_dataset.csv'
INTO TABLE olist_geolocation
CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS
(geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, geolocation_state); 


-- 5. Products
SET FOREIGN_KEY_CHECKS = 0;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/clean_olist_products_dataset.csv'
INTO TABLE olist_products
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

INSERT INTO product_category_name_translation (product_category_name, product_category_name_english)
SELECT DISTINCT p.product_category_name, CONCAT(p.product_category_name, '_english_pending')
FROM olist_products p
LEFT JOIN product_category_name_translation t 
    ON p.product_category_name = t.product_category_name
WHERE t.product_category_name IS NULL 
  AND p.product_category_name IS NOT NULL 
  AND p.product_category_name != '';
SELECT * FROM product_category_name_translation;
SET FOREIGN_KEY_CHECKS = 1;

-- 6. Orders

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/clean_olist_orders_dataset.csv'
INTO TABLE olist_orders
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
-- Map columns to temporary variables
(@v_order_id, @v_customer_id, @v_status, @v_purchase, @v_approved, @v_carrier, @v_delivered, @v_estimated)
SET 
 order_id                      = @v_order_id,
 customer_id                  = @v_customer_id,
 order_status                 = @v_status,
 
 -- If the date variable is blank, insert NULL. Otherwise, insert the clean YYYY-MM-DD date.
 order_purchase_timestamp     = IF(@v_purchase = '', NULL, @v_purchase),
 order_approved_at            = IF(@v_approved = '', NULL, @v_approved),
 order_delivered_carrier_date = IF(@v_carrier = '', NULL, @v_carrier),
 order_delivered_customer_date = IF(@v_delivered = '', NULL, @v_delivered),
 order_estimated_delivery_date = IF(@v_estimated = '', NULL, @v_estimated);

-- 7. Order Items
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/clean_olist_order_items_dataset.csv'
INTO TABLE olist_order_items
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


-- 8. Order Payments
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/clean_olist_order_payments_dataset.csv'
INTO TABLE olist_order_payments
CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

-- 9. Order Reviews
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/clean_olist_order_reviews_dataset.csv'
INTO TABLE olist_order_reviews
CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;