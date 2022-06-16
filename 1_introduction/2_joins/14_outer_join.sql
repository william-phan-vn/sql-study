SELECT a.id, a.name, o.total
FROM orders o
LEFT JOIN accounts a
ON o.account_id = a.id

-- Only exist in one of the two tables


-- all
OUTER JOIN
