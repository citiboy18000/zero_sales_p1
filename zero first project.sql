-- CREATE a Database
CREATE DATABASE zero_analyst_db;

-- Data Exploration
SELECT * 
FROM sales;

-- How many sales we have?
SELECT COUNT(*) as total_sales
FROM sales;


-- How many uniuque customers we have ?
SELECT COUNT(DISTINCT customer_id) as total_sales
FROM sales;

SELECT DISTINCT category 
FROM sales;

/* -- Data Analysis & Business Key Problems & Answers
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)*/

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT * 
FROM sales 
WHERE sale_date ='2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
SELECT *
FROM sales
WHERE category = 'Clothing'
	AND quantiy >3
	-- AND year(sale_date) = '2022'
    -- AND month(sale_date) = '11'
	AND sale_date LIKE '2022-11-%';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
	category, 
    SUM(total_sale) AS sales_by_category,
    COUNT(*) as total_orders, 
    -- sum(COUNT(*)) OVER(),
   concat(round(COUNT(*)/ sum(COUNT(*)) OVER() *100, 2), '%') order_percent
FROM sales 
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT round(AVG(age), 2) as avg_age 
FROM sales
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
 SELECT * 
 FROM sales 
 WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
	gender, 
	count(Trans_id) order_count
FROM sales
GROUP BY gender
ORDER BY order_count DESC;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
WITH cte as
(SELECT 
	year(sale_date) sale_year,
    month(sale_date) sale_month,
	round(avg(total_sale), 2)  monthly_sales
    FROM sales
    GROUP BY sale_year, sale_month
    ORDER BY sale_year, sale_month),
cte_2 as
(SELECT 
sale_year,
sale_month, 
monthly_sales,
RANK() OVER(PARTITION BY sale_year ORDER BY monthly_sales DESC) ranking
	
FROM cte)
SELECT * FROM cte_2
WHERE ranking =1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
SELECT 
	customer_id,
    sum(total_sale) total_sales 
    FROM sales
    GROUP BY customer_id
    ORDER BY total_sales DESC
    LIMIT 5;
    
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT
	category,
	count(DISTINCT customer_id) cust_count
FROM sales 
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH cte as(
SELECT 
	sale_time, 
    CASE
		WHEN hour(sale_time) <=12 THEN 'morning'
        WHEN hour(sale_time) BETWEEN 12 and 17 THEN 'Afternoon'
        ELSE 'Evening' 
	END AS shift
FROM sales)
SELECT 
shift,
count(*) order_count
FROM cte
GROUP BY shift
