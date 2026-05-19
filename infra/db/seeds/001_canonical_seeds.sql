-- Canonical seeds: minimal stable reference data
-- Idempotent inserts using WHERE NOT EXISTS to allow re-runs

-- Roles
INSERT INTO security.role (id, name, description, created_by)
SELECT gen_random_uuid(), 'app_admin', 'Application administrator', 'seed'
WHERE NOT EXISTS (SELECT 1 FROM security.role WHERE name = 'app_admin');

INSERT INTO security.role (id, name, description, created_by)
SELECT gen_random_uuid(), 'ro_role', 'Read-only role', 'seed'
WHERE NOT EXISTS (SELECT 1 FROM security.role WHERE name = 'ro_role');

INSERT INTO security.role (id, name, description, created_by)
SELECT gen_random_uuid(), 'rw_role', 'Read-write role', 'seed'
WHERE NOT EXISTS (SELECT 1 FROM security.role WHERE name = 'rw_role');

-- Companies (parameterization.company)
INSERT INTO parameterization.company (id, name, nit, created_by)
SELECT gen_random_uuid(), 'Hotel Central', 'NIT-1001', 'seed'
WHERE NOT EXISTS (SELECT 1 FROM parameterization.company WHERE nit = 'NIT-1001');

INSERT INTO parameterization.company (id, name, nit, created_by)
SELECT gen_random_uuid(), 'Resort Sol', 'NIT-1002', 'seed'
WHERE NOT EXISTS (SELECT 1 FROM parameterization.company WHERE nit = 'NIT-1002');

INSERT INTO parameterization.company (id, name, nit, created_by)
SELECT gen_random_uuid(), 'Beachside Inn', 'NIT-1003', 'seed'
WHERE NOT EXISTS (SELECT 1 FROM parameterization.company WHERE nit = 'NIT-1003');

-- Clients (parameterization.client)
INSERT INTO parameterization.client (id, document_type, document_number, first_name, last_name, created_by)
SELECT gen_random_uuid(), 'ID', 'C-1001', 'Alice', 'Gonzalez', 'seed'
WHERE NOT EXISTS (SELECT 1 FROM parameterization.client WHERE document_number = 'C-1001');

INSERT INTO parameterization.client (id, document_type, document_number, first_name, last_name, created_by)
SELECT gen_random_uuid(), 'ID', 'C-1002', 'Bob', 'Martinez', 'seed'
WHERE NOT EXISTS (SELECT 1 FROM parameterization.client WHERE document_number = 'C-1002');

INSERT INTO parameterization.client (id, document_type, document_number, first_name, last_name, created_by)
SELECT gen_random_uuid(), 'ID', 'C-1003', 'Carla', 'Rodriguez', 'seed'
WHERE NOT EXISTS (SELECT 1 FROM parameterization.client WHERE document_number = 'C-1003');

-- Optional: provider example for inventory
INSERT INTO inventory.provider (id, name, nit, created_by)
SELECT gen_random_uuid(), 'Proveedor Uno', 'PROV-1001', 'seed'
WHERE NOT EXISTS (SELECT 1 FROM inventory.provider WHERE nit = 'PROV-1001');

-- End of canonical seeds
