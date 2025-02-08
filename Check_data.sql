-- Customers Table
SELECT COUNT(*) AS total_customers FROM ecommerce_schema.customers;
SELECT COUNT(*) AS total_geolocations FROM ecommerce_schema.geolocation;
SELECT COUNT(*) AS total_orders FROM ecommerce_schema.orders;
SELECT COUNT(*) AS total_order_items FROM ecommerce_schema.order_items;
SELECT COUNT(*) AS total_payments FROM ecommerce_schema.payments;
SELECT COUNT(*) AS total_products FROM ecommerce_schema.products;
SELECT COUNT(*) AS total_reviews FROM ecommerce_schema.reviews;
SELECT COUNT(*) AS total_sellers FROM ecommerce_schema.sellers;
SELECT COUNT(*) AS total_product_categories FROM ecommerce_schema.product_category_translation;

SELECT *
FROM table(information_schema.copy_history(
    table_name => 'GEOLOCATION',
    start_time => DATEADD(day, -1, CURRENT_TIMESTAMP),
    end_time => CURRENT_TIMESTAMP
))
ORDER BY last_load_time DESC;