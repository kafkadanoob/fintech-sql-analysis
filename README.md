# Fintech Transaction Analysis - SQL Project

## Project Overview
A SQL-based analysis of a fictional US fintech platform's 
transaction data, built to demonstrate analytical SQL skills 
applied to a simulated fintech scenario; covering user 
spending behaviour, transaction patterns, and period-over-period 
comparisons.

## Dataset
Four tables generated using Mockaroo. All data is fictional 
and was generated for the purpose of this project.

- users (75 rows)
- transactions (1000 rows)
- categories (7 rows, manually inserted)
- transaction_categories (1000 rows)

## Business Questions Answered
1. What is the total amount spent per user per month?
2. Which day of the week has the highest transaction volume?
3. How many days since each user's last transaction?
4. Which users rank highest in spending within each city?
5. What is each user's running total balance over time?
6. What is each user's largest transaction per month?
7. Which users exceeded their previous monthly spending?
8. Which users spend above the overall average across all transactions?

## SQL Concepts Practiced
- Window functions: RANK(), ROW_NUMBER(), LAG(), SUM() OVER
- CTEs (Common Table Expressions)
- DateTime functions: TO_CHAR(), EXTRACT(), DATE_TRUNC()
- Subqueries
- Aggregate filtering with HAVING

## Key Findings
- Friday recorded the highest transaction volume with 156 transactions
- 35 out of 75 users averaged above the overall transaction average
- Phebe Le Barr recorded the highest single-month spend in June 2025

## Tools Used
PostgreSQL 17, pgAdmin 4, Mockaroo
