--======================================
--QUESTION: Total amount spent per user per month
--CONCEPTS: DateTime manipulation, GROUP BY, JOIN
--======================================
SELECT name, TO_CHAR(t.transaction_date, 'YYYY-MM') as Month, SUM(amount) AS total_spent
FROM users u
INNER JOIN transactions t ON u.user_id = t.user_id
GROUP BY name, TO_CHAR(t.transaction_date, 'YYYY-MM')
ORDER BY Month ASC, name ASC;

--QUESTION: Day of the week which sees the highest transaction volume
SELECT TO_CHAR(transaction_date, 'Day') AS day_of_week, COUNT(*) AS transaction_count
FROM transactions
GROUP BY TO_CHAR(transaction_date, 'Day')
ORDER BY transaction_count DESC;

--QUESTION: Days since each user's last transaction
SELECT name, CURRENT_DATE - MAX(transaction_date) AS days_since_last_transaction
FROM transactions t
JOIN users u ON t.user_id = u.user_id
GROUP BY name;

--============================================================
--QUESTIONS: Ranking users by total spend within each city
--CONCEPTS: Window Functions, JOIN, GROUP BY, CTEs
--============================================================
SELECT name, city, SUM(amount) AS total_spent, RANK() OVER (PARTITION BY city ORDER BY SUM(amount) DESC)
FROM users u
INNER JOIN transactions t ON u.user_id = t.user_id
GROUP BY name, city;


--QUESTION: For each user, show their running total balance over time using SUM() OVER
SELECT name,
	   transaction_date,
	   amount,
	   SUM(t.amount) OVER(PARTITION BY name ORDER BY transaction_date) AS running_total
FROM transactions t
INNER JOIN users u ON t.user_id = u.user_id;

--QUESTION: Flag each user's single largest transaction per month using ROW_NUMBER()
WITH ranked AS (
				SELECT
					  name,
					  TO_CHAR(transaction_date, 'YYYY-MM') AS month,
					  amount,
					  ROW_NUMBER() OVER (
					  		PARTITION BY name, TO_CHAR(transaction_date, 'YYYY-MM')
							ORDER BY amount DESC
					  ) AS rn
					FROM transactions t
					INNER JOIN users u ON u.user_id = t.user_id
)
SELECT name, month, amount AS largest_transaction
FROM ranked
WHERE rn = 1;

--QUESTION: Show month-over-month change in spending per user using LAG()
WITH monthly_spend AS (
					   SELECT
					   name,
					   TO_CHAR(transaction_date, 'YYYY-MM') as month,
					   SUM(amount) AS total_spent
					   FROM users u
					   INNER JOIN transactions t ON u.user_id = t.user_id
					   GROUP BY name, TO_CHAR(transaction_date, 'YYYY-MM')
)
SELECT name, month, total_spent, LAG(total_spent) OVER (PARTITION BY name ORDER BY month)
FROM monthly_spend;

--=========================================================================
--QUESTION: Calculate monthly spend per user, then query on top of that to find who exceeded their previous month's spend
--CONCEPTS: CTEs, Window Functions, GROUP BY, JOIN, ORDER BY
--=========================================================================
WITH monthly_spend AS (
					   SELECT
					   name,
					   TO_CHAR(t.transaction_date, 'YYYY-MM') AS month,
					   SUM(amount) AS total_spent
					 FROM users u
					 INNER JOIN transactions t ON u.user_id = t.user_id
					 GROUP BY name, TO_CHAR(transaction_date, 'YYYY-MM')
),
with_previous AS (
	SELECT
		name,
		month,
		total_spent,
		LAG(total_spent) OVER (PARTITION BY name ORDER BY month) AS prev_month_spend
	FROM monthly_spend
)
SELECT name, month, total_spent, prev_month_spend
FROM with_previous
WHERE total_spent > prev_month_spend;

--=================================================================================
--QUESTION: Find all users whose average transaction amount is above the overall average
--CONCEPTS: Subqueries, HAVING, JOIN, GROUP BY
--=================================================================================
SELECT u.name, AVG(t.amount) as avg_transaction_per_user
FROM users u
INNER JOIN transactions t ON u.user_id = t.user_id
GROUP BY u.name
HAVING AVG(t.amount) > (SELECT AVG(amount)
					   	FROM transactions);
