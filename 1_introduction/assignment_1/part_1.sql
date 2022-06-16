SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='regions'

SELECT *
FROM regions
LIMIT 10;

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


-- a. What was the total forest area (in sq km) of the world in 1990?
SELECT 	f.forest_area_sqkm
FROM forestation f
WHERE f.country_name = 'World' AND f.year = 1990;
-- Result: 41282694.9

-- b. What was the total forest area (in sq km) of the world in 2016
-- Result: 39958245.9

-- c. What was the change (in sq km) in the forest area of the world from 1990 to 2016?
-- Result: Decrease 1324449 sqkm
SELECT 	f.country_name, f.year, f.forest_area_sqkm,
		f.forest_area_sqkm - LAG(f.forest_area_sqkm) OVER(ORDER BY f.year) AS forest_change_sqkm
FROM forestation f
WHERE f.country_name = 'World' AND f.year IN (1990, 2016)
ORDER BY f.year;

-- d. What was the percent change in forest area of the world between 1990 and 2016?
-- Result: Decrease 3.23%
SELECT 	f.country_name, f.year, f.forest_per,
		ROUND(((f.forest_per - LAG(f.forest_per) OVER forest_change_window)/(LAG(f.forest_per) OVER forest_change_window) * 100)::numeric, 2) AS forest_change_per
FROM forestation f
WHERE f.country_name = 'World' AND f.year IN (1990, 2016)
WINDOW forest_change_window AS (ORDER BY f.country_name, f.year)
ORDER BY f.country_name, f.year;

-- e. If you compare the amount of forest area lost between 1990 and 2016, to which country's total area in 2016 is it closest to?
-- Result: Peru

WITH forest_change_sqkm AS
(
  SELECT 	f.country_name, f.year, f.forest_area_sqkm,
          f.forest_area_sqkm - LAG(f.forest_area_sqkm) OVER(ORDER BY f.year) AS forest_change_sqkm
  FROM forestation f
  WHERE f.country_name = 'World' AND f.year IN (1990, 2016)
  ORDER BY f.year
)
SELECT 	f.country_name,  f.land_area_sqkm, c.forest_change_sqkm global_forest_change,
		ROUND(ABS(f.land_area_sqkm + c.forest_change_sqkm)) AS land_forest_diff
FROM forestation f
JOIN forest_change_sqkm c
	ON f.year = c.year
WHERE f.year = 2016
ORDER BY land_forest_diff
LIMIT 1;
