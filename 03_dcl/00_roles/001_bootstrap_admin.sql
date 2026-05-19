-- Bootstrap Administrator - Socket Only Connection
-- This admin user can ONLY connect via Unix domain socket (local connections)
-- Cannot be used for TCP/IP connections

-- Create bootstrap admin role with superuser privileges
-- This role is created with NO LOGIN to prevent direct connection attempts
CREATE ROLE bootstrap_admin WITH
  NOLOGIN
  SUPERUSER
  CREATEDB
  CREATEROLE
  INHERIT
  REPLICATION
  BYPASSRLS;

-- Create a dedicated connection role for socket-based connections
-- This is the actual role that will connect via socket
CREATE ROLE bootstrap_admin_socket WITH
  LOGIN
  SUPERUSER
  CREATEDB
  CREATEROLE
  INHERIT
  REPLICATION
  BYPASSRLS
  VALID UNTIL 'infinity'
  CONNECTION LIMIT 5;

-- Set password for bootstrap socket admin
-- IMPORTANT: Change this password in production
ALTER ROLE bootstrap_admin_socket WITH PASSWORD 'bootstrap_admin_init_password';

-- Ensure this role can only connect locally via socket
-- This is enforced via pg_hba.conf configuration
COMMENT ON ROLE bootstrap_admin_socket IS 'Bootstrap administrator - Socket-only connection. Access restricted to Unix domain socket connections only.';
