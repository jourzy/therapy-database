USE db_therapy;

-- display the expenses for a given time period
SELECT e.expense_date AS "Date", ei.item_description AS "Item", ei.cost AS "Cost", ei.tax_relief_code AS "Tax code"
FROM tbl_expenses AS e
INNER JOIN tbl_expense_items AS ei ON ei.expense_item_id = e.expense_item
WHERE e.expense_date BETWEEN "2024-01-05" AND "2024-01-12"
ORDER BY e.expense_date;

-- find the total expenditure for a given time period
SELECT SUM(ei.cost) AS "Total expenditure"
FROM tbl_expense_items AS ei
INNER JOIN tbl_expenses AS e ON ei.expense_item_id = e.expense_item
WHERE e.expense_date BETWEEN "2024-01-05" AND "2024-01-12";

-- How many expense items have been processed under tax relief room rental 
SELECT COUNT(e.expense_id) AS "Number of room rentals"
FROM tbl_expenses AS e
INNER JOIN tbl_expense_items AS ei ON ei.expense_item_id = e.expense_item
WHERE ei.tax_relief_code = "REN";

-- View breakdown of expenses by tax relief description
SELECT CONCAT("£",SUM(ei.cost)) AS "Total spend", t.relief_description AS "Tax relief description"
FROM tbl_expense_items AS ei
INNER JOIN tbl_expenses AS e ON ei.expense_item_id = e.expense_item
INNER JOIN tbl_tax_relief AS t ON ei.tax_relief_code = t.relief_code
GROUP BY t.relief_description
ORDER BY "Total spend";


-- View breakdown of expenses by tax relief description that are over £100
SELECT SUM(ei.cost) AS "Total spend", t.relief_description AS "Tax relief description"
FROM tbl_expense_items AS ei
INNER JOIN tbl_expenses AS e ON ei.expense_item_id = e.expense_item
INNER JOIN tbl_tax_relief AS t ON ei.tax_relief_code = t.relief_code
GROUP BY t.relief_description
HAVING SUM(ei.cost) > 100
ORDER BY SUM(ei.cost) DESC;

  
-- this code helped me in my troubleshooting to get the function to work!
-- https://database.guide/6-ways-to-fix-error-1055-expression-of-select-list-is-not-in-group-by-clause-and-contains-nonaggregated-column-in-mysql/
-- 	SET @@sql_mode = SYS.LIST_DROP(@@sql_mode, 'ONLY_FULL_GROUP_BY');
    
-- a stored procedure to work out % spend on each tax group 
-- Change Delimiter
DELIMITER //
-- Create Stored Procedure
CREATE PROCEDURE spend_by_tax_group()
BEGIN
	DECLARE total_spend INT;
    SET total_spend = (SELECT SUM(ei.cost) FROM tbl_expense_items AS ei RIGHT JOIN tbl_expenses AS e ON ei.expense_item_id = e.expense_item);
	SELECT t.relief_description AS "Tax relief description", CONCAT(ROUND((SUM(ei.cost)/total_spend * 100 ),0),'%') AS Percentage
	FROM tbl_expense_items AS ei
	INNER JOIN tbl_expenses AS e ON ei.expense_item_id = e.expense_item
	INNER JOIN tbl_tax_relief AS t ON ei.tax_relief_code = t.relief_code
    -- previously had to remove group by clause as getting error code 1055. The sql_mode update helped me to fix.
	GROUP BY t.relief_description;
END//
-- Change Delimiter again
DELIMITER ;

-- DROP PROCEDURE spend_by_tax_group;

-- Call Stored Procedure
CALL spend_by_tax_group();
