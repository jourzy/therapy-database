-- You should:
-- + Create a database with at least 3 tables with several columns, use good naming conventions
-- + Link tables using primary and foreign keys effectively
-- + Populate the database with at least 8 rows of mock data per table to show use of DML commands. The data does not need to be real or accurate.
-- + Keep in your code all commands you used to set up your database, tables, and all demo queries. 
--   You can comment out queries you do not want to be auto run
-- + Use at least 3 different data types while creating tables - VARCHAR, CHAR, DATE, TIMESTAMP, INT, BOOLEAN, MEDIUMTEXT
-- + Use at least 2 constraints while creating tables, not including primary key or foreign key - CHECK, NOT NULL, DEFAULT, CREATE INDEX
-- + Use at least 3 queries to insert data - INSERT INTO, UPDATE, ALTER TABLE
-- + Normalise the DB by splitting the data out in tables where appropriate and not containing any duplicate data.
-- + Provide a creative scenario of use

--        <<<<<<<< SCENARIO >>>>>>>>>>>>
-- I am creating a database for my husband who is a therapist.
-- He needs to store client details including session notes securely.
-- He needs to keep records of income and expenses for tax purposes.
-- He needs to be able to manage his booking in his diary.
-- He currently stores all this data on a number of different word processing and spreadsheet files.

-- DROP DATABASE db_therapy;

-- Creating a new database
CREATE DATABASE IF NOT EXISTS db_therapy;

-- Instructing program to use this database
USE db_therapy;

-- smaller tables used to maintain data integrity on input
CREATE TABLE IF NOT EXISTS tbl_communication (
	preferred_code CHAR(1) NOT NULL PRIMARY KEY,
    preferred_description VARCHAR(5) NOT NULL
);

INSERT INTO tbl_communication
VALUES
("E", "email"),
("T", "phone"),
("P", "post");

CREATE TABLE IF NOT EXISTS tbl_identity(
	identity_code CHAR(1) NOT NULL PRIMARY KEY,
    identity_description VARCHAR(20) NOT NULL
);

INSERT INTO tbl_identity
VALUES
("M", "male"),
("F", "female"),
("N", "non-binary"),
("Z", "prefer not to say");

CREATE TABLE IF NOT EXISTS tbl_pronouns(
	pronoun_code CHAR(1) NOT NULL PRIMARY KEY,
    pronoun_description VARCHAR(20) NOT NULL
);

INSERT INTO tbl_pronouns
VALUES
("S", "she/her"),
("H", "he/him"),
("T", "they/them"),
("Z", "prefer not to say");

-- DROP TABLE tbl_pronouns;

CREATE TABLE IF NOT EXISTS tbl_ethnicity(
	ethnicity_code CHAR(1) NOT NULL PRIMARY KEY,
    ethnicity_description VARCHAR(60) NOT NULL
);

INSERT INTO tbl_ethnicity
VALUES
("A", "Asian, Asian British, Asian Welsh"),
("B", "Black, Black British, Black Welsh, Caribbean or African"),
("M", "Mixed or Multiple"),
("O", "Other ethnic group"),
("W", "White"),
("Z", "prefer not to say");

-- DROP TABLE tbl_ethnicity;

CREATE TABLE IF NOT EXISTS tbl_clients(
	client_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(25) NOT NULL,
    address1 VARCHAR(50),
	town VARCHAR(50),
	city VARCHAR(50),
	postcode VARCHAR(10),
    tel_number VARCHAR(20),
    email VARCHAR(50),
    preferred_communication CHAR(1),
    identify_as CHAR(1),
    pronouns CHAR(1),
    ethnicity CHAR(1),
    dob DATE,
    date_joined TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- either tel_number or email must be not null
    -- tested and works
    CONSTRAINT chk_communication CHECK (tel_number IS NOT NULL OR email IS NOT NULL),
    -- add foreign key constraint for preferred communication
	CONSTRAINT fk_client_communication
	FOREIGN KEY (preferred_communication)
	REFERENCES tbl_communication (preferred_code),
	-- add foreign key constraint so identify_as links to tbl_identity
	CONSTRAINT fk_client_identity
	FOREIGN KEY (identify_as)
	REFERENCES tbl_identity (identity_code),
	-- add foreign key constraint so pronouns links to tbl_pronouns
	CONSTRAINT fk_client_pronouns
	FOREIGN KEY (pronouns)
	REFERENCES tbl_pronouns (pronoun_code),
    	-- add foreign key constraint so ethnicity links to tbl_ethnicity
	CONSTRAINT fk_client_ethnicity
	FOREIGN KEY (ethnicity)
	REFERENCES tbl_ethnicity (ethnicity_code)
    );
  
INSERT INTO tbl_clients
(first_name, last_name, address1, town, city, postcode, tel_number, email, preferred_communication, identify_as, pronouns, ethnicity, dob, date_joined)
VALUES
("Sadie", "Lock", "23 Sherlock Way", "Grove Park", "London", "SE8 4XG", "07966 135 567", "sadie@hotmail.com", "E", "F", "S", "A", "1987-03-01", "2023-01-03"),
("Jimmy", "Brown", "179 Sycamore Road", "Brockley", "London", "SE6 5NJ", "07944 344 211", "jimmyboy@gmail.com", "T", "M", "H", "O", "1994-05-23", "2023-02-03"),
("Charlotte", "Green", "34 Adelaide Avenue", "Brockley", "London", "SE6 9JJ", "07943 675 498", "cgreen@hotmail.com", "P", "F", "S", "B", "1980-10-08", "2023-03-03"),
("Alfie", "Ryan", "67 Farley Road", "Catford", "London", "SE6 5GF", "07944 327 498", "alfralf@gmail.com", "E", "M", "T", "M", "1972-07-26", "2023-01-27"),
("Roisin", "Johns", "59 Albert Road", "Crofton Park", "London", "SE7 6YY", "07967 432 190", "rosie@hotmail.com", "E", "F", "S", "W", "1989-03-17", "2023-04-03"),
("Daisy", "Duke", "21 Albacore Crescent", "Catford", "London", "SE6 5FV", "07958 789 012", "daisy@hotmail.com", "T", "F", "S", "B", "1981-06-06", "2023-05-03"),
("India", "Frost", "11 Bexhill Road", "Honor Oak", "London", "SE10 6XA", "07943 509 120", "frosty@hotmail.com", "E", "N", "T", "B", "1983-11-21", "2023-06-03"),
("Jamie", "Tundall", "100 Maclean Road", "Crofton Park", "London", "SE12 9DD", "07921 670 495", "jamie@gmail.com", "E", "M", "H", "W", "1980-09-24", "2023-07-03"),
("Mary", "Franklin", "50 Ackroyd Road", "Honor Oak", "London", "SE10 7GD", null, "franky@hotmail.com", "T", "F", "S", "W", "1981-02-28", "2023-08-03");

-- DROP TABLE tbl_clients;

-- TRUNCATE TABLE tbl_clients;

-- Updating a client record - adding a phone number where it was previously missing.
UPDATE tbl_clients
SET tel_number = "07994 561 021"
WHERE last_name = "Franklin";

-- creating an index on the client table so it is faster to search for clients by their names
CREATE INDEX idx_clients
ON tbl_clients (first_name, last_name);

CREATE TABLE IF NOT EXISTS tbl_venues (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    v_name VARCHAR(50) NOT NULL,
    contact_fname VARCHAR(50),
    contact_lname VARCHAR(50),
    address1 VARCHAR(50),
	town VARCHAR(50),
	city VARCHAR(50),
	postcode VARCHAR(8),
    tel_number VARCHAR(20),
    email VARCHAR(50)
);

INSERT INTO tbl_venues
(v_name, contact_fname, contact_lname, address1, town, city, postcode, tel_number, email)
VALUES
("Catford Wellness Rooms", "Jenny", "Black", "201 High Street", "Catford", "London", "SE6 4FF", "02083879866", "catford_wellness@gmail.com"),
("HP Therapy Rooms", "Mike", "Angel", "25 Green Street", "Shoreditch", "London", "E3 6TF", "02076553434", "hp@hp.co.uk"),
("online", NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- DROP TABLE tbl_venues;

CREATE TABLE IF NOT EXISTS tbl_schedule (
	schedule_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    -- 0 = Monday, 1 = Tuesday, 2 = Wednesday, 3 = Thursday, 4 = Friday, 5 = Saturday, 6 = Sunday
    day_of_week INT,
    -- Format: hh:mm:ss
    time_of_day TIME,
    length_of_time TIME DEFAULT "01:00:00",
    venue_id INT,
    -- make sure day has correct code (monday to friday)
    CONSTRAINT chk_day CHECK (day_of_week BETWEEN 0 AND 4),
	-- add foreign key constraint so venue id links  tbl_venues
	CONSTRAINT fk_venue_schedule
	FOREIGN KEY (venue_id)
	REFERENCES tbl_venues (id)
);

INSERT INTO tbl_schedule
(day_of_week, time_of_day, venue_id)
VALUES
(0, "11:00:00", 3),
(0, "19:00:00", 3),
(1, "11:00:00", 3),
(1, "13:00:00", 1),
(1, "14:00:00", 1),
(1, "18:00:00", 1),
(1, "19:00:00", 1),
(2, "16:00:00", 1),
(2, "17:00:00", 1),
(2, "18:00:00", 1),
(2, "19:00:00", 1),
(3, "15:00:00", 2),
(3, "16:00:00", 2),
(3, "17:00:00", 2),
(3, "18:00:00", 2),
(4, "11:30:00", 3),
(4, "17:00:00", 3);

-- Updating the schedule - change Friday session from 11.30 to 12.30
UPDATE tbl_schedule
SET time_of_day = "12:30:00"
WHERE day_of_week = 4 AND time_of_day = "11:30:00";

-- DROP TABLE tbl_schedule;

-- TRUNCATE TABLE tbl_schedule;

-- SELECT *
-- FROM tbl_schedule;

CREATE TABLE IF NOT EXISTS tbl_bookings (
	booking_id INT NOT NULL AUTO_INCREMENT,
    client_id INT NOT NULL,
    schedule_id INT NOT NULL,
    price FLOAT,
    start_date DATE DEFAULT (CURRENT_DATE),
    end_date DATE,
    -- make booking_id the primary key
	PRIMARY KEY (booking_id),
	-- Link to client table by making client_id a foreign key
	CONSTRAINT fk_client_booking
	FOREIGN KEY (client_id)
	REFERENCES tbl_clients (client_id),
	-- Link to schedule table by making schedule_id another foreign key
	CONSTRAINT fk_schedule_booking
	FOREIGN KEY (schedule_id)
	REFERENCES tbl_schedule (schedule_id)
);

INSERT INTO tbl_bookings
(client_id, schedule_id, price, start_date, end_date)
VALUES
(2, 5, 65.00, "2023-03-03", NULL),
(3, 17, 75.00, "2023-01-28", "2023-05-30"),
(1, 14, 65.00, "2023-05-23", NULL),
(7, 7, 65.00, "2023-06-18", NULL),
(9, 12, 75.00, "2023-07-05", "2023-11-04"),
(8, 1, 65.00, "2023-04-21", NULL),
(4, 10, 75.00, "2023-06-23", NULL),
(6, 15, 65.00, "2023-09-29", "2024-05-23"),
(5, 11, 85.00, "2023-10-23", NULL);

-- SELECT *
-- FROM tbl_bookings;

-- DROP TABLE tbl_bookings;

-- TRUNCATE tbl_bookings;

-- ALTER TABLE tbl_bookings
-- DROP COLUMN is_expired;

-- added an end date in the past to test my event to archive old bookings
UPDATE tbl_bookings
SET end_date = "2023-10-23"
WHERE booking_id = 1;

-- Added another column to identify bookings that have expired. See event which checks and updates this column.
ALTER TABLE tbl_bookings
ADD expired BOOLEAN DEFAULT FALSE;

CREATE TABLE tbl_sessions (
	session_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    client_id INT NOT NULL,
    notes MEDIUMTEXT,
	-- create a composite key from session date and client id
	PRIMARY KEY (session_date, client_id),
	-- make client_id a foreign key linked to clients table
    CONSTRAINT fk_client_session
    FOREIGN KEY (client_id)
    REFERENCES tbl_clients (client_id)
);

INSERT INTO tbl_sessions
VALUES
("2024-01-05", 5, "Congue eu consequat ac felis donec et odio pellentesque. Viverra nam libero justo laoreet sit. Aenean vel elit scelerisque mauris pellentesque pulvinar pellentesque. Nullam non nisi est sit amet facilisis magna. Pellentesque habitant morbi tristique senectus et netus. Sed egestas egestas fringilla phasellus faucibus scelerisque eleifend donec pretium. Tempus quam pellentesque nec nam aliquam."),
("2024-01-08", 2, "Cras fermentum odio eu feugiat pretium nibh ipsum consequat. Adipiscing vitae proin sagittis nisl rhoncus mattis rhoncus urna. Netus et malesuada fames ac turpis egestas integer. Ipsum consequat nisl vel pretium."),
("2024-01-09", 3, "Vitae suscipit tellus mauris a diam maecenas sed. Luctus accumsan tortor posuere ac."),
("2024-01-09", 1, "Faucibus purus in massa tempor nec feugiat nisl pretium. At imperdiet dui accumsan sit."),
("2024-01-10", 7, "In dictum non consectetur a erat nam at lectus urna. Eu augue ut lectus arcu bibendum at. "),
("2024-01-10", 9, "Gravida cum sociis natoque penatibus et magnis dis parturient montes. Adipiscing elit pellentesque habitant morbi tristique senectus et netus. "),
("2024-01-11", 5, "Consequat semper viverra nam libero justo laoreet sit amet cursus."),
("2024-01-11", 4, "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Amet venenatis urna cursus eget nunc."),
("2024-01-12", 5, "Aliquam id diam maecenas ultricies mi eget mauris pharetra.");


-- if clients need to cancel or change a booking time/date it gets logged in this table
-- i did not get time to continue with this table
-- CREATE TABLE IF NOT EXISTS tbl_edited_bookings (
-- 	booking_id INT NOT NULL,
--     booking_date DATE NOT NULL,
--     is_cancelled BOOLEAN,
--     new_date DATE,
--     new_time TIME
-- );
