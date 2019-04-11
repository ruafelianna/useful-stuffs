/*
https://docs.oracle.com/cd/B28359_01/server.111/b28318/dependencies.htm

From Oracle docs:

DBA_DEPENDENCIES
	describes all dependencies in the database between procedures, packages, functions, package bodies, and triggers, including dependencies on views created without any database links.
	Its columns are the same as those in "ALL_DEPENDENCIES".
ALL_DEPENDENCIES
	describes dependencies between procedures, packages, functions, package bodies, and triggers accessible to the current user, including dependencies on views created without any database links.
	This view does not display the SCHEMAID column.
USER_DEPENDENCIES
	describes dependencies between procedures, packages, functions, package bodies, and triggers owned by the current user, including dependencies on views created without any database links.
	Its columns are the same as those in "ALL_DEPENDENCIES".
*/

-- Query to find dependent objects for the given one

SELECT
	  name
    , type
    , referenced_name
    , referenced_type
FROM
	dba_dependencies
WHERE
	referenced_name = :object_name
    AND referenced_owner = :owner
;

SELECT
	  name
    , type
    , referenced_name
    , referenced_type
FROM
	all_dependencies
WHERE
	referenced_name = :object_name
    AND referenced_owner = :owner
;

SELECT
	  name
    , type
    , referenced_name
    , referenced_type
FROM
	user_dependencies
WHERE
	referenced_name = :object_name
    AND referenced_owner = :owner
;
