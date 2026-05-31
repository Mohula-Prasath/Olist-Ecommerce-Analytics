CREATE TABLE customers (
    customer_id TEXT,
    customer_unique_id TEXT,
    customer_zip_code_prefix TEXT,
    customer_city TEXT,
    customer_state TEXT
);

SELECT COUNT(*) FROM customers;

CREATE TABLE geolocation (
	geolocation_zip_code_prefix TEXT,
	geolocation_lat TEXT,
	geolocation_lng TEXT,
	geolocation_city TEXT,
	geolocation_state TEXT
);

SELECT COUNT(*) FROM geolocation;

CREATE TABLE order_items (
	order_id TEXT,
	order_item_id TEXT,
	product_id TEXT,
	seller_id TEXT,
	shipping_limit_date TEXT,
	price TEXT,
	freight_value TEXT,
	sum_original_and_freight_value TEXT
);

SELECT COUNT(*) FROM order_items;

CREATE TABLE orders (
	order_id TEXT,
	customer_id TEXT,
	order_status TEXT,
	order_purchase_timestamp TEXT,
	order_approved_at TEXT,
	order_delivered_carrier_date TEXT,
	order_delivered_customer_date TEXT,
	order_estimated_delivery_date TEXT,
	delivery_time TEXT,
	approval_time TEXT,
	carrier_time TEXT,
	expected_vs_actual_delivery TEXT
);

SELECT COUNT(*) FROM orders;

CREATE TABLE payments (
	order_id TEXT,
	payment_sequential TEXT,
	payment_type TEXT,
	payment_installments TEXT,
	payment_value TEXT
);

SELECT COUNT(*) FROM payments;

CREATE TABLE product_category_name_translation (
	product_category_name TEXT,
	product_category_name_english TEXT
);

SELECT COUNT(*) FROM product_category_name_translation;

CREATE TABLE products (
	product_id TEXT,
	product_category_name TEXT,
	product_name_lenght TEXT,
	product_description_lenght TEXT,
	product_photos_qty TEXT,
	product_weight_g TEXT,
	product_length_cm TEXT,
	product_height_cm TEXT,
	product_width_cm TEXT,
	volume_of_product_cm3 TEXT
);

SELECT COUNT(*) FROM products;

CREATE TABLE reviews (
	review_id TEXT,
	order_id TEXT,
	review_score TEXT,
	review_comment_title TEXT,
	review_comment_message TEXT,
	review_creation_date TEXT,
	review_answer_timestamp TEXT,
	review_answer_time_taken TEXT
);

SELECT COUNT(*) FROM reviews;

CREATE TABLE sellers (
	seller_id TEXT,
	seller_zip_code_prefix TEXT,
	seller_city TEXT,
	seller_state TEXT
);

SELECT COUNT(*) FROM sellers;

