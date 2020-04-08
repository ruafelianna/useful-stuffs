/*
Granting all priviledges on every scheme object of some type to the user.
Original query: https://stackoverflow.com/a/27353867/12227681
*/

begin
    for objects in (
        select
              'GRANT ALL ON "'
            || object_name
            || '" TO :my_scheme' as grantsql
        from
            user_objects
        where
            object_type in (
                  'TABLE'
                , 'SEQUENCE'
                --, 'ANY_OTHER_OBJECT_TYPE_YOU_NEED'
            )
        order by
              object_type
            , object_name
    ) loop
        begin
            -- dbms_output.put_line(objects.grantsql);
            execute immediate objects.grantsql using :my_scheme;
        exception
            when others then
                --Ignore ORA-04063: view "X.Y" has errors.
                --(You could potentially workaround this by creating an empty view,
                -- granting access to it, and then recreat the original view.) 
                if sqlcode in (-4063) then
                    null;
                --Raise exception along with the statement that failed.
                else
                    raise_application_error (
                          -20000
                        , 'Problem with this statement: '
                          || objects.grantsql
                          || chr (10)
                          || sqlerrm
                    );
                end if;
        end;
    end loop;
end;
