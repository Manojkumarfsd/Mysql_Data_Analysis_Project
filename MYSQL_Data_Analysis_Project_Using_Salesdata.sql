-- Questions
-- 1. Write a sql query to retrieve all columns for sales made on "2022-11-05"
-- 2, Retrieve all data where category is clothing and quantity sold is more than 10 in the month of nov-2022
-- 3, write a sql query to calculate the total sales  (total_sale) for each category
-- 4, find the average age of customers who purchased items from the beauty category?
-- 5,write a sql query to find all transaction where the total sale is greater than 1000
-- 6, write a sql query to find the total number of transactions (transaction_id) made by each gender in each category?
-- 7, write a sql query to calculate the average sale for each month find out best selling month in each year?
-- 8, write a sql query to find the top 5 customers based on highest total sales?
-- 9, find the number of unique customers who purchased items from each category?
-- 10, write a sql query to create each shift and number of orders (example morning<=12, afternoon between 12 & 17, evening >17)

show databases;
create database sql_project_p2;
use sql_project_p2;
create table retailsales(
transactions_id int primary key,
sale_date date,
sale_time time,
customer_id int,
gender varchar(15),
age int,
category varchar(15),
quantity int,
price_per_unit float,
cogs float,
total_sales float
);
select database();
use sql_project_p2;

describe retailsales;

select * from retailsales;
select count(*) from retailsales;
select  count(distinct customer_id)  from retailsales;

-- 1. Write a sql query to retrieve all columns for sales made on "2022-11-05"

select * from retailsales
where sale_date= "2022-11-05";

-- 2, Retrieve all data where category is clothing and quantity sold is more than 10 in the month of nov-2022
select * from retailsales
where category="clothing"
and
to_char(sale_date,"yyyy-mm")="2022-11"
and
quantity>=4;
SELECT *
FROM retailsales
WHERE category = 'clothing'
AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
AND quantity >= 4;
-- 3, write a sql query to calculate the total sales  (total_sale) for each category
 
select category,sum(total_sales),count(*) from retailsales
group by category;

-- 4, find the average age of customers who purchased items from the beauty category?

 select category,round(avg(age),2) from retailsales
 where category="beauty"
 group by 1;
 
 -- 5,write a sql query to find all transaction where the total sale is greater than 1000
select * from retailsales
where total_sales>1000;

-- 6, write a sql query to find the total number of transactions (transaction_id) made by each gender in each category?

select category,gender,count(*) from retailsales
group by category,gender
order by category;

-- 7, write a sql query to calculate the average sale for each month find out best selling month in each year?
select * from retailsales;
select year(sale_date) as sales_on_year,month(sale_date) as sales_on_month,
round(avg(total_sales),2) as Avg_sales,
dense_rank() over(
partition by year(sale_date)
order by round(avg(total_sales),2)desc
) as Month_Rank
from retailsales
group by 1,2 
order by 1,3 desc;

-- option 2 for more precisely
SELECT
    sales_on_year AS year,
    sales_on_month AS month,
    avg_sales
FROM (
    SELECT 
        YEAR(sale_date) AS sales_on_year,
        MONTH(sale_date) AS sales_on_month,
        ROUND(AVG(total_sales), 2) AS avg_sales,
        RANK() OVER (
            PARTITION BY YEAR(sale_date)
            ORDER BY ROUND(AVG(total_sales), 2) DESC
        ) AS Month_Rank
    FROM 
        retailsales
    GROUP BY 
        sales_on_year, sales_on_month
) AS t1
WHERE Month_Rank = 1;


-- 8, write a sql query to find the top 5 customers based on highest total sales?
select customer_id,sum(total_sales) as sales_value
from retailsales
group by customer_id
order by sales_value desc
limit 5;

-- 9, find the number of unique customers who purchased items from each category?
select category,customer_id from retailsales;

SELECT category, COUNT( distinct customer_id) 
FROM retailsales 
GROUP BY category;

-- 10, write a sql query to create each shift and number of orders (example morning<=12, afternoon between 12 & 17, evening >17)

SELECT 
    CASE
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS total_sales
FROM retailsales
GROUP BY shift;
