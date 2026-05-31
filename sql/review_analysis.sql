-- Avg review score per product category
WITH avg_rev_score AS (
	SELECT oi.order_id,pct.product_category_name_english,r.review_score FROM products p JOIN order_items oi ON p.product_id=oi.product_id JOIN reviews r ON oi.order_id=r.order_id JOIN product_category_name_translation pct ON pct.product_category_name=p.product_category_name
)
SELECT product_category_name_english,ROUND(AVG(review_score)::NUMERIC,2) AS avg_review_score FROM avg_rev_score GROUP BY product_category_name_english HAVING COUNT(DISTINCT order_id)>100 ORDER BY avg_review_score DESC;

-- Categories with worst review scores 
WITH avg_rev_score AS (
	SELECT oi.order_id,pct.product_category_name_english,r.review_score FROM products p JOIN order_items oi ON p.product_id=oi.product_id JOIN reviews r ON oi.order_id=r.order_id JOIN product_category_name_translation pct ON pct.product_category_name=p.product_category_name
)
SELECT product_category_name_english,ROUND(AVG(review_score)::NUMERIC,2) AS avg_review_score FROM avg_rev_score GROUP BY product_category_name_english HAVING COUNT(DISTINCT order_id)>100 ORDER BY avg_review_score LIMIT 10;

-- Avg review score bucketed by delay ranges
WITH review_delay AS (
	SELECT r.review_score,o.expected_vs_actual_delivery,
		   CASE
			   WHEN o.expected_vs_actual_delivery>7 THEN 'Delivered 7+ days early'
			   WHEN o.expected_vs_actual_delivery BETWEEN 1 AND 7 THEN 'Delivered early'
			   WHEN o.expected_vs_actual_delivery=0 THEN 'Delivered on time'
			   WHEN o.expected_vs_actual_delivery BETWEEN -7 AND -1 THEN 'Delayed within 7 days'
			   ELSE 'Delayed more than 7 days'
		   END AS delivery_status
	FROM orders o JOIN reviews r ON o.order_id=r.order_id
)
SELECT delivery_status,ROUND(AVG(review_score)::NUMERIC,2) AS avg_review_score,COUNT(*) AS total_reviews FROM review_delay GROUP BY delivery_status ORDER BY avg_review_score DESC;