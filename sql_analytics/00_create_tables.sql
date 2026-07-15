CREATE DATABASE IF NOT EXISTS olist;
USE olist;


-- LAYER 1: Independent Parent Tables (No Dependencies)

-- 1. Product Category Translation Lookup
CREATE TABLE product_category_name_translation (
    product_category_name VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100) NOT NULL
);

-- 2. Cleaned Sellers Dimension
CREATE TABLE olist_sellers (
    seller_id CHAR(32) PRIMARY KEY,
    seller_zip_code_prefix INT NOT NULL,
    seller_city VARCHAR(100) NOT NULL,
    seller_state CHAR(2) NOT NULL
);

-- 3. Cleaned Customers Dimension
CREATE TABLE olist_customers (
    customer_id CHAR(32) PRIMARY KEY,
    customer_unique_id CHAR(32) NOT NULL,
    customer_zip_code_prefix INT NOT NULL,
    customer_city VARCHAR(100) NOT NULL,
    customer_state CHAR(2) NOT NULL
);

-- 4. Cleaned Geolocation Table (Independent Spatial Data)
CREATE TABLE olist_geolocation (
    geolocation_zip_code_prefix INT NOT NULL,
    geolocation_lat DECIMAL(10, 8) NOT NULL,
    geolocation_lng DECIMAL(11, 8) NOT NULL,
    geolocation_city VARCHAR(100) NOT NULL,
    geolocation_state CHAR(2) NOT NULL
);


-- LAYER 2: First-Level Dependent Tables

-- 5. Products Catalog (Depends on Category Translation)
CREATE TABLE olist_products (
    product_id CHAR(32) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght INT,  -- Keeping original Olist column spelling typos
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT,
    FOREIGN KEY (product_category_name) REFERENCES product_category_name_translation(product_category_name)
    ON DELETE SET NULL ON UPDATE CASCADE
);

-- 6. Orders Master Table (Depends on Customers)
CREATE TABLE olist_orders (
    order_id CHAR(32) PRIMARY KEY,
    customer_id CHAR(32) NOT NULL,
    order_status VARCHAR(30) NOT NULL,
    order_purchase_timestamp DATETIME NOT NULL,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME,
    FOREIGN KEY (customer_id) REFERENCES olist_customers(customer_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
);



-- LAYER 3: Child Tables (Multi-Dependency)


-- 7. Order Items (Depends on Orders, Products, and Sellers)
CREATE TABLE olist_order_items (
    order_id CHAR(32) NOT NULL,
    order_item_id INT NOT NULL, -- Sequential number showing number of items in same order
    product_id CHAR(32) NOT NULL,
    seller_id CHAR(32) NOT NULL,
    shipping_limit_date DATETIME NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    freight_value DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (order_id, order_item_id), -- Composite primary key
    FOREIGN KEY (order_id) REFERENCES olist_orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES olist_products(product_id),
    FOREIGN KEY (seller_id) REFERENCES olist_sellers(seller_id)
);

-- 8. Order Payments (Depends on Orders)
CREATE TABLE olist_order_payments (
    order_id CHAR(32) NOT NULL,
    payment_sequential INT NOT NULL,
    payment_type VARCHAR(30) NOT NULL,
    payment_installments INT NOT NULL,
    payment_value DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (order_id, payment_sequential), -- Composite primary key
    FOREIGN KEY (order_id) REFERENCES olist_orders(order_id) ON DELETE CASCADE
);

-- 9. Order Reviews (Depends on Orders)
CREATE TABLE olist_order_reviews (
    review_id CHAR(32) NOT NULL,
    order_id CHAR(32) NOT NULL,
    review_score INT NOT NULL CHECK (review_score BETWEEN 1 AND 5),
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date DATETIME NOT NULL,
    review_answer_timestamp DATETIME,
    PRIMARY KEY (review_id, order_id), -- Composite primary key (since one order can have multiple reviews)
    FOREIGN KEY (order_id) REFERENCES olist_orders(order_id) ON DELETE CASCADE
);