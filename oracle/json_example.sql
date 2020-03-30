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

--------------------------------------------------------------------------------

/*
json_input = [
    {
        "component": {
            "id": "1",
            "text": "abc"
        },
        "related_components": [
            {
                "id": "3",
                "text": "ghi"
            },
            {
                "id": "4",
                "text": "jkl"
            }
        ]
    },
    {
        "component": {
            "id": "2",
            "text": "def"
        },
        "related_components": [
            {
                "id": "5",
                "text": "mno"
            }
        ]
    }
]
JSON array of objects with attributes "component" and "related_components".
"component" is an object with attributes "id" and "text".
"related_components" is and array of objects with attributes "id" and "text".
*/

SELECT
    js.*
FROM
    JSON_TABLE (
        :json_input, '$[*]' COLUMNS (
            NESTED PATH '$.component' COLUMNS (
                component_id   NUMBER          PATH '$.id',
                component_text VARCHAR2 (4000) PATH '$.text'
            )
        )
    ) js
;

/*
Output:
---------------------------------
| COMPONENT_ID | COMPONENT_TEXT |
=================================
|       1      |       abc      |
---------------------------------
|       2      |       def      |
---------------------------------
*/

SELECT
    js.*
FROM
    JSON_TABLE (
        :json_input, '$[*]' COLUMNS (
            NESTED PATH '$.related_components[*]' COLUMNS (
                component_id   NUMBER          PATH '$.id',
                component_text VARCHAR2 (4000) PATH '$.text'
            )
        )
    ) js
;

/*
Output:
---------------------------------
| COMPONENT_ID | COMPONENT_TEXT |
=================================
|       3      |       ghi      |
---------------------------------
|       4      |       jkl      |
---------------------------------
|       5      |       mno      |
---------------------------------
*/

--------------------------------------------------------------------------------

/* Creating JSON object */

with
sq as (
    select 'apple' as fruit, 12 as cnt from dual
    union all
    select 'orange' as fruit, 15 as cnt from dual
    union all
    select 'banana' as fruit, 8 as cnt from dual
)
select
    json_object(
          'fruit_name' value fruit
        , 'fruit_count' value cnt
    ) as js
from
    sq
;

/*
Output:
--------------------------------------------
|                    JS                    |
============================================
| {"fruit_name":"apple","fruit_count":12}  |
--------------------------------------------
| {"fruit_name":"orange","fruit_count":15} |
--------------------------------------------
| {"fruit_name":"banana","fruit_count":8}  |
--------------------------------------------
*/
