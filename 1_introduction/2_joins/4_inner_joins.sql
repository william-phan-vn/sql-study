SELECT orders.standard_qty, orders.gloss_qty, orders.poster_qty,
       accounts.primary_poc
FROM orders
JOIN accounts
ON orders.account_id = accounts.id
LIMIT 10;

-- JOIN multiple tables
SELECT *
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id
JOIN orders
ON accounts.id = orders.account_id
