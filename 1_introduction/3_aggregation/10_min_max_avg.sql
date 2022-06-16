SELECT MIN(occurred_at)
FROM orders

SELECT occurred_at
FROM orders
ORDER BY occurred_at
LIMIT 1

SELECT MAX(occurred_at)
FROM web_events

SELECT occurred_at
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1

SELECT 	AVG(standard_qty)  AvgStandardQty,
				AVG(gloss_qty)  AvgGlossyQty,
        AVG(poster_qty)  AvgPosterQty,
				AVG(standard_amt_usd)  AvgStandardAmt,
				AVG(gloss_amt_usd)  AvgGlossAmt,
        AVG(poster_amt_usd)  AvgPosterAmt
FROM orders

SELECT SUM(total_amt_usd*total)/SUM(total)
FROM orders
