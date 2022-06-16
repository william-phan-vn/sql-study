SELECT r.name Region, s.name Sale, a.name Account
FROM region r
JOIN sales_reps s
	ON r.id = s.region_id
    AND r.name = 'Midwest'
JOIN accounts a
	ON s.id = a.sales_rep_id
ORDER BY a.name
LIMIT 10

SELECT r.name Region, s.name Sale, a.name Account
FROM region r
JOIN sales_reps s
	ON r.id = s.region_id
    AND (r.name = 'Midwest' AND s.name LIKE 'S%')
JOIN accounts a
	ON s.id = a.sales_rep_id
ORDER BY a.name
LIMIT 10

SELECT r.name Region, s.name Sale, a.name Account
FROM region r
JOIN sales_reps s
	ON r.id = s.region_id
    AND (r.name = 'Midwest' AND s.name LIKE '%K')
JOIN accounts a
	ON s.id = a.sales_rep_id
ORDER BY a.name
LIMIT 10

-- 4
SELECT r.name Region, a.name Account,
		o.total_amt_usd/(o.total + 0.01) UnitPrice,
        o.standard_amt_usd
FROM region r
JOIN sales_reps s
	ON r.id = s.region_id
JOIN accounts a
	ON s.id = a.sales_rep_id
RIGHT JOIN orders o
	ON a.id = o.account_id
    AND o.standard_qty >= 100
LIMIT 10

-- 5
SELECT r.name Region, a.name Account,
		o.total_amt_usd/(o.total + 0.01) UnitPrice,
        o.standard_amt_usd,
        o.poster_qty
FROM region r
JOIN sales_reps s
	ON r.id = s.region_id
JOIN accounts a
	ON s.id = a.sales_rep_id
RIGHT JOIN orders o
	ON a.id = o.account_id
    AND o.standard_amt_usd >= 100
    AND o.poster_qty > 50
ORDER BY UnitPrice
LIMIT 10

-- 6
SELECT r.name Region, a.name Account,
		o.total_amt_usd/(o.total + 0.01) UnitPrice,
        o.standard_amt_usd,
        o.poster_qty
FROM region r
JOIN sales_reps s
	ON r.id = s.region_id
JOIN accounts a
	ON s.id = a.sales_rep_id
RIGHT JOIN orders o
	ON a.id = o.account_id
    AND o.standard_amt_usd >= 100
    AND o.poster_qty > 50
ORDER BY UnitPrice DESC
LIMIT 10

-- 7
SELECT DISTINCT a.id, a.name Account, w.channel
FROM accounts a
JOIN web_events w
	ON a.id = w.account_id
    AND a.id = 1001
LIMIT 10

-- 8
SELECT o.occurred_at, a.name Account,
		o.total, o.total_amt_usd
FROM orders o
JOIN accounts a
	ON o.account_id = a.id
    AND o.occurred_at BETWEEN '2015-01-01' AND '2016-01-01'
LIMIT 10
