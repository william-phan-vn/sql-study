SELECT s.name, COUNT(a.*) account_amt
FROM sales_reps s
JOIN accounts a
	ON s.id = a.sales_rep_id
GROUP BY 1
HAVING COUNT(a.id) > 5
ORDER BY account_amt DESC

SELECT a.name, COUNT(o.*) orderAmt
FROM accounts a
JOIN orders o
	ON a.id = o.account_id
GROUP BY 1
HAVING COUNT(o.id) > 20
ORDER BY orderAmt DESC

-- 4
SELECT a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
	ON a.id = o.account_id
GROUP BY 1
HAVING COUNT(o.total_amt_usd) > 30000
ORDER BY total_spent DESC
