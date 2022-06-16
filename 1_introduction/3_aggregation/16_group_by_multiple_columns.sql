SELECT a.name,
		AVG(o.standard_amt_usd) avgStandard,
		AVG(o.gloss_amt_usd) avgGloss,
		AVG(o.poster_amt_usd) avgPoster
FROM accounts a
JOIN orders o
	ON a.id = o.account_id
GROUP BY a.name
LIMIT 10

SELECT s.name salesRep, w.channel, COUNT(w.channel) Times
FROM web_events w
JOIN accounts a
	ON w.account_id = a.id
JOIN sales_reps s
	ON a.sales_rep_id = s.id
GROUP BY s.name, w.channel
ORDER BY Times DESC

SELECT r.name region, w.channel, COUNT(w.channel) Times
FROM web_events w
JOIN accounts a
	ON w.account_id = a.id
JOIN sales_reps s
	ON a.sales_rep_id = s.id
JOIN region r
	ON s.region_id = r.id
GROUP BY r.name, w.channel
ORDER BY Times DESC
