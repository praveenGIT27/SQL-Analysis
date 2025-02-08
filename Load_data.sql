-- 1️⃣ Load Customers Data
COPY INTO ecommerce_schema.customers 
FROM @ecommerce_stage/customers.csv 
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"');

-- 2️⃣ Load Sellers Data
COPY INTO ecommerce_schema.sellers 
FROM @ecommerce_stage/sellers.csv 
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"');

-- 3️⃣ Load Orders Data
COPY INTO ecommerce_schema.orders 
FROM @ecommerce_stage/orders.csv 
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"');

-- 4️⃣ Load Order Items Data
COPY INTO ecommerce_schema.order_items 
FROM @ecommerce_stage/order_items.csv 
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"');

-- 5️⃣ Load Payments Data
COPY INTO ecommerce_schema.payments 
FROM @ecommerce_stage/payments.csv 
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"');

-- 6️⃣ Load Products Data
COPY INTO ecommerce_schema.products 
FROM @ecommerce_stage/products.csv 
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"');

-- 7️⃣ Load Reviews Data
COPY INTO ecommerce_schema.reviews 
FROM @ecommerce_stage/order_reviews.csv 
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"');

-- 8️⃣ Load Geolocation Data
COPY INTO ecommerce_schema.geolocation 
FROM @ecommerce_stage/geolocation.csv 
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"');

-- 9️⃣ Load Product Category Translation Data
COPY INTO ecommerce_schema.product_category_translation 
FROM @ecommerce_stage/product_category_name_translation.csv 
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"');
