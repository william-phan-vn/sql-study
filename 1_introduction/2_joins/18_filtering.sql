-- Use AND instead of WHERE
SELECT orders.*, accounts.*
FROM orders
LEFT JOIN accounts
	ON orders.account_id = accounts.id
	AND accounts.sales_rep_id = 321500
