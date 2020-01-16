/*
xml_input =
<data type="users">
    <data-info>
        <count-data>2</count-data>
        <registry>feb-19</registry>
    </data-info>
    <rows>
        <row>
            <param name="NAME">Name1</param>
            <param name="SURNAME">Surname1</param>
            <param name="BIRTHDAY">01.01.1980</param>
            <additional-info-list>
                <additional-info>info_1</additional-info>
                <additional-info>info_2</additional-info>
                <additional-info>info_3</additional-info>
            </additional-info-list>
        </row>
        <row>
            <param name="NAME">Name2</param>
            <param name="SURNAME">Surname2</param>
            <param name="BIRTHDAY">01.01.1990</param>
            <additional-info-list>
                <additional-info>info_4</additional-info>
            </additional-info-list>
        </row>
    </rows>
</data>
*/

SELECT
      extractValue(value(t),'//param[@name="NAME"]/text()')           AS name
    , extractValue(value(t),'//param[@name="SURNAME"]/text()')        AS surname
    , extractValue(value(t),'//param[@name="BIRTHDAY"]/text()')       AS birthday
    , extractValue(value(t),'//additional-info[position()=1]/text()') AS additional_info_1
    , extractValue(value(t),'//additional-info[position()=2]/text()') AS additional_info_2
    , extractValue(value(t),'//additional-info[3]/text()')            AS additional_info_3
    , extractValue(value(t),'//additional-info[4]/text()')            AS additional_info_4
FROM
    TABLE(
        XMLSequence(
            EXTRACT(
                  XMLType(:xml_input)
                , '//row'
            )
        )
    ) t
;

SELECT
    *
FROM
    XMLTABLE('/data/rows/row' PASSING XmlType(:xml_input) COLUMNS
          name              VARCHAR2(20) PATH './param[@name="NAME"]'
        , surname           VARCHAR2(20) PATH './param[@name="SURNAME"]'
        , birthday          VARCHAR2(20) PATH './param[@name="BIRTHDAY"]'
        , additional_info_1 VARCHAR2(20) PATH './additional-info-list/additional-info[position()=1]'
        , additional_info_2 VARCHAR2(20) PATH './additional-info-list/additional-info[position()=2]'
        , additional_info_3 VARCHAR2(20) PATH './additional-info-list/additional-info[3]'
        , additional_info_4 VARCHAR2(20) PATH './additional-info-list/additional-info[4]'
     ) xmlt
; 

/*
Output (for both queries):
-----------------------------------------------------------------------------------------------------------------
| NAME  | SURNAME  |  BIRTHDAY  | ADDITIONAL_INFO_1 | ADDITIONAL_INFO_2 | ADDITIONAL_INFO_3 | ADDITIONAL_INFO_4 |
=================================================================================================================
| Name1 | Surname1 | 01.01.1980 |       info_1      |       info_2      |       info_3      |      (null)       |
-----------------------------------------------------------------------------------------------------------------
| Name2 | Surname2 | 01.01.1990 |       info_4      |       (null)      |       (null)      |      (null)       |
-----------------------------------------------------------------------------------------------------------------
*/
