CREATE VIEW customer_repo AS
WITH customer_sales_cte AS (
    SELECT
        s.order_number,
        s.product_key,
        s.order_date,
        s.sales_amount,
        s.quantity,
        c.customer_key,
        c.customer_number,
        CONCAT(c.first_name, ' ', c.last_name) AS full_name,
        DATE_PART('year', AGE(CURRENT_DATE, c.birthdate))::INT AS age
    FROM 
        c_sales AS s
    LEFT JOIN 
        a_customers AS c 
        ON s.customer_key = c.customer_key
    WHERE
        s.order_date IS NOT NULL
)
, customer_summary AS(

SELECT
    full_name,
    age,
    customer_key,
    customer_number,
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    MAX(order_date) AS last_order_date,
    MIN(order_date) AS first_order_date,
    (DATE_PART('year', AGE(MAX(order_date), MIN(order_date))) * 12 +
     DATE_PART('month', AGE(MAX(order_date), MIN(order_date)))) AS lifespan_months
FROM
    customer_sales_cte
GROUP BY
    customer_key,
	full_name,
	age,
	customer_number
)
SELECT
	full_name,
	age,
		CASE
			WHEN age < 20 THEN 'UNDER 20'
			WHEN age BETWEEN 20 AND 30 THEN '20 TO 30'
			WHEN age BETWEEN 30 AND 40 THEN '30 TO 40'
			WHEN age BETWEEN 40 AND 49 THEN '40 TO 49'
			ELSE 'ABOVE 50'
			END AS age_grouping,
	customer_key,
	customer_number,
	total_orders,
	total_sales,
	total_quantity,
		CASE 
			WHEN lifespan_months > 12 AND total_sales >= 5000 THEN 'VIP'
			WHEN lifespan_months > 12 AND total_sales < 5000 THEN 'REGULAR'
			ELSE 'NEW'
			END AS customer_grouping,
	lifespan_months,
	DATE_PART('year', AGE(CURRENT_DATE,last_order_date))*12 +
	DATE_PART('month',AGE(CURRENT_DATE,last_order_date))AS recency,
		CASE
			WHEN total_orders = 0 THEN 0
			ELSE total_sales / total_orders
			END AS avg_order_value,
		CASE 
			WHEN lifespan_months = 0 THEN total_sales
			ELSE total_sales / lifespan_months
			END AS avg_per_month_sales
FROM 
	customer_summary
