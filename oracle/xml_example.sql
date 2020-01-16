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

--------------------------------------------------------------------------------

/*
xml_input =
<course>
    <id>346283</id>
    <name>course1</name>
    <terms>
        <term>
            <num>1</num>
            <books>
                <book>
                    <name>book1</name>
                    <authors>
                        <author>author1</author>
                    </authors>
                </book>
                <book>
                    <name>book2</name>
                    <authors>
                        <author>author2</author>
                        <author>author3</author>
                        <author>author4</author>
                    </authors>
                </book>
            </books>
        </term>
        <term>
            <num>2</num>
            <books>
                <book>
                    <name>book3</name>
                    <authors>
                        <author>author3</author>
                    </authors>
                </book>
                <book>
                    <name>book4</name>
                    <authors>
                        <author>author2</author>
                        <author>author5</author>
                    </authors>
                </book>
                <book>
                    <name>book5</name>
                    <authors>
                        <author>author1</author>
                        <author>author5</author>
                    </authors>
                </book>
            </books>
        </term>
        <term>
            <num>3</num>
        </term>
    </terms>
</course>
*/

SELECT
      extractValue(course.xml, 'course/id')  AS course_id
    , extractValue(value(term), 'term/num')  AS term_num
    , extractValue(value(book), 'book/name') AS book_name
    , extractValue(value(author), 'author')  AS author
FROM
      (
        SELECT
            XMLTYPE(:xml_input) AS xml
        FROM
            dual
      )                                                              course
    , TABLE(XMLSequence(course.xml.extract('course/terms/term')))    term
    , TABLE(XMLSequence(value(term).extract('term/books/book')))     book
    , TABLE(XMLSequence(value(book).extract('book/authors/author'))) author
;

SELECT
      course.course_id
    , term.term_num
    , book.book_name
    , author.author
FROM
      (
        SELECT
            XMLTYPE(:xml_input) AS xml
        FROM
            dual
      )                                                          base
    , XMLTABLE('course' PASSING (base.xml) COLUMNS
          course_id NUMBER  PATH 'id'
        , terms     XMLTYPE PATH 'terms/term'
      )                                                          course
    , XMLTABLE('term' PASSING (course.terms) COLUMNS
          term_num NUMBER  PATH 'num'
        , books    XMLTYPE PATH 'books/book'
      )                                                          term
    , XMLTABLE('book' PASSING (TERM.books) COLUMNS
          book_name VARCHAR2(4000 BYTE) PATH 'name'
        , authors   XMLTYPE             PATH 'authors/author'
      )                                                          book
    , XMLTABLE('author' PASSING (book.authors) COLUMNS
          author VARCHAR2(4000 BYTE) PATH 'text()'
      )                                                          author
;

/*
Output (for both queries):
-------------------------------------------------
| COURSE_ID | TERM_NUM  |  BOOK_NAME  | AUTHOR  |
=================================================
|  346283   |     1     |    book1    | author1 |
-------------------------------------------------
|  346283   |     1     |    book2    | author2 |
-------------------------------------------------
|  346283   |     1     |    book2    | author3 |
-------------------------------------------------
|  346283   |     1     |    book2    | author4 |
-------------------------------------------------
|  346283   |     2     |    book3    | author3 |
-------------------------------------------------
|  346283   |     2     |    book4    | author2 |
-------------------------------------------------
|  346283   |     2     |    book4    | author5 |
-------------------------------------------------
|  346283   |     2     |    book5    | author1 |
-------------------------------------------------
|  346283   |     2     |    book5    | author5 |
-------------------------------------------------
*/

SELECT
      extractValue(course.xml, 'course/id')  AS course_id
    , extractValue(value(term), 'term/num')  AS term_num
    , extractValue(value(book), 'book/name') AS book_name
    , extractValue(value(author), 'author')  AS author
FROM
      (
        SELECT
            XMLTYPE(:xml_input) AS xml
        FROM
            dual
      )                                                                 course
    , TABLE(XMLSequence(course.xml.extract('course/terms/term')))       term
    , TABLE(XMLSequence(value(term).extract('term/books/book')))(+)     book
    , TABLE(XMLSequence(value(book).extract('book/authors/author')))(+) author
;

SELECT
      course.course_id
    , term.term_num
    , book.book_name
    , author.author
FROM
      (
        SELECT
            XMLTYPE(:xml_input) AS xml
        FROM
            dual
      )                                                          base
    , XMLTABLE('course' PASSING (base.xml) COLUMNS
          course_id NUMBER  PATH 'id'
        , terms     XMLTYPE PATH 'terms/term'
      )                                                          course
    , XMLTABLE('term' PASSING (course.terms) COLUMNS
          term_num NUMBER  PATH 'num'
        , books    XMLTYPE PATH 'books/book'
      )(+)                                                       term
    , XMLTABLE('book' PASSING (TERM.books) COLUMNS
          book_name VARCHAR2(4000 BYTE) PATH 'name'
        , authors   XMLTYPE             PATH 'authors/author'
      )(+)                                                       book
    , XMLTABLE('author' PASSING (book.authors) COLUMNS
          author VARCHAR2(4000 BYTE) PATH 'text()'
      )(+)                                                       author
;

/*
Output (for both queries):
-------------------------------------------------
| COURSE_ID | TERM_NUM  |  BOOK_NAME  | AUTHOR  |
=================================================
|  346283   |     1     |    book1    | author1 |
-------------------------------------------------
|  346283   |     1     |    book2    | author2 |
-------------------------------------------------
|  346283   |     1     |    book2    | author3 |
-------------------------------------------------
|  346283   |     1     |    book2    | author4 |
-------------------------------------------------
|  346283   |     2     |    book3    | author3 |
-------------------------------------------------
|  346283   |     2     |    book4    | author2 |
-------------------------------------------------
|  346283   |     2     |    book4    | author5 |
-------------------------------------------------
|  346283   |     2     |    book5    | author1 |
-------------------------------------------------
|  346283   |     2     |    book5    | author5 |
-------------------------------------------------
|  346283   |     3     |    (null)   | (null)  |
-------------------------------------------------
*/

