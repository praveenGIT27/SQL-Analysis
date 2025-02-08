-- 1) The below query gives the top 5 cities with the maximum revenue

SELECT c.customer_state,
       c.customer_city, 
       COUNT(o.order_id) AS total_orders,
       SUM(oi.price) AS total_revenue
FROM ecommerce_schema.order_items oi
JOIN ecommerce_schema.orders o ON oi.order_id = o.order_id
JOIN ecommerce_schema.customers c ON o.customer_id = c.customer_id
WHERE o.order_purchase_timestamp BETWEEN '2016-01-01' AND '2018-12-31'
GROUP BY c.customer_state, c.customer_city
ORDER BY total_revenue DESC
LIMIT 5;


--- Impact: The query identifies cities and states with the highest revenue and order volumes, helping the business understand where their most valuable customers are located.

--- Use Case:
--- Prioritize marketing efforts in high-revenue areas.
--- Optimize inventory and delivery logistics for cities with high demand.
 


--2) Monthly churn rate of customers

-- Impact :Helps predict customer behavior and build strategies to reduce churn.

WITH customer_activity AS (
    SELECT customer_id, DATE_TRUNC('month', order_purchase_timestamp) AS month
    FROM ecommerce_schema.orders
    GROUP BY customer_id, DATE_TRUNC('month', order_purchase_timestamp)
),
monthly_churn AS (
    SELECT month,
           COUNT(DISTINCT customer_id) AS active_customers,
           LAG(COUNT(DISTINCT customer_id)) OVER (ORDER BY month) AS previous_month_customers
    FROM customer_activity
    GROUP BY month
)
SELECT month, 
       active_customers,
       previous_month_customers,
       (previous_month_customers - active_customers) * 100 / previous_month_customers AS churn_rate
FROM monthly_churn
WHERE previous_month_customers IS NOT NULL;


--3) Query that identifies the purchase trend year over year.
--Impact: Helps determine peak sales months and off-peak periods.
--Use Case:
---Boost inventory during high-demand months.
---Run promotional campaigns to improve sales during slower months.
---Prepare logistics and staffing plans for seasonal spikes.


select
    a.month as month_no,
    CASE
        WHEN a.month = 1 then 'Jan'
        WHEN a.month = 2 then 'Fe'
        WHEN a.month = 3 then 'Mar'
        WHEN a.month = 4 then 'Apr'
        WHEN a.month = 5 then 'May'
        WHEN a.month = 6 then 'Jun'
        WHEN a.month = 7 then 'July'
        WHEN a.month = 8 then 'Aug'
        WHEN a.month = 9 then 'Sep'
        WHEN a.month = 10 then 'Oct'
        WHEN a.month = 11 then 'Nov'
        WHEN a.month = 12 then 'Dec'
    END AS month_name,
    sum(case when a.year = 2016 then 1 else 0 end) as Year2016,
    sum(case when a.year= 2017 then 1 else 0 end) as Year2017,
    sum(case when a.year= 2018 then 1 else 0 end) as Year2018,
FROM (
    select 
        customer_id,
        order_id,
        order_delivered_customer_date,  
        order_status,
        EXTRACT(YEAR FROM order_delivered_customer_date) AS year,
        EXTRACT(MONTH FROM order_delivered_customer_date) AS month,
    from ecommerce_schema.orders
    where order_status = 'delivered' and order_delivered_customer_date is not NULL
    order by order_delivered_customer_date asc) a
group by a.month
order by month_no asc;