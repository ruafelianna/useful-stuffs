/*
https://docs.oracle.com/cd/B14117_01/server.101/b10759/queries003.htm
*/

-- Hierarchical query for employees table, where each employee has a manager.
--
-- We start with the employee who doesn't have a manager.
-- Then we connect our current record with the previous one
-- so the previous (prior, parent) employee ID is our current manager FID.

SELECT
	  id_employee
	, last_name
	, fid_manager
	, LEVEL
	, LPAD(' ', 3 * (LEVEL - 1) || last_name AS tree
FROM
	employees
START WITH
	manager_id IS NULL
CONNECT BY
	PRIOR id_employee = fid_manager
--ORDER SIBLINGS BY
--	last_name
;