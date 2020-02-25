/*
https://docs.oracle.com/cd/B28359_01/appdev.111/b28424/adfns_flashback.htm
https://docs.oracle.com/cd/B13789_01/appdev.101/b10795/adfns_fl.htm
*/

SELECT
	*
FROM
	my_table AS OF TIMESTAMP (SYSTIMESTAMP - INTERVAL '10' MINUTE)
;
----------------------------------------------------------------------------
SELECT
	  versions_starttime
	, versions_endtime
	, versions_operation
	, tbl.*
FROM
	my_table
	VERSIONS BETWEEN
		TIMESTAMP TO_TIMESTAMP(:dateStart, 'dd.mm.yyyy hh24:mi:ss')
		AND TO_TIMESTAMP(:dateEnd, 'dd.mm.yyyy hh24:mi:ss')
	tbl
;
