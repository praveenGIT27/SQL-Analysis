CREATE TABLE ecommerce_schema.customers (
    customer_id STRING PRIMARY KEY,
    customer_unique_id STRING,
    customer_zip_code_prefix INT,
    customer_city STRING,
    customer_state STRING
);



CREATE TABLE ecommerce_schema.sellers (
    seller_id STRING PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city STRING,
    seller_state STRING
);


CREATE TABLE ecommerce_schema.orders (
    order_id STRING PRIMARY KEY,
    customer_id STRING,
    order_status STRING,
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP NULL,
    order_delivered_carrier_date TIMESTAMP NULL,
    order_delivered_customer_date TIMESTAMP NULL,
    order_estimated_delivery_date TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES ecommerce_schema.customers(customer_id)
);


CREATE TABLE ecommerce_schema.order_items (
    order_id STRING,
    order_item_id INT,
    product_id STRING,
    seller_id STRING,
    shipping_limit_date TIMESTAMP,
    price FLOAT,
    freight_value FLOAT,
    PRIMARY KEY (order_id, order_item_id),
    FOREIGN KEY (order_id) REFERENCES ecommerce_schema.orders(order_id),
    FOREIGN KEY (seller_id) REFERENCES ecommerce_schema.sellers(seller_id)
);


CREATE TABLE ecommerce_schema.payments (
    order_id STRING,
    payment_sequential INT,
    payment_type STRING,
    payment_installments INT,
    payment_value FLOAT,
    PRIMARY KEY (order_id, payment_sequential),
    FOREIGN KEY (order_id) REFERENCES ecommerce_schema.orders(order_id)
);


CREATE TABLE ecommerce_schema.products (
    product_id STRING PRIMARY KEY,
    product_category_name STRING,
    product_name_length INT NULL,
    product_description_length INT NULL,
    product_photos_qty INT NULL,
    product_weight_g INT NULL,
    product_length_cm INT NULL,
    product_height_cm INT NULL,
    product_width_cm INT NULL
);


CREATE TABLE ecommerce_schema.reviews (
    review_id STRING PRIMARY KEY,
    order_id STRING,
    review_score INT,
    review_creation_date DATE,
    review_answer_timestamp TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES ecommerce_schema.orders(order_id)
);


CREATE TABLE ecommerce_schema.geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat FLOAT,
    geolocation_lng FLOAT,
    geolocation_city STRING,
    geolocation_state STRING
);


CREATE TABLE ecommerce_schema.product_category_translation (
    product_category_name STRING PRIMARY KEY,
    product_category_name_english STRING
);


SHOW TABLES IN ecommerce_schema;
