SELECT
    VERSION() AS mysql_version,
    CURRENT_USER() AS connected_user,
    DATABASE() AS selected_database,
    @@autocommit AS autocommit_enabled;
show databases;
