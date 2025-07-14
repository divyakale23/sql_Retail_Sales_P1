--create database 
create database sql_project1;

--SQL Retail Sales Analysis - P1
drop table if exists retail_sales;

create table retail_sales (
	transactions_id	int primary key,
	sale_date date,	
	sale_time time,
	customer_id int,
	gender varchar(20),
	age	int,
	category varchar(20),	
	quantity int,
	price_per_unit float,
	cogs	float,
	total_sale float
);

select count(*) from retail_sales;


--Data Cleaning 
select * from retail_sales 
where transactions_id is null;

select * from retail_sales 
where sale_date is null;

select * from retail_sales 
where 
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	category is null
	or
	quantity is null
	or 
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null;

delete from retail_sales 
where 
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	category is null
	or
	quantity is null
	or 
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null;

--Data Exporation

--How many sales we have 
select count(*) as total_sales from retail_sales;

--How many customers  we have 
select count(distinct(customer_id)) as Customers from retail_sales;


select distinct(customer_id) as Customers from retail_sales;

--How many unique category we have 
select distinct(category) as Category from retail_sales;

--Data Analysis and Business Key Problems and Answers

--  My Analysis & Findings
--  Q.1 Write a SQL quely to retrieve all columns for sales made on '2022-11-05
--  Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in
-- he month of Nov-2022
--  Q.3 Write a SQL query to calculat e the total sales (total_sale) for each category.
--  Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
--  Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
--  Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
--  Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
--  Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
--  Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
--  Q.10 Write a SQL query to create each shift and number of orders (Example Morning <= 12, Afternoon Between 12 & 17, Evening >17)


-- Q.1 Write a SQL quely to retrieve all columns for sales made on '2022-11-05
select * from retail_sales 
where sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4
--in the month of Nov-2022
select 
	*
from retail_sales 
where category = 'Clothing'
	and 
	to_char(sale_date, 'YYYY-MM')='2022-11'
	and 
	quantity >= 4;


-- Q.3 Write a SQL query to calculat e the total sales (total_sale) for each category.
select 
	category,
	sum(total_sale) as net_sale ,
	count(*) as total_sale
from retail_sales
group by 1;


-- - Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select 
	round(avg(age),2) as Average_AGE
from retail_sales
where category = 'Beauty';


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales
where total_sale > 1000;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select 
	category,
	gender,
	count(*) as total_trans
from retail_sales
group by category,
		gender
order by 1;

select * from retail_sales;


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select 
		year,
		month,
		avg_sale
from 
(
select 
	EXTRACT(YEAR FROM sale_date)as year,
	EXTRACT(MONTH FROM sale_date) as month,
	AVG(total_sale) as avg_sale,
	RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date)ORDER BY AVG (total_sale)DESC)	 AS rank
from retail_sales
group by 1, 2 
) as t1
where rank = 1;
--order by 1 , 3 desc;


--  Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
select 
	customer_id,
	sum(total_sale) as TOTAL_SALES
	from retail_sales
group by 1 
order by 2 desc
LIMIT 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select 
	category,
	count(DISTINCT(customer_id)) as COUNT_UNIQUE_CUSTOMER
from retail_sales
group by category;

--  Q.10 Write a SQL query to create each shift and number of orders (Example Morning <= 12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
as 
(
select *,
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time ) <= 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time ) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	End  AS SHIFT
from retail_sales
)
select
	shift,
	count(*) as TOTAL_Orders
from hourly_sale
group by shift;


--end of project