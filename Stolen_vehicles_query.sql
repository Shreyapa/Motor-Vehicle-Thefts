								/* MOTOR VEHICLE THEFTS ANALYSIS */

/* As a data analyst for the Zew Zealand police department to help raise awareness about motor vehicle thefts */

/* The police department plan to release a public service announcement to encourge citizens to be aware of theft and stay safe*/

/*Objetives: 1) Identify when vehicles are likely to be stolen.,
             2) Identify which vehicles are likely to be stolen.,
             3) Identify where vehicles are likely to be stolen. */

/* Objective 1) Identify when vehicles are likely to be stolen */

/* Find the number of vehicles stolen each year*/

SELECT * 
FROM stolen_vehicles;

SELECT YEAR(date_stolen), COUNT(vehicle_id) AS num_vehicles
FROM stolen_vehicles
GROUP BY YEAR(date_stolen);

/*Find the number of vehicles stolen each month */

SELECT YEAR(date_stolen), MONTH(date_stolen), COUNT(vehicle_id) AS num_vehicles
FROM stolen_vehicles
GROUP BY YEAR(date_stolen), MONTH(date_stolen)
ORDER BY YEAR(date_stolen),MONTH(date_stolen);

/* Find the number vehicle for April month */

SELECT YEAR(date_stolen), MONTH(date_stolen),DAY(date_stolen), COUNT(vehicle_id) AS num_vehicles
FROM stolen_vehicles
WHERE MONTH(date_stolen) = 4
GROUP BY YEAR(date_stolen), MONTH(date_stolen),DAY(date_stolen)
ORDER BY YEAR(date_stolen),MONTH(date_stolen), DAY(date_stolen);

/*Find the number of vehicles stolen each day of the week */

SELECT DAYOFWEEK(date_stolen) AS dow, COUNT(vehicle_id) AS num_vehicles
FROM stolen_vehicles
GROUP BY DAYOFWEEK(date_stolen)
ORDER BY dow;

/*Replace the numeric day of week values with the ful name of each day of the week (Sunday, Monday,...)*/

SELECT DAYOFWEEK(date_stolen) AS dow, 
	CASE WHEN DAYOFWEEK(date_stolen) = 1 THEN 'Sunday'
	     WHEN DAYOFWEEK(date_stolen) = 2 THEN 'Monday'
		 WHEN DAYOFWEEK(date_stolen) = 3 THEN 'Tuesday'
		 WHEN DAYOFWEEK(date_stolen) = 4 THEN 'Wednesday'
		 WHEN DAYOFWEEK(date_stolen) = 5 THEN 'Thursday'
		 WHEN DAYOFWEEK(date_stolen) = 6 THEN 'Friday'
		 ELSE 'Saturday' END AS day_of_week,
		 COUNT(vehicle_id) AS num_vehicles
FROM stolen_vehicles
GROUP BY DAYOFWEEK(date_stolen), day_of_week
ORDER BY dow;

/* Objective 2:Identify which vehicles are likely to be stolen */

/* Find the vehicle types that are most often and least often stolen */

/*Most Often*/
SELECT vehicle_type, COUNT(vehicle_id) AS num_vehicles
FROM stolen_vehicles
GROUP BY vehicle_type
ORDER BY num_vehicles DESC
LIMIT 5;

/*Least Often*/
SELECT vehicle_type, COUNT(vehicle_id) AS num_vehicles
FROM stolen_vehicles
GROUP BY vehicle_type
ORDER BY num_vehicles 
LIMIT 5;

/*For each vehicle type, find the average age of the cars that are stolen */
SELECT vehicle_type, ROUND(AVG(YEAR(date_stolen) - model_year),1) AS avg_age
FROM stolen_vehicles
GROUP BY vehicle_type
ORDER BY avg_age DESC;

/*For each vehicle type, find the percent of vehicles stolen that are luxury versus standard*/

SELECT * FROM stolen_vehicles;
SELECT * FROM make_details;

WITH lux_standard AS (SELECT vehicle_type, 
	CASE WHEN make_type = 'Luxury' THEN 1 
	ELSE 0 END AS luxury
FROM stolen_vehicles sv 
LEFT JOIN make_details md
ON sv.make_id = md.make_id)

SELECT vehicle_type, SUM(luxury)/COUNT(luxury) * 100 AS pct_lux
FROM lux_standard
GROUP BY vehicle_type
ORDER BY pct_lux DESC;

/* Create a table where the rows represent the top 10 vehicle types, the columns 
represent the top 7 vehicle colors (plus 1 column for all other colors) and the values are the number of vehicles stolen */

SELECT color, COUNT(vehicle_id) AS num_vehicles
FROM stolen_vehicles
GROUP BY color
ORDER BY num_vehicles DESC;

SELECT vehicle_type, COUNT(vehicle_id) AS num_vehicles
	SUM(CASE WHEN color = 'Silver'THEN 1 ELSE 0 END) AS silver,
	SUM(CASE WHEN color = 'White'THEN 1 ELSE 0 END) AS white,
	SUM(CASE WHEN color = 'Black'THEN 1 ELSE 0 END) AS black,
	SUM(CASE WHEN color = 'Blue'THEN 1 ELSE 0 END) AS blue,
	SUM(CASE WHEN color = 'Red'THEN 1 ELSE 0 END) AS red,
	SUM(CASE WHEN color = 'Grey'THEN 1 ELSE 0 END) AS grey,
	SUM(CASE WHEN color = 'Green'THEN 1 ELSE 0 END) AS green,
	SUM(CASE WHEN color IN ('Gold','Brown','Yellow','Orange', 'Purple','Cream','Pink') THEN 1 ELSE 0 END) AS other
FROM stolen_vehicles
GROUP BY vehicle_type
ORDER BY num_vehicles DESC
LIMIT 10;

/* Objective 3 : Identify where vehicles are likely to be stolen */

/*Find the number of vehicles that were stolen in each region*/
SELECT * FROM stolen_vehicles;
SELECT * FROM locations;

SELECT region, COUNT(vehicle_id) as num_vehicles
FROM stolen_vehicles sv LEFT JOIN locations l
ON sv.location_id = l.location_id
GROUP BY region
ORDER BY num_vehicles DESC;

/* Combine the previous output with the population and density statistics for each region*/

SELECT l.region, COUNT(sv.vehicle_id) as num_vehicles, l.population, l.density
FROM stolen_vehicles sv LEFT JOIN locations l
ON sv.location_id = l.location_id
GROUP BY l.region, l.population,l.density
ORDER BY num_vehicles DESC;

/* Do the types of vehicles stolen in the three most dense regions differ from the three least dense regions?*/

SELECT l.region, COUNT(sv.vehicle_id) as num_vehicles, l.population, l.density
FROM stolen_vehicles sv LEFT JOIN locations l
ON sv.location_id = l.location_id
GROUP BY l.region, l.population,l.density
ORDER BY l.density DESC;


(SELECT 'High density', sv.vehicle_type, COUNT(sv.vehicle_id) AS num_vehicles
FROM stolen_vehicles sv LEFT JOIN locations l
ON sv.location_id = l.location_id
WHERE l.region IN ('Auckland', 'Nelson', 'Wellington')
GROUP BY sv.vehicle_type
ORDER BY num_vehicles DESC
LIMIT 5)

UNION
(SELECT 'Low density',sv.vehicle_type, COUNT(sv.vehicle_id) AS num_vehicles
FROM stolen_vehicles sv LEFT JOIN locations l
ON sv.location_id = l.location_id
WHERE l.region IN ('Otago', 'Gisborne', 'Southland')
GROUP BY sv.vehicle_type
ORDER BY num_vehicles DESC
LIMIT 5);





	







