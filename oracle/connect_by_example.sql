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
	, LEVEL -- hierarchy level
	, LPAD(' ', 3 * (LEVEL - 1)) || last_name AS tree -- hierarchial (tree) view
	, SYS_CONNECT_BY_PATH(last_name, '/') AS path  -- path from the root level to the current one
	, CONNECT_BY_ROOT last_name AS boss -- get parent info
	--, CONNECT_BY_ISCYCLE -- whether the row contains a loop. It can be used only with NOCYCLE
FROM
	employees
START WITH
	manager_id IS NULL -- a root row for the hierarchy
CONNECT BY -- NOCYCLE -- if we have a loop in the data
	PRIOR id_employee = fid_manager
--ORDER SIBLINGS BY
--	last_name
;
