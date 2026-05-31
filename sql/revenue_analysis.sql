-- Total revenue per month
WITH revenue_month AS(
	SELECT o.order_purchase_timestamp,oi.sum_original_and_freight_value FROM orders o JOIN order_items oi ON o.order_id=oi.order_id
)
SELECT DATE_TRUNC('month',order_purchase_timestamp) AS date,ROUND(SUM(sum_original_and_freight_value)::NUMERIC,2) AS total_revenue FROM revenue_month GROUP BY DATE_TRUNC('month',order_purchase_timestamp);

-- Monthly GMV growth rate
WITH month_gmv AS (
	SELECT DATE_TRUNC('month',o.order_purchase_timestamp) AS month, SUM(oi.sum_original_and_freight_value) AS current_gmv FROM orders o JOIN order_items oi ON o.order_id=oi.order_id GROUP BY DATE_TRUNC('month',o.order_purchase_timestamp)
),
gmv_lag AS (
	SELECT month,current_gmv,LAG(current_gmv) OVER(ORDER BY month) AS previous_gmv FROM month_gmv
)
SELECT month,ROUND(current_gmv::NUMERIC,2) AS current_gmv,ROUND(previous_gmv::NUMERIC,2) AS previous_gmv,ROUND(((((current_gmv-previous_gmv)/previous_gmv)*100)::NUMERIC),2) AS growth_percentage FROM gmv_lag ORDER BY month;

-- Top 10 product categories by total revenue
WITH product_revenue AS (
	SELECT p.product_category_name,pt.product_category_name_english, oi.sum_original_and_freight_value FROM products p JOIN order_items oi ON p.product_id=oi.product_id JOIN product_category_name_translation pt ON p.product_category_name=pt.product_category_name 
)
SELECT product_category_name_english,ROUND(SUM(sum_original_and_freight_value)::NUMERIC,2) AS total_revenue FROM product_revenue GROUP BY product_category_name_english ORDER BY SUM(sum_original_and_freight_value) DESC LIMIT 10;

-- Revenue contribution % per state
WITH revenue_per_state AS (
	SELECT oi.order_id,oi.sum_original_and_freight_value,o.customer_id,c.customer_state AS state FROM order_items oi JOIN orders o ON oi.order_id=o.order_id JOIN customers c ON o.customer_id=c.customer_id
) 
SELECT state,ROUND((SUM(sum_original_and_freight_value)/SUM(SUM(sum_original_and_freight_value)) OVER())::NUMERIC*100,2) AS revenue_percentage,ROUND(SUM(sum_original_and_freight_value)::NUMERIC,2) AS total_revenue FROM revenue_per_state GROUP BY state ORDER BY revenue_percentage DESC;

-- Average order value per state
WITH order_per_state AS (
	SELECT oi.order_id,oi.sum_original_and_freight_value,o.customer_id,c.customer_state FROM order_items oi JOIN orders o ON oi.order_id=o.order_id JOIN customers c ON o.customer_id=c.customer_id
),
sum_order AS (
	SELECT order_id,SUM(sum_original_and_freight_value) AS order_value,customer_state FROM order_per_state GROUP BY order_id,customer_state
)
SELECT customer_state,ROUND(AVG(order_value)::NUMERIC,2) AS order_value FROM sum_order GROUP BY customer_state ORDER BY AVG(order_value) DESC; 

-- Orders per each month
WITH monthly_orders AS (
    SELECT DATE_TRUNC('month',order_purchase_timestamp) AS month,COUNT(DISTINCT order_id) AS total_orders FROM orders GROUP BY DATE_TRUNC('month',order_purchase_timestamp)
)
SELECT month,total_orders FROM monthly_orders ORDER BY month;