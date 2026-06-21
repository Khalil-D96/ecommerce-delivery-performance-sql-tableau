# Delivery Pipeline Analysis for E-Commerce Market Expansion

## Project Overview

This project analyzes the delivery performance of Magist, a Brazilian order management and logistics service provider, in the context of a potential market expansion by Eniac, a European e-commerce company specializing in Apple products and curated tech accessories.

Eniac is considering entering the Brazilian market through a 3-year partnership with Magist. However, the company has two major concerns:

1. Whether Magist is a suitable partner for high-end tech products.
2. Whether Magist can provide delivery performance that matches Eniac’s customer-service standards.

This project focuses on the second question: **Are Magist’s deliveries fast and reliable enough for Eniac?**

## Project Context

This was a group case study completed during my Data Analysis & AI training.  
My main contribution focused on the **delivery performance analysis**, including SQL-based data preparation, delivery time calculations, late-order analysis, and Tableau visualizations.

## Business Questions

The analysis was guided by the following questions:

- What percentage of orders were successfully delivered?
- How long does the delivery process take on average?
- Which part of the delivery pipeline causes the most delay?
- Are delivery delays random or systematic?
- Which Brazilian states show the longest delivery times?
- Are Eniac-relevant product categories affected by slow delivery?
- Could Magist’s delivery performance create a risk for customer satisfaction?

## Tools Used

- SQL
- MySQL
- Tableau
- Data Modeling
- Data Cleaning
- Business Analysis

## Database Schema

The database contains several connected tables, including:

- `orders`
- `order_items`
- `products`
- `customers`
- `sellers`
- `geo`
- `order_reviews`
- `order_payments`
- `product_category_name_translation`

The analysis mainly uses order, customer, geographic, product, and order item data to evaluate delivery performance across regions and product categories.

## Data Preparation

I created a new analytical table called `orders_new`, focusing only on delivered orders with valid delivery timestamps.

The data preparation process included:

- Filtering orders with corresponding order items.
- Keeping only delivered orders.
- Removing records with missing or inconsistent delivery dates.
- Calculating delivery-related metrics.
- Creating a late-order flag.

Calculated metrics included:

- `delivery_time_in_days`
- `processing_time_in_days`
- `seller_to_carrier_time_in_days`
- `shipping_time_in_days`
- `delay_in_days`
- `late_flag`

## Key Metrics

The analysis showed:

- Total delivered orders analyzed: **95,081**
- Average delivery time: **12.6 days**
- Average processing time: **0.4 days**
- Average seller-to-carrier time: **2.8 days**
- Average shipping time: **9.3 days**
- Late orders: **8.1%**

The main bottleneck was the shipping phase, not the internal processing phase.

## Tableau Analysis

The Tableau dashboard includes:

1. Order status distribution
2. Overall delivery pipeline analysis
3. Delivery pipeline by product category
4. Delivery pipeline by Brazilian state
5. Delivery pipeline by state and product category

These visualizations helped identify regional and category-specific delivery risks.

## My Contribution

In this group project, I focused on the delivery analysis part:

- Designed SQL queries for delivery performance analysis.
- Created a cleaned analytical table for delivered orders.
- Calculated delivery time, shipping time, processing time, delay, and late-order metrics.
- Analyzed delivery performance by state and product category.
- Built Tableau visualizations for delivery pipeline analysis.
- Contributed to the final business recommendation.

## Limitations

- The analysis is based on a snapshot of historical data.
- External factors such as logistics partners, local infrastructure, and seasonal effects were not fully modeled.
- The original dataset is not included in this repository due to training-provider restrictions.