-- Payment method distribution
SELECT payment_type,COUNT(payment_type)AS count,ROUND(COUNT(payment_type)*100/(SELECT COUNT(payment_type) FROM payments)::NUMERIC,2) AS count_percentage FROM payments GROUP BY payment_type;

-- Avg installments by payment type
SELECT payment_type,ROUND(AVG(payment_installments)::NUMERIC,2) FROM payments GROUP BY payment_type;

-- States with highest average payment value
WITH highest_payment AS (
	SELECT c.customer_state,p.payment_value FROM payments p JOIN orders o ON p.order_id=o.order_id JOIN customers c ON o.customer_id=c.customer_id
)
SELECT customer_state,AVG(payment_value) AS payment_value FROM highest_payment GROUP BY customer_state ORDER BY payment_value DESC;

-- High value orders
WITH high_value_orders AS (
	SELECT oi.order_id,SUM(oi.sum_original_and_freight_value) AS total_order_value,c.customer_state,pt.product_category_name_english FROM order_items oi JOIN orders o ON oi.order_id=o.order_id JOIN customers c ON o.customer_id=c.customer_id JOIN products p ON oi.product_id=p.product_id JOIN product_category_name_translation pt ON p.product_category_name=pt.product_category_name GROUP BY oi.order_id,c.customer_state,pt.product_category_name_english	HAVING SUM(oi.sum_original_and_freight_value)>500
)
SELECT customer_state,product_category_name_english,COUNT(order_id) AS total_high_value_orders,ROUND(SUM(total_order_value)::NUMERIC,2) AS total_revenue FROM high_value_orders GROUP BY customer_state,product_category_name_english ORDER BY total_revenue DESC;