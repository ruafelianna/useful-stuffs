/*
Fetches all the rows in the query; counts rows and the time of fetch
*/

declare

    v_count      number    := 0;
    v_start_time timestamp := systimestamp;

    cursor get_data
    is
    -- paste your query here
    select
        *
    from
        dual
    ;

begin

    for rw in get_data loop
        v_count := v_count + 1;
    end loop;

    dbms_output.put_line(
        'Fetched '
         || v_count
         || ' line(s) during '
         || extract(day from (systimestamp - v_start_time) * 86400)
         || ' second(s)'
    );

end;
