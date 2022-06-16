SELECT 	SUM(poster_qty) AS TotalPoster,
				SUM(standard_qty) AS TotalStandard,
        SUM(total_amt_usd) AS TotalAmount
FROM orders

SELECT standard_amt_usd, gloss_amt_usd,
		standard_amt_usd + gloss_amt_usd AS Total
FROM orders
LIMIT 10

SELECT 	SUM(standard_amt_usd) AS Cost,
		SUM(standard_qty) AS	Quantity,
        SUM(standard_amt_usd)/SUM(standard_qty) AS StandardUnit
FROM orders
