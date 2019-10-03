/*
https://docs.oracle.com/database/121/ARPLS/d_redefi.htm#ARPLS042
*/

declare
    --- input
    username              VARCHAR2(4000) DEFAULT NULL;                               -- scheme/user name
    old_table             VARCHAR2(4000) DEFAULT NULL;                               -- original table
    new_table             VARCHAR2(4000) DEFAULT NULL;                               -- interim table(s) (comma-separated)
    partition_name        VARCHAR2(4000) DEFAULT NULL;                               -- partition(s) name(s) (comma-separated)
    redef_options         BINARY_INTEGER DEFAULT dbms_redefinition.cons_use_pk;      -- redefinition options: cons_use_pk/cons_use_rowid
    col_mapping           VARCHAR2(4000) DEFAULT NULL;                               -- select-like list of columns (mapping info from original to interim table)
    orderby_cols          VARCHAR2(4000) DEFAULT NULL;                               -- order by clause for initial instantiation of the interim table
    continue_after_errors BOOLEAN        DEFAULT FALSE;                              -- whether to continue to the next partition if one fininshed with error
    copy_vpd_opt          BINARY_INTEGER DEFAULT dbms_redefinition.cons_vpd_none;    -- vdp policies: cons_vpd_none/cons_vpd_auto/cons_vpd_manual
    copy_indexes          PLS_INTEGER    DEFAULT dbms_redefinition.cons_orig_params; -- whether to copy the indexes: 0/dbms_redefinition.cons_orig_params
    copy_triggers         BOOLEAN        DEFAULT TRUE;                               -- whether to clone triggers
    copy_constraints      BOOLEAN        DEFAULT TRUE;                               -- whether to clone constraints
    copy_privileges       BOOLEAN        DEFAULT TRUE;                               -- whether to clone privileges
    ignore_errors         BOOLEAN        DEFAULT FALSE;                              -- whether to continue when cloning an object ends in error
    copy_statistics       BOOLEAN        DEFAULT FALSE;                              -- whether to copy statistics
    copy_mvlog            BOOLEAN        DEFAULT FALSE;                              -- whether to copy materialized view log
    dml_lock_timeout      PLS_INTEGER    DEFAULT NULL;                               -- number of seconds to wait for lock before failing
    --- output
    errors_cnt PLS_INTEGER; -- number of errors while cloning dependent objects
begin

    username              := 'MY_SCHEME';
    old_table             := 'MY_OLD_TABLE';
    new_table             := 'MY_NEW_TABLE';
--    partition_name        := NULL;
--    redef_options         := dbms_redefinition.cons_use_pk;
--    col_mapping           := NULL;
--    orderby_cols          := NULL;
--    continue_after_errors := NULL;
--    copy_vpd_opt          := dbms_redefinition.cons_vpd_none;
--    copy_indexes          := dbms_redefinition.cons_orig_params;
--    copy_triggers         := TRUE;
--    copy_constraints      := TRUE;
--    copy_privileges       := TRUE;
--    ignore_errors         := FALSE;
--    copy_statistics       := FALSE;
--    copy_mvlog            := FALSE;
--    dml_lock_timeout      := NULL;

    DBMS_REDEFINITION.CAN_REDEF_TABLE ( -- whether we can redef a table
         uname         => username
       , tname         => old_table
       , options_flag  => redef_options
       , part_name     => partition_name
    );

    DBMS_REDEFINITION.START_REDEF_TABLE ( -- start table redefinition
         uname                   => username
       , orig_table              => old_table
       , int_table               => new_table
       , col_mapping             => col_mapping
       , options_flag            => redef_options
       , orderby_cols            => orderby_cols
       , part_name               => partition_name
       , continue_after_errors   => continue_after_errors
       , copy_vpd_opt            => copy_vpd_opt
    );

    DBMS_REDEFINITION.COPY_TABLE_DEPENDENTS( -- copy dependant objects
         uname                    => username
       , orig_table               => old_table
       , int_table                => new_table
       , copy_indexes             => copy_indexes
       , copy_triggers            => copy_triggers
       , copy_constraints         => copy_constraints
       , copy_privileges          => copy_privileges
       , ignore_errors            => ignore_errors
       , num_errors               => errors_cnt
       , copy_statistics          => copy_statistics
       , copy_mvlog               => copy_mvlog
    );

    DBMS_OUTPUT.PUT_LINE(errors_cnt);

--    DBMS_REDEFINITION.SYNC_INTERIM_TABLE ( -- synchronize original and interim tables
--         uname                   => username
--       , orig_table              => old_table
--       , int_table               => new_table
--       , part_name               => partition_name
--       , continue_after_errors   => continue_after_errors
--    );

    DBMS_REDEFINITION.FINISH_REDEF_TABLE ( -- finish redefinition
         uname                   => username
       , orig_table              => old_table
       , int_table               => new_table
       , part_name               => partition_name
       , dml_lock_timeout        => NULL
       , continue_after_errors   => continue_after_errors
    );
end;
