-- Full seller scorehard
WITH seller_scorecard AS (
	SELECT s.seller_id,COUNT(DISTINCT o.order_id) AS total_orders,SUM(oi.sum_original_and_freight_value) AS total_revenue,AVG(o.delivery_time) AS avg_delivery_time,AVG(r.review_score) AS avg_review_score FROM sellers s JOIN order_items oi ON s.seller_id=oi.seller_id JOIN orders o ON oi.order_id=o.order_id JOIN reviews r ON o.order_id=r.order_id GROUP BY s.seller_id
	)
SELECT seller_id,total_orders,ROUND(total_revenue::NUMERIC,2) AS total_revenue,ROUND(avg_delivery_time::NUMERIC,2) AS avg_delivery_time,ROUND(avg_review_score::NUMERIC,2) AS avg_review_score FROM seller_scorecard WHERE total_orders>=30 ORDER BY total_revenue DESC;