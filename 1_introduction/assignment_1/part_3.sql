-- VIEW forestation
CREATE OR REPLACE VIEW forestation
AS
SELECT 	r.*, l.year,
				l.total_area_sq_mi*2.59 land_area_sqkm,
        f.forest_area_sqkm forest_area_sqkm,
        (f.forest_area_sqkm/(l.total_area_sq_mi*2.59))*100 forest_per
FROM regions r
JOIN land_area l
	ON r.country_code = l.country_code
JOIN forest_area f
	ON l.country_code = f.country_code
  AND l.year = f.year
WHERE f.forest_area_sqkm IS NOT NULL AND l.total_area_sq_mi IS NOT NULL;

-- a. Which 5 countries saw the largest amount decrease in forest area from 1990 to 2016? What was the difference in forest area for each?
-- Answer
	-- Brazil	-541510
	-- Indonesia	-282193.9844
	-- Myanmar	-107234.0039
	-- Nigeria	-106506.00098
	-- Tanzania	-102320
WITH forest_change_sqkm AS
(
	SELECT 	f.country_name, f.region, f.year, f.forest_area_sqkm,
		CASE
			WHEN f.country_name = LAG(f.country_name) OVER forest_change_window
			THEN f.forest_area_sqkm - LAG(f.forest_area_sqkm) OVER forest_change_window
			END AS forest_change_sqkm
	FROM forestation f
	WHERE f.country_name != 'World' AND f.year IN (1990, 2016)
	WINDOW forest_change_window AS (ORDER BY f.country_name, f.year)
)
SELECT c.country_name, c.region, ROUND(ABS(c.forest_change_sqkm)) abs_forest_change_sqkm
FROM forest_change_sqkm c
WHERE c.year = 2016
ORDER BY c.forest_change_sqkm
LIMIT 5;

-- b. Which 5 countries saw the largest percent decrease in forest area from 1990 to 2016? What was the percent change to 2 decimal places for each?
-- Answer:
-- Togo	Sub-Saharan Africa	75.45
-- Nigeria	Sub-Saharan Africa	61.80
-- Uganda	Sub-Saharan Africa	59.13
-- Mauritania	Sub-Saharan Africa	46.75
-- Honduras	Latin America & Caribbean	45.03
WITH forest_change_per AS
(
SELECT 	f.country_name, f.region, f.year, f.forest_per,
	CASE
		WHEN f.country_name = LAG(f.country_name) OVER forest_change_window
		THEN (f.forest_area_sqkm - LAG(f.forest_area_sqkm) OVER forest_change_window)/(LAG(f.forest_area_sqkm) OVER forest_change_window)*100
		END AS forest_change_per
FROM forestation f
WHERE f.country_name != 'World' AND f.year IN (1990, 2016)
WINDOW forest_change_window AS (ORDER BY f.country_name, f.year)
)
SELECT c.country_name, c.region, ROUND(ABS(c.forest_change_per)::numeric, 2) AS abs_forest_change_per
FROM forest_change_per c
WHERE c.year = 2016
ORDER BY c.forest_change_per
LIMIT 5;

-- c. If countries were grouped by percent forestation in quartiles, which group had the most countries in it in 2016?
-- Answer: 1 (<=25%) 85 country
SELECT
	CASE
		WHEN f.forest_per <= 25 THEN 1
		WHEN f.forest_per > 25 AND f.forest_per <= 50 THEN 2
		WHEN f.forest_per > 50 AND f.forest_per <= 75 THEN 3
		WHEN f.forest_per > 75 AND f.forest_per <= 100 THEN 4
		END AS quarties,
		COUNT(*) AS country_count
FROM forestation f
WHERE f.year = 2016 AND f.forest_per IS NOT NULL
GROUP BY 1
ORDER BY 1

-- Answer 2
SELECT FLOOR(f.forest_per/25) +1 quartile, count(*)
FROM  forestation f
WHERE year=2016
    AND f.forest_per IS NOT NULL
    AND f.country_name<>'World'
GROUP BY 1;

-- d. List all of the countries that were in the 4th quartile (percent forest > 75%) in 2016.
-- Answer:
-- Suriname	98.26
-- Micronesia, Fed. Sts.	91.86
-- Gabon	90.04
-- Seychelles	88.41
-- Palau	87.61
-- American Samoa	87.50
-- Guyana	83.90
-- Lao PDR	82.11
-- Solomon Islands	77.86
SELECT f.country_name, ROUND(f.forest_per::numeric, 2) AS top_4th_quartiles
FROM forestation f
WHERE f.year = 2016 AND f.forest_per > 75 AND f.forest_per <= 100
ORDER BY f.forest_per DESC

-- e. How many countries had a percent forestation higher than the United States in 2016?
-- Answer: 94
-- US forest_per: 33.93
WITH us_forest_per AS
(
	SELECT f.forest_per us_forest_per
  FROM forestation f
  WHERE f.year = 2016 AND f.country_name = 'United States'
)
SELECT f.country_name, f.forest_per
FROM forestation f
JOIN us_forest_per u
	ON f.forest_per != 0
WHERE f.year = 2016 AND f.forest_per >= u.us_forest_per
ORDER BY f.forest_per
