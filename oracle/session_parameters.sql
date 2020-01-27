-- check parameter value

show parameter result_cache_mode;

select * from v$parameter where name = 'result_cache_mode';

select * from nls_session_parameters where parameter = 'NLS_SORT';

-- set parameter value

alter session set result_cache_mode = 'FORCE';
alter session set result_cache_mode = 'MANUAL';

alter session set NLS_SORT = 'BINARY';
alter session set NLS_SORT = 'RUSSIAN';
