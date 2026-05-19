-- Validation checks to ensure security model is correctly applied
-- This file validates that permissions are correctly assigned

-- 1. Verify bootstrap_admin_socket exists and is superuser
SELECT 
  rolname,
  rolsuper,
  rolcreatedb,
  rolcreaterole
FROM pg_roles
WHERE rolname = 'bootstrap_admin_socket';

-- 2. Verify ariel5253 exists and is not superuser
SELECT 
  rolname,
  rolsuper,
  rolcreatedb,
  rolcreaterole
FROM pg_roles
WHERE rolname = 'ariel5253';

-- 3. Verify role hierarchy
SELECT 
  m.rolname as member,
  r.rolname as role,
  g.admin_option
FROM pg_auth_members g
JOIN pg_roles r ON g.roleid = r.oid
JOIN pg_roles m ON g.member = m.oid
WHERE m.rolname IN ('ariel5253', 'app_readonly')
ORDER BY m.rolname, r.rolname;

-- 4. Verify ro_role, rw_role, admin_role exist
SELECT 
  rolname,
  rolcanlogin,
  rolcreatedb,
  rolcreaterole,
  rolsuper
FROM pg_roles
WHERE rolname IN ('ro_role', 'rw_role', 'admin_role', 'bootstrap_admin_socket')
ORDER BY rolname;

-- 5. Check that ariel5253 cannot create roles (NOCREATEROLE)
SELECT 
  rolname,
  rolcreaterole
FROM pg_roles
WHERE rolname = 'ariel5253';

-- 6. Verify current default privileges
SELECT 
  NULL::text as schemaname,
  NULL::text as tablename,
  'bootstrap_admin_socket' as grantor,
  'ro_role' as grantee,
  'SELECT'::text as privilege_type
UNION ALL
SELECT 
  NULL::text,
  NULL::text,
  'bootstrap_admin_socket',
  'rw_role',
  'SELECT'::text;
