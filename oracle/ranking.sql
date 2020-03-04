/*
Example of advanced ranking using window functions
*/

with
sq_data as (
    select to_timestamp('01.02.2020', 'dd.mm.yyyy') as started_at, 'state_1' as state, 1 as unique_id from dual
    union all
    select to_timestamp('01.02.2020', 'dd.mm.yyyy') as started_at, 'state_1' as state, 2 as unique_id from dual
    union all
    select to_timestamp('01.02.2020', 'dd.mm.yyyy') as started_at, 'state_2' as state, 3 as unique_id from dual
    union all
    select to_timestamp('04.02.2020', 'dd.mm.yyyy') as started_at, 'state_1' as state, 4 as unique_id from dual
    union all
    select to_timestamp('05.02.2020', 'dd.mm.yyyy') as started_at, 'state_3' as state, 5 as unique_id from dual
    union all
    select to_timestamp('06.02.2020', 'dd.mm.yyyy') as started_at, 'state_3' as state, 6 as unique_id from dual
    union all
    select to_timestamp('07.02.2020', 'dd.mm.yyyy') as started_at, 'state_3' as state, 7 as unique_id from dual
    union all
    select to_timestamp('08.02.2020', 'dd.mm.yyyy') as started_at, 'state_2' as state, 8 as unique_id from dual
    union all
    select to_timestamp('09.02.2020', 'dd.mm.yyyy') as started_at, 'state_2' as state, 9 as unique_id from dual
)
, sq_1 as (
    select
          started_at
        , unique_id
        , state
        , lag(state) over (order by started_at, unique_id) as prev_state
        , row_number() over (order by started_at, unique_id) as rn
        , row_number() over (partition by state order by started_at, unique_id) as rn_state
    from
        sq_data
)
, sq_2 as (
    select
          started_at
        , state
        , unique_id
        , rn
        , rn_state
        , row_number() over (partition by state, rn - rn_state order by started_at, unique_id) as rn_state_group_asc
        , row_number() over (partition by state, rn - rn_state order by started_at desc, unique_id desc) as rn_state_group_desc
        , sum(case when state = prev_state then 0 else 1 end)
            over (order by started_at, unique_id rows between unbounded preceding and current row) as drn
    from
        sq_1
)
select * from sq_2;

/*
Result:
-------------------------------------------------------------------------------------------------------------
|      STARTED_AT     | STATE  | UNIQUE_ID | RN | RN_STATE | RN_STATE_GROUP_ASC | RN_STATE_GROUP_DESC | DRN |
-------------------------------------------------------------------------------------------------------------
| 01.02.2020 00:00:00 | state1 |     1     |  1 |     1    |          1         |          2          |  1  |
| 01.02.2020 00:00:00 | state1 |     2     |  2 |     2    |          2         |          1          |  1  |
| 01.02.2020 00:00:00 | state2 |     3     |  3 |     1    |          1         |          1          |  2  |
| 04.02.2020 00:00:00 | state1 |     4     |  4 |     3    |          1         |          1          |  3  |
| 05.02.2020 00:00:00 | state3 |     5     |  5 |     1    |          1         |          3          |  4  |
| 06.02.2020 00:00:00 | state3 |     6     |  6 |     2    |          2         |          2          |  4  |
| 07.02.2020 00:00:00 | state3 |     7     |  7 |     3    |          3         |          1          |  4  |
| 08.02.2020 00:00:00 | state2 |     8     |  8 |     2    |          1         |          2          |  5  |
| 09.02.2020 00:00:00 | state2 |     9     |  9 |     3    |          2         |          1          |  5  |
-------------------------------------------------------------------------------------------------------------

RN - ranking states over time
RN_STATE - number of the state among all such states ordered by time
RN_STATE_GROUP_ASC, RN_STATE_GROUP_DESC - number of the state among all such states but only of they go successively, ordered by time
DRN - ranking the states over time giving the same number to the row if the previous state is the same

P.S. UNIQUE_ID is used with STARTED_AT in order by clause to make the solution the same for the equal values of STARTED_AT
P.P.S. RN_STATE_GROUP_ASC and RN_STATE_GROUP_DESC can be used for instance if you want to get the first or the last value
       over the group of equal states which go one after another over time
*/
