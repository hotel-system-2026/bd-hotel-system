-- Dynamic User Creation Script
-- This script creates users based on CSV input
-- Generated from: infra/db/seeds/users.csv
-- Format: username,password,roles,description
-- Roles format: role1;role2;role3

-- Create user: ariel5253
-- Permissions: ro_role, rw_role (DDL/DML)
-- Restrictions: Cannot drop databases, cannot create/alter other users
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_roles
    WHERE rolname = 'ariel5253'
  ) THEN
    CREATE ROLE ariel5253 WITH
      LOGIN
      CREATEDB
      INHERIT
      NOCREATEROLE
      NOREPLICATION
      CONNECTION LIMIT 10;
  END IF;
END
$$;

ALTER ROLE ariel5253 WITH PASSWORD 'ariel5253';

-- Assign roles to ariel5253
GRANT ro_role TO ariel5253;
GRANT rw_role TO ariel5253;

-- Set default search path for ariel5253
ALTER ROLE ariel5253 SET search_path = public;

COMMENT ON ROLE ariel5253 IS 'Application user with DDL and DML permissions. Cannot create or modify other users. Access limited to specific schemas and tables.';

-- Revoke dangerous permissions
ALTER ROLE ariel5253 NOCREATEROLE;

-- ============================================================
-- Create user: app_readonly
-- Permissions: ro_role
-- Restrictions: Read-only access only
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_roles
    WHERE rolname = 'app_readonly'
  ) THEN
    CREATE ROLE app_readonly WITH
      LOGIN
      INHERIT
      NOCREATEROLE
      NOREPLICATION
      CONNECTION LIMIT 20;
  END IF;
END
$$;

ALTER ROLE app_readonly WITH PASSWORD 'app_readonly_default_password';

-- Assign roles to app_readonly
GRANT ro_role TO app_readonly;

-- Set default search path
ALTER ROLE app_readonly SET search_path = public;

COMMENT ON ROLE app_readonly IS 'Read-only application role. Use for reporting and analytics applications. Cannot modify any data.';

-- Revoke dangerous permissions
ALTER ROLE app_readonly NOCREATEROLE;
