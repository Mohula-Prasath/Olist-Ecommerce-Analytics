--  Average delivery time per state
WITH delivery_time_per_state AS (
	SELECT o.delivery_time,c.customer_state AS state FROM order_items oi JOIN orders o ON oi.order_id=o.order_id JOIN customers c ON o.customer_id=c.customer_id
) 
SELECT state, AVG(delivery_time) AS Avg_delivery_time FROM delivery_time_per_state GROUP BY state ORDER BY AVG(delivery_time);

-- States with highest late delivery rate
WITH delivery_per_state AS (
	SELECT o.expected_vs_actual_delivery,c.customer_state AS state FROM order_items oi JOIN orders o ON oi.order_id=o.order_id JOIN customers c ON o.customer_id=c.customer_id
),
late_delivery AS (
	SELECT state,expected_vs_actual_delivery FROM delivery_per_state WHERE expected_vs_actual_delivery<0
)
SELECT state, ((SELECT COUNT(expected_vs_actual_delivery) FROM late_delivery WHERE state=ld.state)*100)/(SELECT COUNT(expected_vs_actual_delivery) FROM delivery_per_state WHERE state=ld.state) AS delay_percentage FROM late_delivery ld GROUP BY state ORDER BY delay_percentage DESC;

-- Delivery time breakdown
WITH delivery_time_breakdown AS (
	SELECT o.delivery_time,o.approval_time,o.carrier_time,c.customer_state AS state FROM order_items oi JOIN orders o ON oi.order_id=o.order_id JOIN customers c ON o.customer_id=c.customer_id
) 
SELECT state,AVG(approval_time) AS avg_approval_time,AVG(carrier_time) AS avg_carrier_time,AVG(delivery_time) AS avg_delivery_time FROM delivery_time_breakdown GROUP BY state;

-- Top 10 sellers by fastest average delivery time (min 50 orders)
WITH seller_delivery_time AS (
	SELECT DISTINCT o.order_id,o.delivery_time,s.seller_id FROM orders o JOIN order_items oi ON o.order_id=oi.order_id JOIN sellers s ON oi.seller_id=s.seller_id
)
SELECT seller_id,AVG(delivery_time) AS avg_delivery_time FROM seller_delivery_time GROUP BY seller_id HAVING COUNT(order_id)>=50 ORDER BY avg_delivery_time ASC LIMIT 10;