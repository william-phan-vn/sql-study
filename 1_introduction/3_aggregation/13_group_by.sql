SELECT a.name, o.occurred_at
FROM orders o
JOIN accounts a
	ON a.id = o.account_id
ORDER BY o.occurred_at
LIMIT 1

SELECT a.name, SUM(total_amt_usd) totalSales
FROM orders o
JOIN accounts a
	ON a.id = o.account_id
GROUP BY a.name

SELECT a.name, w.channel, w.occurred_at
FROM web_events w
JOIN accounts a
	ON w.account_id = a.id
ORDER BY w.occurred_at DESC
LIMIT 1

SELECT w.channel, COUNT(w.occurred_at) Times
FROM web_events w
GROUP BY w.channel
ORDER BY Times DESC

SELECT a.primary_poc, w.occurred_at
FROM web_events w
JOIN accounts a
	ON w.account_id = a.id
ORDER BY w.occurred_at
LIMIT 1

SELECT a.name, SUM(total_amt_usd) total
FROM orders o
JOIN accounts a
	ON o.account_id = a.id
GROUP BY a.name
ORDER BY total
LIMIT 1

SELECT r.name, COUNT(s.name) salesNumber
FROM sales_reps s
JOIN region r
	ON s.region_id = r.id
GROUP BY r.name
ORDER BY salesNumber DESC
