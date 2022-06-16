SELECT a.name, w.occurred_at, a.primary_poc, w.channel
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
WHERE a.name = 'Walmart'
LIMIT 10;

SELECT a.name Account, r.name Region , s.name Sale
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
ORDER BY a.name
LIMIT 10;

SELECT r.name Region, a.name Account,
		o.total_amt_usd/(o.total+0.01) UnitPrice
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
LIMIT 10
