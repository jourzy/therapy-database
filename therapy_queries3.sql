USE db_therapy;

-- + Use at least 5 queries to retrieve data
-- + Use at least 1 query to delete data - DELETE CLIENT SESSION NOTES
-- + Use at least 2 aggregate functions - SUM, COUNT
-- + Use at least 2 joins - INNER, LEFT
-- + Use at least 2 additional in-built functions (to the two aggregate functions already counted in previous point) - TIME_FORMAT(), CONCAT()
-- + Use data sorting for majority of queries with ORDER BY
-- + Create and use one stored procedure or function to achieve a goal - RETURN DAY OF WEEK, IS_BOOKED

-- a query to find out a customer's identification
SELECT c.first_name AS "First name", c.last_name AS "Last name", e.ethnicity_description AS Ethnicity, i.identity_description AS "Identify as",
p.pronoun_description AS Pronouns
FROM tbl_clients AS c
INNER JOIN tbl_ethnicity AS e ON c.ethnicity = e.ethnicity_code
INNER JOIN tbl_identity AS i ON c.identify_as = i.identity_code
INNER JOIN tbl_pronouns AS p ON c.pronouns = p.pronoun_code
WHERE c.first_name = "Mary";

-- a function to take the day number and convert into the name of the weekday
DELIMITER //
CREATE FUNCTION get_day_name(
    day_number INT
) 
RETURNS VARCHAR(10)
-- a deterministic function always returns the same result for the same input parameters
DETERMINISTIC
BEGIN
	DECLARE day_name VARCHAR(10);
	CASE day_number
        WHEN 0 THEN SET day_name = "Monday";
        WHEN 1 THEN SET day_name = "Tuesday";
		WHEN 2 THEN SET day_name = "Wednesday";
		WHEN 3 THEN SET day_name ="Thursday";
		WHEN 4 THEN SET day_name = "Friday";
    END CASE;
    RETURN (day_name);
END//
DELIMITER ; 

-- DROP FUNCTION get_day_name;

-- Turn ON Event Scheduler 
SET GLOBAL event_scheduler = ON;

DELIMITER //
-- event to check if bookings have passed their end date
-- if it has, expired column in tbl_bookigs will be set to True.
CREATE EVENT IF NOT EXISTS update_expired
ON SCHEDULE EVERY 1 DAY
STARTS NOW()
ON COMPLETION PRESERVE
DO BEGIN
	UPDATE tbl_bookings
	SET expired = True
	WHERE end_date < CURRENT_DATE();
END //
DELIMITER ;

-- a query to display the therapy schedule showing day of the week, time, and venue
SELECT get_day_name(s.day_of_week) AS "Day", time_format(s.time_of_day,"%H%i") AS "Time", v.v_name AS Venue
FROM tbl_schedule AS s
INNER JOIN tbl_venues AS v ON s.venue_id = v.id
ORDER BY s.day_of_week, s.time_of_day;

-- finding sessions in the schedule that are AVAILABLE
-- useful when a new client wants to book a session in the schedule
-- use a left join where null
SELECT get_day_name(s.day_of_week) AS "Day", time_format(s.time_of_day,"%H%i") AS "Time", v.v_name AS Venue
FROM tbl_schedule AS s
INNER JOIN tbl_venues AS v ON s.venue_id = v.id
LEFT JOIN tbl_bookings AS b ON s.schedule_id = b.schedule_id
WHERE b.schedule_id IS NULL OR b.expired = True
ORDER BY s.day_of_week, s.time_of_day;

-- a query to return all current booked sessions 
SELECT get_day_name(s.day_of_week) AS "Day", time_format(s.time_of_day,"%H%i") AS "Time", v.v_name AS Venue,
		concat(c.first_name, ' ', c.last_name) AS "Client"
FROM tbl_schedule AS s
INNER JOIN tbl_venues AS v ON s.venue_id = v.id
LEFT JOIN tbl_bookings AS b ON s.schedule_id = b.schedule_id
INNER JOIN tbl_clients AS c ON b.client_id = c.client_id
WHERE b.schedule_id IS NOT NULL AND b.expired = False
ORDER BY s.day_of_week, s.time_of_day;

-- a view of the bookings schedule
CREATE OR REPLACE VIEW vw_bookings AS
	SELECT get_day_name(s.day_of_week) AS "Day", time_format(s.time_of_day,"%H%i") AS "Time", v.v_name AS Venue,
			concat(c.first_name, ' ', c.last_name) AS "Client"
	FROM tbl_schedule AS s
	INNER JOIN tbl_venues AS v ON s.venue_id = v.id
	LEFT JOIN tbl_bookings AS b ON s.schedule_id = b.schedule_id
	INNER JOIN tbl_clients AS c ON b.client_id = c.client_id
	WHERE b.schedule_id IS NOT NULL AND b.expired = False
	ORDER BY s.day_of_week, s.time_of_day;
    
SELECT * FROM vw_bookings;

-- a function to find out if a session is available to book
DELIMITER //
CREATE FUNCTION is_booked(
    p_day_of_week INT,
    p_time_of_day TIME
) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
	DECLARE booked BOOLEAN;
    SET booked = (select count(b.booking_id) from tbl_bookings as b where b.schedule_id IN 
    (select s.schedule_id from tbl_schedule AS s where s.day_of_week = p_day_of_week AND s.time_of_day = p_time_of_day));
    RETURN (booked);
END//
DELIMITER ; 

-- DROP FUNCTION is_booked;

-- running the is_booked function to output to user if session is available or booked.
SELECT IF(is_booked(2, "16:00:00"), 'This session is not available', 'This session is available') as Availability;

-- see session notes for a particular client
SELECT s.session_date AS "Date", s.notes AS "Session notes"
FROM tbl_sessions AS s
INNER JOIN tbl_clients AS c ON c.client_id = s.client_id
WHERE c.first_name = "Roisin" AND c.last_name = "Johns"
ORDER BY s.session_date DESC;

-- a client leaves so all their session notes must be deleted
DELETE FROM tbl_sessions AS t
WHERE t.client_id IN (
	SELECT c.client_id
	FROM tbl_clients AS c
	WHERE first_name = "Charlotte" AND last_name = "Green");
