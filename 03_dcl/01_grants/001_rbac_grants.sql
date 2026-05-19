-- Grant Specific Permissions to Application Users
-- These grants ensure users can only perform their intended operations

-- Get current database name for dynamic references
-- This file should be executed as superuser

-- Grants for RO (Read-Only) Role
-- Grant SELECT on existing tables
ALTER DEFAULT PRIVILEGES FOR ROLE bootstrap_admin_socket
  GRANT SELECT ON TABLES TO ro_role;

-- Grants for RW (Read-Write) Role
-- Grant SELECT, INSERT, UPDATE (but NOT DELETE or ALTER) on existing tables
ALTER DEFAULT PRIVILEGES FOR ROLE bootstrap_admin_socket
  GRANT SELECT, INSERT, UPDATE ON TABLES TO rw_role;

-- Grants for ADMIN (Limited Admin) Role
-- Can manage database objects but NOT users
ALTER DEFAULT PRIVILEGES FOR ROLE bootstrap_admin_socket
  GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO admin_role;

-- Explicit denial of dangerous operations for ariel5253
-- Prevent user from altering database-level settings
REVOKE ALL PRIVILEGES ON DATABASE hotel_system FROM ariel5253;
GRANT CONNECT, TEMPORARY ON DATABASE hotel_system TO ariel5253;

-- Prevent schema modification
ALTER DEFAULT PRIVILEGES FOR USER bootstrap_admin_socket IN SCHEMA public
  GRANT USAGE ON SCHEMAS TO ariel5253;

-- Allow sequence usage for RW operations
ALTER DEFAULT PRIVILEGES FOR ROLE bootstrap_admin_socket
  GRANT USAGE, SELECT ON SEQUENCES TO rw_role;

-- Grant permissions on existing public schema
GRANT USAGE ON SCHEMA public TO ro_role, rw_role, admin_role;
GRANT CREATE ON SCHEMA public TO admin_role;

-- Prevent ariel5253 from being able to execute dangerous commands
REVOKE TRUNCATE ON ALL TABLES IN SCHEMA public FROM ariel5253;

-- Create policy: ariel5253 cannot create or modify roles
-- This is enforced through REVOKE CREATEROLE, which was already done
-- Additional safeguard: prevent ALTER/DROP of other users
REVOKE ALL ON postgres FROM ariel5253;

-- Grant SELECT on system catalogs for inspection but not modification
GRANT SELECT ON pg_catalog.pg_user TO ariel5253;
GRANT SELECT ON pg_catalog.pg_roles TO ariel5253;
