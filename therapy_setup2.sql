USE db_therapy;

CREATE TABLE IF NOT EXISTS tbl_tax_relief (
	relief_code CHAR(3) NOT NULL PRIMARY KEY,
    relief_description VARCHAR(100) NOT NULL
);

INSERT INTO tbl_tax_relief
VALUES
("INS", "Insurance"),
("MEM", "Professional Membership/registration fees"),
("ACC", "Accountancy fees"),
("SUB", "Subscriptions / work journals"),
("REN", "Room rental – for therapy and for our group meeting"),
("ADV", "Advertising – directories, magazine ads, business cards, flyers"),
("WEB", "Website hosting and design costs"),
("SUP", "Supervision"),
("BKS", "Therapy Books and other resources/ Computer apps, downloads, DVDs, CDs"),
("PER", "Personal therapy"),
("CPD", "Conferences and CPD training – including travel, accommodation and subsistence");

-- DROP TABLE tbl_tax_relief;

CREATE TABLE IF NOT EXISTS tbl_expense_items (
	expense_item_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    item_description VARCHAR(50) NOT NULL,
    cost FLOAT,
    tax_relief_code CHAR(3),
    -- make tax relief code a foreign key
    CONSTRAINT fk_tax_code 
    FOREIGN KEY (tax_relief_code)
    REFERENCES tbl_tax_relief (relief_code)
);

INSERT INTO tbl_expense_items
(item_description, cost, tax_relief_code)
VALUES
("Catford Wellness Rooms", 13.50, "REN"),
("HP Therapy Rooms", 137.00, "REN"),
("Supervision - Wendy", 150.00, "SUP"),
("HP referral", 20.00, "ADV"),
("Books", 55.00, "BKS"),
("BACP Membership", 178.00, "MEM"),
("BACP listings", 76.00, "ADV"),
("Personal therapy", 50.00, "PER");

-- DROP TABLE tbl_expense_items;

CREATE TABLE IF NOT EXISTS tbl_expenses (
	expense_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    expense_date DATE DEFAULT (CURRENT_DATE) NOT NULL,
    expense_item INT NOT NULL,
        -- make expense_item a foreign key
    CONSTRAINT fk_expense_item
    FOREIGN KEY (expense_item)
    REFERENCES tbl_expense_items (expense_item_id)
);


INSERT INTO tbl_expenses
(expense_date, expense_item)
VALUES
("2024-01-05", 1),
("2024-01-05", 1),
("2024-01-05", 1),
("2024-01-06", 2),
("2024-01-07", 3),
("2024-01-10", 4),
("2024-01-11", 1),
("2024-01-11", 1),
("2024-01-12", 8),
("2024-01-13", 7),
("2024-01-23", 5),
("2024-01-24", 1),
("2024-01-24", 1),
("2024-01-25", 3),
("2024-01-26", 4),
("2024-01-27", 1),
("2024-01-27", 1),
("2024-01-27", 2);

CREATE TABLE tbl_income (
    income_date DATE DEFAULT (CURRENT_DATE) NOT NULL,
    income_item INT NOT NULL,
    -- create a composite key from income date and income item
	PRIMARY KEY (income_date, income_item),
        -- make income_item a foreign key linked to bookings table
    CONSTRAINT fk_income_item
    FOREIGN KEY (income_item)
    REFERENCES tbl_bookings (booking_id)
);

-- DROP TABLE tbl_income;

INSERT INTO tbl_income
(income_date, income_item)
VALUES
("2024-01-05", 9),
("2024-01-08", 1),
("2024-01-09", 2),
("2024-01-09", 3),
("2024-01-10", 4),
("2024-01-10", 5),
("2024-01-11", 6),
("2024-01-11", 7),
("2024-01-11", 8),
("2024-01-12", 9),
("2024-01-15", 1),
("2024-01-16", 2),
("2024-01-16", 3),
("2024-01-17", 4),
("2024-01-17", 5),
("2024-01-18", 6),
("2024-01-18", 7),
("2024-01-18", 8),
("2024-01-19", 9),
("2024-01-22", 1),
("2024-01-23", 2),
("2024-01-23", 3),
("2024-01-24", 4),
("2024-01-24", 5),
("2024-01-25", 6),
("2024-01-25", 7),
("2024-01-26", 8),
("2024-01-27", 9);

