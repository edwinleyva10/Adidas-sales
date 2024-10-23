CREATE TABLE IF NOT EXISTS locations(
sales_id   INT   NOT NULL  PRIMARY KEY,
retailer  VARCHAR(25)  NOT NULL,
retailer_id   INT   NOT NULL,
invoice_date   DATE   NOT NULL,
region   VARCHAR(20)   NOT NULL,
state   VARCHAR(20)   NOT NULL,
city  VARCHAR(20)  NOT NULL
);

CREATE TABLE IF NOT EXISTS sales(
sales_id  INT   NOT NULL PRIMARY KEY,
product   VARCHAR(30)  NOT NULL,
price_per_unit  INT   NOT NULL,
units_sold   INT  NOT NULL,
total_sales   INT  NOT NULL,
operating_profit  INT  NOT NULL,
sales_method   VARCHAR(20)  NOT NULL
);
-- My goal in this project is to run different queries to explore Adidas sales and to possibly see areas to focus on to maximize profit for the company. Different marketing strategies can be used depending
-- on what the results show. There may be certain regions in the country, certain methods of sales, and even certain retailers that may produce more profit for Adidas. So let's review the data and see if
-- we can find anything interesting.

------------------------------------------------ GENERIC QUESTIONS--------------------------------------------------------------
-- What is the sales method most often used?
SELECT COUNT(sales_method) AS method_count, sales_method
FROM sales
GROUP BY sales_method
ORDER BY COUNT(sales_method) DESC;

-- Online is where most sales are coming from.

-- How many different retailers are there?
SELECT COUNT(DISTINCT(retailer))
FROM locations;

-- There are a total of 6 different retailers in the data.

-- Does Adidas sell to all 50 US states?
SELECT COUNT(DISTINCT(state)) AS number_of_states
FROM locations;

-- YES!

-- How many different regions are there in the dataset?
SELECT COUNT(DISTINCT(region)) AS number_of_regions
FROM locations;

-- 5!

-- What are the different products being sold?
SELECT DISTINCT(product) AS products_available
FROM sales;

-- Several different products.

---------------------------- NUMERICAL DATA----------------------------------------------------------------------------
-- What is the average price per unit?
SELECT ROUND(AVG(price_per_unit),2)
FROM sales;

-- $45.22

-- Which product had the most amount of sales?
SELECT product, SUM(total_sales) AS total_sales
FROM sales
GROUP BY product
ORDER BY SUM(total_sales) DESC;

-- Men's street footwear had the most amount of sales.

-- What is the average amount of units sold?
SELECT ROUND(AVG(units_sold),0)
FROM sales;

-- 257

-- Count the times products that sold over the amount of total average sales.
SELECT COUNT(product)
FROM sales
WHERE total_sales >
	(SELECT AVG(total_sales)
    FROM sales);
    
-- 3072
    
-- What is the total amount of units sold per product?
SELECT SUM(units_sold), product
FROM sales
GROUP BY product
ORDER BY SUM(units_sold) DESC;

-- What retailer had the most sales?
SELECT retailer, SUM(total_sales)
FROM locations l
JOIN sales s
ON l.sales_id = s.sales_id
GROUP BY retailer
ORDER BY SUM(total_sales) DESC
LIMIT 1;

-- West Gear.
 
 -- Which region had the most sales?
SELECT region, SUM(total_sales)
FROM locations l
JOIN sales s
ON l.sales_id = s.sales_id
GROUP BY region
ORDER BY SUM(total_sales) DESC
LIMIT 1;

-- West.

-- What retailer had the most operating profit in 2021?
SELECT retailer, SUM(operating_profit)
FROM locations l
JOIN sales s
ON l.sales_id = s.sales_id
WHERE invoice_date >= 2021-01-01
GROUP BY retailer
ORDER BY SUM(operating_profit) DESC
LIMIT 1;

-- West Gear.

-- What was the total amount of total sales and operating profit in San Francisco?
SELECT city, SUM(total_sales) AS sum_sales , SUM(operating_profit) AS sum_profit
FROM locations l
JOIN sales s
ON l.sales_id = s.sales_id
WHERE city = 'San Francisco';

-- Which 3 states had the most operating profit?
SELECT state, SUM(operating_profit) AS sum_profit
FROM locations l
JOIN sales s
ON l.sales_id = s.sales_id
GROUP BY state
ORDER BY SUM(operating_profit) DESC
LIMIT 3;

-- NY, CA, FL.

-- Which sales method contributed to the highest amount of sales?
SELECT sales_method, SUM(total_sales)
FROM sales
GROUP BY sales_method
ORDER BY SUM(total_sales) DESC;

-- Online.

-- Show the average operating profit along with operating profit for each product type.
SELECT SUM(operating_profit), product, (SELECT AVG(operating_profit) AS avg_profit FROM sales)
FROM sales
GROUP BY product;

-- Which state had the highest count of sales?
SELECT COUNT(STATE), state
FROM locations
GROUP BY state
ORDER BY COUNT(state) DESC;

-- Cali and Texas

-- What is the average price per unit per product?
SELECT product, AVG(price_per_unit) AS avg_price
FROM sales
GROUP BY product
ORDER BY AVG(price_per_unit) DESC;

-- Women's apparel had the highest.

-- Which region had the most units sold?
SELECT region, SUM(units_sold)
FROM locations l
JOIN sales s
ON l.sales_id = s.sales_id
GROUP BY region
ORDER BY SUM(units_sold) DESC;

-- West.

-- What sales method contributed to the highest amount of operating profit?
SELECT sales_method, SUM(operating_profit)
FROM sales
GROUP BY sales_method
ORDER BY SUM(operating_profit) DESC;

-- In store!

-- What was the average price per unit in the midwest?
SELECT AVG(price_per_unit) AS avg_price_unit, region
FROM locations l
JOIN sales s
ON l.sales_id = s.sales_id
WHERE region = 'Midwest';

-- 40.37

-- Were there any transactions that had more units sold than the average price per unit?
SELECT *
FROM sales AS profit_sales
WHERE units_sold < 
	(SELECT AVG(price_per_unit)
    FROM sales AS average_sales
    WHERE average_sales.sales_id = profit_sales.sales_id
    );
    
-- What was the total sales for months of December and January?
SELECT SUM(total_sales), MONTH(invoice_date)
FROM sales s
JOIN locations l
ON s.sales_id = l.sales_id
WHERE MONTH(invoice_date) IN (12,01)
GROUP BY MONTH(invoice_date);

-- December had more sales, no surprise!
    