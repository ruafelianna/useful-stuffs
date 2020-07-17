select
    ds.tablespace_name,
    ds.segment_name,
    round(sum(ds.bytes) /(1024 * 1024)) as mb
from
    dba_segments ds
where
    ds.segment_name = :segment_name
group by
    ds.tablespace_name,
    ds.segment_name
;

select
    dbs.tablespace_name,
    dbo.owner,
    dbo.object_name,
    round(sum(dbs.bytes) /(1024 * 1024)) as mb
from
    dba_objects    dbo
    left join dba_segments   dbs
        on dbo.object_name = dbs.segment_name
where
    (
        :object_type is null
        or dbo.object_type = :object_type
    )
    and (
        :owner is null
        or dbo.owner = :owner
    )
    and (
        :tablespace_name is null
        or dbs.tablespace_name = :tablespace_name
    )
    and (
        :object_name is null
        or dbo.object_name = :object_name
    )
group by
    dbs.tablespace_name,
    dbo.owner,
    dbo.object_name
order by
    dbs.tablespace_name,
    dbo.owner,
    dbo.object_name
--    mb desc
;
