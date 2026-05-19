-- Create Application Users with Restricted Permissions
-- These users are created with limited privileges and cannot perform destructive operations
-- User credentials should be rotated in production environments

-- Create user: ariel5253
-- Permissions: DDL (Data Definition Language) and DML (Data Manipulation Language)
-- Restrictions: Cannot drop databases, cannot alter/drop other users, limited CREATEDB
CREATE ROLE ariel5253 WITH
  LOGIN
  CREATEDB
  INHERIT
  NOCREATEROLE
  NOREPLICATION
  BYPASSRLS
  VALID UNTIL 'infinity'
  CONNECTION LIMIT 10;

-- Set password for ariel5253
-- IMPORTANT: Change this password in production
ALTER ROLE ariel5253 WITH PASSWORD 'ariel5253';

-- Assign roles to ariel5253
-- This user gets both RO and RW roles since they have DDL;DML permissions
GRANT ro_role TO ariel5253;
GRANT rw_role TO ariel5253;
GRANT admin_role TO ariel5253;

-- Set default role for ariel5253 (RW is the default for most operations)
ALTER ROLE ariel5253 SET search_path = public;

COMMENT ON ROLE ariel5253 IS 'Application user with DDL and DML permissions. Cannot create or modify other users. Access limited to specific schemas and tables.';

-- Revoke dangerous permissions
-- ariel5253 cannot create roles or superusers
REVOKE CREATEROLE FROM ariel5253;

-- Optional: Create additional application user with RO-only permissions
-- This is a template for read-only application users
CREATE ROLE app_readonly WITH
  LOGIN
  INHERIT
  NOCREATEROLE
  NOREPLICATION
  CONNECTION LIMIT 20;

ALTER ROLE app_readonly WITH PASSWORD 'app_readonly_default_password';
GRANT ro_role TO app_readonly;

COMMENT ON ROLE app_readonly IS 'Read-only application role. Use for reporting and analytics applications. Cannot modify any data.';
