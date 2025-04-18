-- 1) The below query gives the top 5 cities with the maximum revenue

query = """
SELECT TOP 5 
       c.customer_state,
       c.customer_city, 
       COUNT(o.order_id) AS total_orders,
       SUM(oi.price) AS total_revenue
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_purchase_timestamp BETWEEN CAST('2016-01-01' AS DATETIME2) 
                                     AND CAST('2018-12-31' AS DATETIME2)
GROUP BY c.customer_state, c.customer_city
ORDER BY total_revenue DESC;
"""

df = pd.read_sql_query(query, conn)
print(df)

--2) Query that identifies the purchase trend year over year.

query = """
SELECT
    a.month AS month_no,
    DATENAME(MONTH, DATEFROMPARTS(2000, a.month, 1)) AS month_name,
    SUM(CASE WHEN a.year = 2016 THEN 1 ELSE 0 END) AS Year2016,
    SUM(CASE WHEN a.year = 2017 THEN 1 ELSE 0 END) AS Year2017,
    SUM(CASE WHEN a.year = 2018 THEN 1 ELSE 0 END) AS Year2018
FROM (
    SELECT 
        customer_id,
        order_id,
        order_delivered_customer_date,  
        order_status,
        YEAR(order_delivered_customer_date) AS year,
        MONTH(order_delivered_customer_date) AS month
    FROM orders
    WHERE order_status = 'delivered' AND order_delivered_customer_date IS NOT NULL
) a
GROUP BY a.month
ORDER BY month_no ASC;
"""

df = pd.read_sql_query(query, conn)
print(df)



--3) Monthly churn rate of customers

query = """
WITH customer_activity AS (
    SELECT 
        customer_id, 
        DATEFROMPARTS(YEAR(order_purchase_timestamp), MONTH(order_purchase_timestamp), 1) AS month
    FROM orders
    GROUP BY customer_id, DATEFROMPARTS(YEAR(order_purchase_timestamp), MONTH(order_purchase_timestamp), 1)
),
monthly_churn AS (
    SELECT 
        month,
        COUNT(DISTINCT customer_id) AS active_customers,
        LAG(COUNT(DISTINCT customer_id)) OVER (ORDER BY month) AS previous_month_customers
    FROM customer_activity
    GROUP BY month
)
SELECT 
    month, 
    active_customers,
    previous_month_customers,
    (previous_month_customers - active_customers) * 100.0 / NULLIF(previous_month_customers, 0) AS churn_rate
FROM monthly_churn
WHERE previous_month_customers IS NOT NULL;
"""

df = pd.read_sql_query(query, conn)
print(df)



--4) The  query analyzes the monthly revenue and average review score for each month in 2018, using the order_items table for calculating revenue and the order_reviews table for calculating review scores.


query = """
SELECT 
    revenue.year,
    revenue.month_name,
    revenue.total_revenue,
    reviews.average_review_score,
    COALESCE(payments.total_payment, 0) AS total_payment,
    payments.payment_type

FROM 
    (SELECT 
        MONTH(oi.shipping_limit_date) AS month,
        YEAR(oi.shipping_limit_date) AS year,
        DATENAME(MONTH, oi.shipping_limit_date) AS month_name,  
        SUM(oi.price) AS total_revenue
    FROM order_items oi
    WHERE oi.shipping_limit_date BETWEEN '2016-01-01' AND '2018-12-31'
    GROUP BY YEAR(oi.shipping_limit_date), MONTH(oi.shipping_limit_date), DATENAME(MONTH, oi.shipping_limit_date)
    ) revenue

LEFT JOIN (
    SELECT 
        MONTH(oi.shipping_limit_date) AS month,
        AVG(r.review_score) AS average_review_score
    FROM order_items oi
    JOIN reviews r ON oi.order_id = r.order_id
    GROUP BY MONTH(oi.shipping_limit_date)
    ) reviews
ON revenue.month = reviews.month

LEFT JOIN (
    SELECT 
        MONTH(o.order_purchase_timestamp) AS month,
        YEAR(o.order_purchase_timestamp) AS year, 
        SUM(p.payment_value) AS total_payment,
        p.payment_type
    FROM payments p
    JOIN orders o ON p.order_id = o.order_id
    GROUP BY YEAR(o.order_purchase_timestamp), MONTH(o.order_purchase_timestamp), p.payment_type
    ) payments

ON revenue.year = payments.year AND revenue.month = payments.month
ORDER BY revenue.year, revenue.month;
"""

df = pd.read_sql_query(query, conn)
print(df)



