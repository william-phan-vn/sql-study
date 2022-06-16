
--
CREATE OR REPLACE VIEW forestation_region
AS
SELECT r.region, l.year,
			SUM(l.total_area_sq_mi)*2.59 total_land_area_sqkm,
			SUM(f.forest_area_sqkm) total_forest_area_sqkm,
		 	SUM(f.forest_area_sqkm)/(SUM(l.total_area_sq_mi)*2.59)*100 forest_area_per
FROM regions r
JOIN land_area l
	ON r.country_code = l.country_code
JOIN forest_area f
	ON l.country_code = f.country_code
	AND l.year = f.year
WHERE l.year IN (1990, 2016)
GROUP BY r.region, l.year
ORDER BY r.region, l.year

-- a.
-- What was the percent forest of the entire world in 2016?
-- Result: 31.38%
SELECT f.region, f.year, ROUND(f.forest_area_per::numeric, 2) forest_area_per
FROM forestation_region f
WHERE f.year = 2016 AND f.region= 'World'

-- Which region had the HIGHEST percent forest in 2016, and which had the LOWEST, to 2 decimal places?
-- LOWEST: Middle East & North Africa (2.07%)
SELECT f.region, f.year,
		ROUND(f.forest_area_per::numeric, 2) forest_area_per
FROM forestation_region f
WHERE f.year = 2016
ORDER BY forest_area_per
LIMIT 1;
-- HIGHEST: Latin America & Caribbean (46.16%)
SELECT f.region, f.year,
		ROUND(f.forest_area_per::numeric, 2) forest_area_per
FROM forestation_region f
WHERE f.year = 2016
ORDER BY forest_area_per DESC
LIMIT 1;

-- b.
-- What was the percent forest of the entire world in 1990?
-- Result: 32.42
SELECT f.region, f.year, ROUND(f.forest_area_per::numeric, 2) forest_area_per
FROM forestation_region f
WHERE f.year = 1990 AND f.region= 'World'

-- Which region had the HIGHEST percent forest in 1990, and which had the LOWEST, to 2 decimal places?
-- LOWEST: Middle East & North Africa (1.78%)
-- HIGHEST: Latin America & Caribbean (51.03%)

-- c. Based on the table you created, which regions of the world DECREASED in forest area from 1990 to 2016?
-- Answer: Latin America & Caribbean; Sub-Saharan Africa
WITH forest_change_sqkm AS
(
	SELECT 	f.region, f.year, f.total_forest_area_sqkm,
			CASE
	        	WHEN f.region = LAG(f.region) OVER forest_change_window
	        	THEN f.total_forest_area_sqkm - LAG(f.total_forest_area_sqkm)
																OVER forest_change_window
	          END AS forest_change_sqkm
	FROM forestation_region f
	WINDOW forest_change_window AS (ORDER BY f.region, f.year)
)
SELECT c.region
FROM forest_change_sqkm c
WHERE c.year = 2016 AND c.forest_change_sqkm < 0 AND c.region != 'World'
