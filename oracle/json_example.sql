/*
json_input = {
    "params": [
        {
            "param1": "value1",
            "param2": "value1"
        },
        {
            "param1": "value3",
            "param2": "value4"
        }
    ]
}
JSON object with attribute "params", which is an array of objects with attributes "param1" and "param2".
*/

SELECT
    *
FROM
    JSON_TABLE(
          :json_input
        , '$.params[*]' COLUMNS(
                param1 VARCHAR2(100) PATH '$.param1'
              , param2 VARCHAR2(100) PATH '$.param2'
          )
    )
;

/*
Output:
-------------------
| PARAM1 | PARAM2 |
===================
| value1 | value2 |
-------------------
| value3 | value4 |
-------------------
*/
