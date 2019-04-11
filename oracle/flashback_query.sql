/*
https://docs.oracle.com/cd/B28359_01/appdev.111/b28424/adfns_flashback.htm
*/

SELECT
	*
FROM
	my_table AS OF TIMESTAMP (SYSTIMESTAMP - INTERVAL '10' MINUTE)
;