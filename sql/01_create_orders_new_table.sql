/*
Project: E-Commerce Delivery Performance Analysis
File: 01_create_orders_new_table.sql
Purpose: Create a cleaned analytical table for delivered orders and calculate delivery-pipeline metrics.
Database: MySQL 8+

Notes:
- The analysis focuses on delivered orders only.
- Orders without matching records in order_items are excluded.
- Records with missing or inconsistent delivery timestamps are excluded.
- The hard-coded order_id below was excluded in the original project because it was identified as an inconsistent record during data validation.
*/

DROP TABLE IF EXISTS orders_new;

CREATE TABLE orders_new (
    order_id VARCHAR(255) NOT NULL,
    customer_id VARCHAR(255) NOT NULL,
    order_status VARCHAR(50),
    order_purchase_timestamp TIMESTAMP NULL DEFAULT NULL,
    order_approved_at TIMESTAMP NULL DEFAULT NULL,
    order_delivered_carrier_date TIMESTAMP NULL DEFAULT NULL,
    order_delivered_customer_date TIMESTAMP NULL DEFAULT NULL,
    order_estimated_delivery_date TIMESTAMP NULL DEFAULT NULL,
    delivery_time_in_hours DECIMAL(10,2),
    delivery_time_in_days DECIMAL(10,2),
    processing_time_in_days DECIMAL(10,2),
    seller_to_carrier_time_in_days DECIMAL(10,2),
    shipping_time_in_days DECIMAL(10,2),
    delay_in_days DECIMAL(10,2),
    late_flag TINYINT,
    PRIMARY KEY (order_id)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;

INSERT INTO orders_new (
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    delivery_time_in_hours,
    delivery_time_in_days,
    processing_time_in_days,
    seller_to_carrier_time_in_days,
    shipping_time_in_days,
    delay_in_days,
    late_flag
)
WITH orders_with_items AS (
    SELECT o.*
    FROM orders o
    WHERE EXISTS (
        SELECT 1
        FROM order_items oi
        WHERE oi.order_id = o.order_id
    )
),

delivered_orders AS (
    SELECT *
    FROM orders_with_items
    WHERE order_status = 'delivered'
),

flag_dirty_data AS (
SELECT o.*,
	   CASE 
			WHEN 	order_approved_at IS NULL 
					OR order_delivered_carrier_date IS NULL 
                    OR order_delivered_customer_date IS NULL 
					OR o.order_purchase_timestamp > order_delivered_carrier_date
					OR o.order_approved_at > order_delivered_customer_date
                    OR o.order_approved_at > order_delivered_carrier_date
                    OR o.order_delivered_carrier_date > order_delivered_customer_date
            THEN 1
            ELSE 0
       END AS flag
FROM delivered_orders o
),

validated_delivered_orders AS (
SELECT *
FROM flag_dirty_data f
WHERE f.flag = 0 
		AND c.order_id != '9675440ebf61a1a3482cc6308e3ebd28'
),

delivery_metrics AS (
    SELECT
        o.order_id,
        o.customer_id,
        o.order_status,
        o.order_purchase_timestamp,
        o.order_approved_at,
        o.order_delivered_carrier_date,
        o.order_delivered_customer_date,
        o.order_estimated_delivery_date,

	   TIMESTAMPDIFF(HOUR,d.order_purchase_timestamp,d.order_delivered_customer_date) AS delivery_time_in_hours,
       ROUND(TIMESTAMPDIFF(HOUR,d.order_purchase_timestamp,d.order_delivered_customer_date)/24, 1) AS delivery_time_in_days,
       ROUND(TIMESTAMPDIFF(HOUR,d.order_purchase_timestamp,d.order_approved_at)/24, 1) AS processing_time_in_days,
	   ROUND(TIMESTAMPDIFF(HOUR,d.order_approved_at,d.order_delivered_carrier_date)/24, 1) AS seller_to_carrier_time_in_days,
       ROUND(TIMESTAMPDIFF(HOUR,d.order_delivered_carrier_date,d.order_delivered_customer_date)/24, 1) AS shipping_time_in_days,
       ROUND(TIMESTAMPDIFF(HOUR,d.order_estimated_delivery_date,d.order_delivered_customer_date)/24, 1) AS delay_in_days
    FROM validated_delivered_orders o
)

SELECT
    dm.*,
    CASE
        WHEN dm.delay_in_days > 0 THEN 1
        ELSE 0
    END AS late_flag
FROM delivery_metrics dm;
