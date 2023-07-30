SELECT *
FROM order_details

SELECT *
FROM orders

SELECT *
FROM pizzas



--How many customers do we have each day? Are there any peak hours?

-- This query calculates the daily number of customers from the "orders" table. 
-- By grouping the data by date and counting the distinct order IDs, it provides a concise overview of customer activity over time. 
-- The results enable Pizza Place to identify peak and low-traffic days, aiding in resource allocation and optimizing customer experiences. 

SELECT date, COUNT(DISTINCT order_id) AS number_of_customers
FROM orders
GROUP BY date
ORDER BY date;


-- This query identifies peak hours at the Pizza Place by analyzing the "orders" data. It shows the top 5 busiest hours based on order counts. 
-- By leveraging this insight, the Pizza Place can optimize operations, staffing, and service during high-demand periods, leading to improved efficiency and customer satisfaction.


SELECT TOP 5 SUBSTRING(time, 1, 2) AS hour, COUNT(*) AS order_count
FROM orders
GROUP BY SUBSTRING(time, 1, 2)
ORDER BY order_count DESC;


--How many pizzas are typically in an order? Do we have any bestsellers?

--This query calculates the average number of pizzas per order from the "order_details" table. 

SELECT AVG(CAST(quantity AS INT)) AS average_pizzas_per_order
FROM order_details;


-- This query identifies the top 5 bestselling pizzas based on sales data from the "order_details" and "pizzas" tables. 
-- By grouping the data by pizza_id and calculating the total sales for each pizza, the query presents the highest-selling pizzas at the top of the result.

SELECT TOP 5 order_details.pizza_id, CONVERT(INT, SUM(CAST(pizzas.price AS FLOAT) * CAST(order_details.quantity AS INT))) AS Sales
FROM order_details
JOIN pizzas ON pizzas.pizza_id = order_details.pizza_id
GROUP BY order_details.pizza_id
ORDER BY Sales DESC;


--How much money did we make this year? Can we indentify any seasonality in the sales?

-- This query summarizes the sales for each distinct pizza type in ascending order, providing valuable insights into the popularity and revenue generated by individual menu items. 
-- It allows Pizza Place to identify top-selling pizzas and those with lower sales, enabling them to optimize their menu offerings, promotional strategies, and resource allocation. 
-- The results empower data-driven decision-making to enhance overall sales performance and customer satisfaction.


SELECT DISTINCT order_details.pizza_id, SUM(CAST(pizzas.price AS FLOAT) * CAST(order_details.quantity AS INT)) AS Sales
FROM order_details
JOIN pizzas ON pizzas.pizza_id = order_details.pizza_id
GROUP BY order_details.pizza_id
ORDER BY Sales ASC;

-- The results provide valuable insights into the contribution of each pizza type to the overall revenue, allowing Pizza Place to identify their bestselling pizzas and analyze their performance. 

SELECT SUM(Sales) AS Total_Sales
FROM (
  SELECT DISTINCT order_details.pizza_id, SUM(CAST(pizzas.price AS FLOAT) * CAST(order_details.quantity AS INT)) AS Sales
  FROM order_details
  JOIN pizzas ON pizzas.pizza_id = order_details.pizza_id
  GROUP BY order_details.pizza_id
) AS Sales_Summary;


-- This query presents a concise analysis of monthly sales, providing a clear view of the revenue generated for each month. 
-- By aggregating and rounding the total sales for each month, Pizza Place can quickly identify trends and patterns in customer purchasing behavior.

SELECT DATEPART(MONTH, orders.date) AS Month,
       ROUND(SUM(CAST(pizzas.price AS FLOAT) * CAST(order_details.quantity AS INT)), 0) AS Total_Sales
FROM order_details
JOIN pizzas ON pizzas.pizza_id = order_details.pizza_id
JOIN orders ON orders.order_id = order_details.order_id
GROUP BY DATEPART(MONTH, orders.date)
ORDER BY DATEPART(MONTH, orders.date);

-- The query reveals the months with significant sales, showcasing the seasonal periods when customer demand peaks. 
-- By filtering and displaying months with sales equal to or above 70,000, businesses can pinpoint their most lucrative periods. 
-- This valuable information empowers businesses to strategize better for inventory management, targeted marketing campaigns, and resource allocation, ensuring they can optimize operations during these high-demand months and maximize profitability.

SELECT DATEPART(MONTH, orders.date) AS Month,
       ROUND(SUM(CAST(pizzas.price AS FLOAT) * CAST(order_details.quantity AS INT)), 0) AS Total_Sales
FROM order_details
JOIN pizzas ON pizzas.pizza_id = order_details.pizza_id
JOIN orders ON orders.order_id = order_details.order_id
GROUP BY DATEPART(MONTH, orders.date)
HAVING ROUND(SUM(CAST(pizzas.price AS FLOAT) * CAST(order_details.quantity AS INT)), 0) >= 70000
ORDER BY DATEPART(MONTH, orders.date);

-- Are there any pizzas we should take of the menu, or any promotions we could leverage?
-- This query efficiently identifies the 5 least popular pizzas based on their sales data. 
-- It provides valuable insights to help Pizza Place focus on improving these menu items through targeted strategies, enhancing overall sales and customer satisfaction.


SELECT TOP 5 order_details.pizza_id, CONVERT(INT, SUM(CAST(pizzas.price AS FLOAT) * CAST(order_details.quantity AS INT))) AS Sales
FROM order_details
JOIN pizzas ON pizzas.pizza_id = order_details.pizza_id
GROUP BY order_details.pizza_id
ORDER BY Sales ASC;




