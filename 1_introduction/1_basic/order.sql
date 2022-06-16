SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at
LIMIT 10;

SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 10;

SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY total_amt_usd
LIMIT 5;
