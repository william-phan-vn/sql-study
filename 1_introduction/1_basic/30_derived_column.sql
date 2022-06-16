SELECT 	id,
				account_id,
				standard_amt_usd / standard_qty AS unit_price
FROM orders
LIMIT 10;

SELECT 	id,
		account_id,
		poster_amt_usd / total_amt_usd * 100 AS post_per
FROM orders
LIMIT 10;
