/*
Project: E-Commerce Delivery Performance Analysis
File: 02_delivery_pipeline_analysis_queries.sql
Purpose: SQL analysis queries used to extract delivery KPIs for Tableau and business recommendations.
Database: MySQL 8+
*/

/* ============================================================
   1. Order status distribution
   Used to understand how many orders were delivered compared with
   other order statuses in the original orders table.
   ============================================================ */

WITH filtered_orders AS (
    SELECT o.order_id, o.order_status
    FROM orders o
    WHERE EXISTS (
        SELECT 1
        FROM order_items oi
        WHERE oi.order_id = o.order_id
    )
)

SELECT
    fo.order_status,
    COUNT(DISTINCT fo.order_id) AS num_of_orders,
    ROUND(COUNT(DISTINCT fo.order_id) * 100.0 / 
		(SELECT COUNT(DISTINCT f1.order_id) 
         FROM filtered_orders f1),
        2
    ) AS percent_of_total_orders
FROM filtered_orders fo
GROUP BY fo.order_status
ORDER BY num_of_orders DESC;

/* ============================================================
   2. Overall delivery pipeline KPIs
   Main KPIs for all cleaned and delivered orders.
   ============================================================ */

SELECT
    COUNT(*) AS num_of_delivered_orders,
    ROUND(AVG(delivery_time_in_days), 1) AS avg_delivery_time_in_days,
    ROUND(AVG(processing_time_in_days), 1) AS avg_processing_time_in_days,
    ROUND(AVG(seller_to_carrier_time_in_days), 1) AS avg_seller_to_carrier_time_in_days,
    ROUND(AVG(shipping_time_in_days), 1) AS avg_shipping_time_in_days,
    SUM(late_flag) AS num_of_late_orders,
    ROUND(SUM(late_flag) * 100.0 / COUNT(*), 1) AS late_orders_percent
FROM orders_new;


/* ============================================================
   3. Delivery performance by Brazilian state
   Shows regional delivery differences and late-order risk.
   ============================================================ */

SELECT
    g.state,
    COUNT(DISTINCT d.order_id) AS num_of_delivered_orders,
    ROUND(AVG(d.delivery_time_in_days), 1) AS avg_delivery_time_in_days,
    ROUND(AVG(d.processing_time_in_days), 1) AS avg_processing_time_in_days,
    ROUND(AVG(d.seller_to_carrier_time_in_days), 1) AS avg_seller_to_carrier_time_in_days,
    ROUND(AVG(d.shipping_time_in_days), 1) AS avg_shipping_time_in_days,
    SUM(d.late_flag) AS num_of_late_orders,
    ROUND(SUM(d.late_flag) * 100.0 / COUNT(DISTINCT d.order_id), 1) AS late_orders_percent
FROM orders_new d
JOIN customers c
    ON d.customer_id = c.customer_id
JOIN geo g
    ON c.customer_zip_code_prefix = g.zip_code_prefix
GROUP BY g.state
HAVING COUNT(DISTINCT d.order_id) >= 10
ORDER BY avg_delivery_time_in_days DESC;


/* ============================================================
   4. Delivery performance by Eniac-relevant product category
   The selected categories represent tech-related categories that
   are more relevant for Eniac's product positioning.

   Important:
   A distinct order-category base is used to avoid double-counting
   orders with multiple items in the same product category.
   ============================================================ */

SELECT 
    t.product_category_name_english,
    COUNT(DISTINCT d.order_id) AS num_of_delivered_orders,
    ROUND(AVG(d.delivery_time_in_days), 1) AS avg_delivery_time_in_days,
    ROUND(AVG(processing_time_in_days), 1) avg_processing_time_in_days,
    ROUND(AVG(seller_to_carrier_time_in_days), 1) avg_seller_to_carrier_time_in_days,
    ROUND(AVG(shipping_time_in_days), 1) avg_shipping_time_in_days,
    SUM(d.late_flag) AS num_of_late_orders,
	ROUND(SUM(d.late_flag) * 100.0 / COUNT(DISTINCT d.order_id), 1) AS late_orders_percent
FROM
    orders_new d
        JOIN
    order_items i ON d.order_id = i.order_id
        JOIN
    products p ON i.product_id = p.product_id
        JOIN
    product_category_name_translation t ON p.product_category_name = t.product_category_name
WHERE
    t.product_category_name_english IN ('audio' , 'computers',
        'computers_accessories',
        'telephony',
        'tablets_printing_image',
        'watches_gifts')
GROUP BY t.product_category_name_english
HAVING COUNT(DISTINCT d.order_id) >= 10
ORDER BY avg_delivery_time_in_days DESC;


/* ============================================================
   5. Delivery performance by state and Eniac-relevant product category
   Used to identify combinations of regions and product categories
   with higher delivery risk.

   Important:
   A distinct order-state-category base is used to avoid double-counting
   orders with multiple items in the same product category.
   ============================================================ */

SELECT 
    g.state,
    t.product_category_name_english,
    COUNT(DISTINCT d.order_id) AS num_of_delivered_orders,
    ROUND(AVG(d.delivery_time_in_days), 1) AS avg_delivery_time_in_days,
    ROUND(AVG(processing_time_in_days), 1) avg_processing_time_in_days,
    ROUND(AVG(seller_to_carrier_time_in_days), 1) avg_seller_to_carrier_time_in_days,
    ROUND(AVG(shipping_time_in_days), 1) avg_shipping_time_in_days,
    SUM(d.late_flag) AS num_of_late_orders,
	ROUND(SUM(d.late_flag) * 100.0 / COUNT(DISTINCT d.order_id), 1) AS late_orders_percent
FROM
    orders_new d
        JOIN
    customers c ON d.customer_id = c.customer_id
        JOIN
    geo g ON c.customer_zip_code_prefix = g.zip_code_prefix
        JOIN
    order_items i ON d.order_id = i.order_id
        JOIN
    products p ON i.product_id = p.product_id
        JOIN
    product_category_name_translation t ON p.product_category_name = t.product_category_name
WHERE
    t.product_category_name_english IN ('audio' , 'computers',
        'computers_accessories',
        'telephony',
        'tablets_printing_image',
        'watches_gifts')
GROUP BY g.state , product_category_name_english
HAVING COUNT(DISTINCT d.order_id) >= 10
ORDER BY
    g.state,
    avg_delivery_time_in_days DESC;
