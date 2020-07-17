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
                           
select
    tablespace_name,
    to_char(sum(bytes)) bytes,
    to_char(trunc(sum(bytes) / 1024, 1)) KB,
    to_char(trunc(sum(bytes) / 1048576, 1)) MB,
    sum(blocks) blocks
from
    dba_free_space
where
    tablespace_name like :tablespace_name
group by
    tablespace_name
order by
    tablespace_name
;

select
    tablespace_name as "tablespace_name",
    sum(size_mb) as "total, MB",
    sum(free_mb) as "free, MB",
    round((sum(size_mb) - sum(free_mb)) * 100 / sum(size_mb), 2) as "used, %"
from
    (
        select
            f.tablespace_name,
            round(max(f.bytes) / 1024 / 1024, 2) as size_mb,
            round(sum(nvl(fs.bytes, 0)) / 1024 / 1024, 2) as free_mb
        from
            dba_data_files   f,
            dba_free_space   fs
        where
            f.tablespace_name = fs.tablespace_name
            and f.file_id = fs.file_id
        group by
            f.tablespace_name,
            f.file_id
    )
group by
    tablespace_name
order by
    "used, %" desc
;
