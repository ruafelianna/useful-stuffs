/*
Advanced TRIM
*/
SELECT
    REGEXP_REPLACE(
          REGEXP_REPLACE(
              :input
            , '^(\s|'||CHR(49824)||'|'||CHR(14844320)||')+'
          )
        , '(\s|'||CHR(49824)||'|'||CHR(14844320)||')+$'
    ) AS output
FROM dual;

/*
Split input by delimiters and get the n-th group contents

Example:
input: 192.168.0.1
delimiter: \. (dot is a special character so we are escaping it)
group_num: 2
output: 168
*/
SELECT
    REGEXP_SUBSTR(
          :input
        , '(.+)'||:delimiter||'(.+)'||:delimiter||'(.+)'||:delimiter||'(.+)'
        , 1
        , 1
        , ''
        , :group_num
    ) AS output
FROM dual;
