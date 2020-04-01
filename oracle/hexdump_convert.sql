select
    to_timestamp(
             to_char(to_number(substr(p_str, 1,  2 ), 'xx' ) - 100, 'fm00')
          || to_char(to_number(substr(p_str, 3,  2 ), 'xx' ) - 100, 'fm00')
          || to_char(to_number(substr(p_str, 5,  2 ), 'xx' ),       'fm00')
          || to_char(to_number(substr(p_str, 7,  2 ), 'xx' ),       'fm00')
          || to_char(to_number(substr(p_str, 9,  2 ), 'xx' ) - 1,   'fm00')
          || to_char(to_number(substr(p_str, 11, 2 ), 'xx' ) - 1,   'fm00')
          || to_char(to_number(substr(p_str, 13, 2 ), 'xx' ) - 1,   'fm00')
        , 'yyyymmddhh24miss'
    ) as ts
from
    (
        select :hexdump as p_str from dual
    )
;

/*
Input: 78780401093A19
Output: 01.04.2020 08:57:24

https://ardentperf.com/2013/11/19/convert-rawhex-to-timestamp/
*/
