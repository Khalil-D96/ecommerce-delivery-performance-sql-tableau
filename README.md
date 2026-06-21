# E-Commerce Delivery Performance Analysis

SQL and Tableau case study analyzing delivery performance for an e-commerce market expansion decision.

## Project Context

This project was completed as part of a group case study during my Data Analysis & AI training.

The case study focused on Eniac, a European e-commerce company considering an expansion into the Brazilian market through Magist, a Brazilian order management and logistics provider.

My contribution focused on the delivery performance analysis.

## My Contribution

I worked on the logistics and delivery part of the project, including:

* Understanding the relational database schema
* Preparing an analytical table using SQL
* Calculating delivery-related metrics
* Analyzing late orders
* Comparing delivery performance by state and product category
* Creating Tableau visualizations for the delivery pipeline

## Tools Used

* SQL
* MySQL
* Tableau
* Data Cleaning
* Data Analysis
* Data Visualization

## SQL Workflow

The SQL part is divided into two scripts:

### 1. Data preparation

`sql/01_create_orders_new_table.sql`

This script creates an analytical table for delivered orders and calculates delivery-related metrics such as:

* delivery time
* processing time
* seller-to-carrier time
* shipping time
* delay
* late-order flag

### 2. Analysis queries

`sql/02_delivery_pipeline_analysis_queries.sql`

This script contains the queries used to extract the results for the Tableau analysis.

The analysis looks at delivery performance by:

* order status
* product category
* Brazilian state
* state and product category

## Tableau Visualizations

The Tableau screenshots show different parts of the delivery analysis, including:

* order status distribution
* overall delivery pipeline
* delivery performance by product category
* delivery performance by state
* delivery performance by state and product category

## Result

The detailed findings and recommendation are available here:

`reports/final_recommendation.md`

In short, the analysis suggests that Magist is reliable in terms of completed deliveries, but delivery speed and regional differences should be monitored carefully before committing to a long-term partnership.

## Note

This was a group project. The repository focuses on my individual contribution to the delivery performance analysis.
