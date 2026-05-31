-- Seller leaderboard 
WITH seller_leaderboard AS (
	SELECT seller_id,SUM(sum_original_and_freight_value) AS revenue FROM order_items GROUP BY seller_id
)
SELECT seller_id,ROUND(revenue::NUMERIC,2),RANK() OVER(ORDER BY revenue DESC) AS rank FROM seller_leaderboard ORDER BY rank;

-- Sellers with high revenue but low rating
WITH revenue_seller AS (
	SELECT r.review_score,oi.sum_original_and_freight_value,oi.seller_id FROM order_items oi JOIN reviews r ON oi.order_id=r.order_id
)
SELECT seller_id, ROUND(SUM(sum_original_and_freight_value)::NUMERIC,2) AS revenue FROM revenue_seller GROUP BY seller_id HAVING AVG(review_score)<3 ORDER BY revenue DESC LIMIT 10;

-- Seller concentration by state
WITH seller_concentration AS (
	SELECT oi.sum_original_and_freight_value,s.seller_id,s.seller_state FROM sellers s JOIN order_items oi ON s.seller_id=oi.seller_id JOIN reviews r ON oi.order_id=r.order_id
)
SELECT seller_state,COUNT(DISTINCT seller_id) AS sellers_cnt,ROUND(SUM(sum_original_and_freight_value)::NUMERIC,2) tot_revenue FROM seller_concentration GROUP BY seller_state ORDER BY tot_revenue DESC;
