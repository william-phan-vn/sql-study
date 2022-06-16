-- LIKE '%<str>%'
SELECT name
FROM accounts
WHERE name LIKE 'C%'

SELECT name
FROM accounts
WHERE name LIKE '%one%'

SELECT name
FROM accounts
WHERE name LIKE '%s'

-- IN
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');

-- NOT
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom');

SELECT name
FROM accounts
WHERE name NOT LIKE 'C%';

-- AND
SELECT *
FROM orders
WHERE standard_qty > 1000 AND poster_qty = 0 AND gloss_qty = 0;

SELECT *
FROM accounts
WHERE name NOT LIKE 'C%' AND name LIKE '%s';

-- BETWEEN
SELECT *
FROM orders
WHERE gloss_qty BETWEEN 24 AND 29
ORDER BY gloss_qty;

SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords') AND occurred_at BETWEEN '2016-01-01' AND '2016-12-31'
ORDER BY occurred_at DESC;

-- OR
SELECT id
FROM orders
WHERE gloss_qty > 4000 OR poster_qty > 4000;

SELECT id, standard_qty, gloss_qty, poster_qty
FROM orders
WHERE standard_qty = 0 AND (gloss_qty > 1000 OR poster_qty > 1000);

SELECT name, primary_poc
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%')
			AND ((primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%')
            AND primary_poc NOT LIKE '%eana%');
