USE sales;

SELECT COUNT(NULL)
FROM sales_yr;

/*KPIs: Total revenue, profit, profit margin*/
SELECT ROUND(SUM(sales), 2) AS total_sales,
 ROUND(SUM(profit), 2) AS total_profit,
 ROUND(((SUM(sales)-SUM(cost))/SUM(sales))*100, 2) AS total_profit_margin
FROM sales_yr;

/*KPIs: Total stores, sales agents*/
SELECT COUNT(DISTINCT customer_id) AS total_customers,
 COUNT(DISTINCT store_id) AS total_stores,
 COUNT(DISTINCT region_id) AS total_region,
 COUNT(DISTINCT sales_agent_id) AS total_sales_agents
FROM sales_yr;

/*There are only one stores in each region, except...*/
SELECT region_id, 
 COUNT(DISTINCT store_id) AS number_of_stores
FROM sales_yr
GROUP BY region_id
HAVING number_of_stores > 1;

/*Question: what won't this query work?*/
SELECT locations.region_id, locations.region_name,
 COUNT(DISTINCT store_id) AS number_of_stores
FROM sales_yr
LEFT JOIN locations ON sales_yr.region_id = locations.region_id
GROUP BY locations.region_id
HAVING number_of_stores > 1;

/*KPIs: Averages revenue per store*/
SELECT 
 ROUND(SUM(sales)/COUNT(DISTINCT store_id), 2) AS avg_revenue_per_store,
 SUM(quantity)/COUNT(DISTINCT customer_id) AS avg_quantity_per_customer,
 AVG(DATEDIFF(shipping_date, order_date)) AS avg_shipping_day
FROM sales_yr;

/*KPIs: % repeat customers*/
 SELECT (1-COUNT(DISTINCT customer_id)/COUNT(customer_id))*100 AS pct_repeat_customers
 FROM sales_yr;

/*MoM: Sales trend*/
SELECT MONTH(order_date) AS sales_month,
 ROUND(SUM(sales), 2) AS total_sales
FROM sales_yr
GROUP BY sales_month
ORDER BY sales_month;
    
/*MoM: Sales trend by region*/
SELECT MONTH(order_date) AS sales_month,
 region_name,
 ROUND(SUM(sales), 2) AS total_sales
FROM sales_yr
JOIN locations ON sales_yr.region_id = locations.region_id
GROUP BY region_name, sales_month
ORDER BY sales_month, region_name;
    
/*Product: revenue vs % margin, quantity vs % margin*/
SELECT product_category, product_name,
 SUM(quantity) AS total_quantity,
 ROUND(SUM(sales), 2) AS total_sales,
 ROUND(((SUM(sales)-SUM(cost))/SUM(sales))*100, 2) AS total_profit_margin
FROM sales_yr
JOIN products ON sales_yr.product_id = products.product_id
GROUP BY product_category, product_name
ORDER BY total_sales DESC;

/*Region: revenue, profitability, revenue per sales_agents*/
SELECT region_name, province, town,
 ROUND(SUM(sales), 2) AS total_sales,
 ROUND(((SUM(sales)-SUM(cost))/SUM(sales))*100, 2) AS total_profit_margin
FROM sales_yr
JOIN locations ON sales_yr.region_id = locations.region_id
JOIN stores ON sales_yr.store_id = stores.store_id
GROUP BY region_name, province, town
ORDER BY total_sales DESC;

/*Stores: low performing vs high performing stores (ex: 80% profit from 20% stores?)*/
SELECT stores.store_id, store_name,
 SUM(quantity) AS total_quantity,
 ROUND(SUM(sales), 2) AS total_sales,
 ROUND(((SUM(sales)-SUM(cost))/SUM(sales))*100, 2) AS total_profit_margin
FROM sales_yr
JOIN stores ON stores.store_id = sales_yr.store_id
GROUP BY store_id, store_name
ORDER BY total_quantity DESC;

/*Agent: top sales vs low sales*/
SELECT 
 sales_agent_name,
 COUNT(sales_agent_name) AS sales_made,
 ROUND(SUM(sales),2) AS total_sales
FROM sales_yr
JOIN sales_agents ON sales_yr.sales_agent_id = sales_agents.sales_agent_id
GROUP BY sales_agent_name
ORDER BY total_sales DESC; 

/*Customer segmentation: recency/frequency/monetary(how much they spend)*/
/*Monetary*/
SELECT sales_yr.customer_id, customer_name,
 SUM(quantity) AS quantity_purchased,
 ROUND(SUM(sales),2) AS total_sales
FROM sales_yr
JOIN customers ON sales_yr.customer_id = customers.customer_id
GROUP BY sales_yr.customer_id, customer_name
ORDER BY SUM(quantity) DESC, total_sales DESC;

SELECT customer_id, COUNT(customer_id) AS number_of_repeats
FROM sales_yr
GROUP BY customer_id
ORDER BY COUNT(customer_id) DESC;