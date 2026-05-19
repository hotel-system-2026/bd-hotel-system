-- Create Base RBAC Roles for the Hotel System

-- READ-ONLY (RO) Role
-- This role has permissions to read data but cannot modify any data
CREATE ROLE ro_role WITH
  NOLOGIN
  INHERIT;

COMMENT ON ROLE ro_role IS 'Read-only role for database access. Can SELECT from tables and views but cannot modify data.';

-- READ-WRITE (RW) Role  
-- This role has permissions to read and write data but cannot modify schema
CREATE ROLE rw_role WITH
  NOLOGIN
  INHERIT;

COMMENT ON ROLE rw_role IS 'Read-write role for database access. Can SELECT, INSERT, UPDATE from tables but cannot modify schema or drop objects.';

-- ADMIN Role for limited administrative tasks
-- This role can perform DDL and DML operations but cannot create users or modify system roles
CREATE ROLE admin_role WITH
  NOLOGIN
  CREATEDB
  CREATEROLE
  INHERIT;

COMMENT ON ROLE admin_role IS 'Limited admin role. Can manage database objects but cannot create/alter other users or manage system-level privileges.';

-- Default privileges for RO role
-- Grant SELECT on all future tables
ALTER DEFAULT PRIVILEGES
  GRANT SELECT ON TABLES TO ro_role;

-- Grant SELECT on all future views
ALTER DEFAULT PRIVILEGES
  GRANT SELECT ON TABLES TO ro_role;

-- Grant USAGE on all future schemas
GRANT USAGE ON SCHEMA public TO ro_role;

-- Default privileges for RW role
-- Grant SELECT, INSERT, UPDATE on all future tables
ALTER DEFAULT PRIVILEGES
  GRANT SELECT, INSERT, UPDATE ON TABLES TO rw_role;

-- Grant SELECT on all future views
ALTER DEFAULT PRIVILEGES
  GRANT SELECT ON TABLES TO rw_role;

-- Grant USAGE on all future schemas
GRANT USAGE ON SCHEMA public TO rw_role;

-- Allow RW to use sequences
ALTER DEFAULT PRIVILEGES
  GRANT USAGE, SELECT ON SEQUENCES TO rw_role;

-- Grant sequence usage to RO role
ALTER DEFAULT PRIVILEGES
  GRANT USAGE ON SEQUENCES TO ro_role;
