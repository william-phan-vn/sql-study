SELECT a.name account, r.name region, COUNT(r.name)
FROM accounts a
JOIN sales_reps s
	ON a.sales_rep_id = s.id
JOIN region r
	ON s.region_id = r.id
GROUP BY account, region
ORDER BY region DESC
