-- Canonical distribution seeds: branches (sede), room types, room statuses
-- Idempotent inserts

-- Use existing company (created by canonical seeds)
INSERT INTO distribution.branch (id, company_id, name, address, city, phone, email, created_by)
SELECT gen_random_uuid(), c.id, 'Sede Centro', 'Calle 1 #10-10', 'Ciudad', '3100000000', 'sede@hotel.test', 'seed'
FROM parameterization.company c
WHERE c.nit = 'NIT-1001'
  AND NOT EXISTS (SELECT 1 FROM distribution.branch b WHERE b.name = 'Sede Centro');

INSERT INTO distribution.room_type (id, name, description, base_capacity, max_capacity, created_by)
SELECT gen_random_uuid(), 'Standard', 'Habitación estándar', 2, 3, 'seed'
WHERE NOT EXISTS (SELECT 1 FROM distribution.room_type rt WHERE rt.name = 'Standard');

INSERT INTO distribution.room_type (id, name, description, base_capacity, max_capacity, created_by)
SELECT gen_random_uuid(), 'Deluxe', 'Habitación deluxe', 2, 4, 'seed'
WHERE NOT EXISTS (SELECT 1 FROM distribution.room_type rt WHERE rt.name = 'Deluxe');

INSERT INTO distribution.room_status (id, name, description, allows_reservation, allows_check_in, created_by)
SELECT gen_random_uuid(), 'available', 'Disponible para reserva', TRUE, TRUE, 'seed'
WHERE NOT EXISTS (SELECT 1 FROM distribution.room_status rs WHERE rs.name = 'available');

INSERT INTO distribution.room_status (id, name, description, allows_reservation, allows_check_in, created_by)
SELECT gen_random_uuid(), 'maintenance', 'En mantenimiento', FALSE, FALSE, 'seed'
WHERE NOT EXISTS (SELECT 1 FROM distribution.room_status rs WHERE rs.name = 'maintenance');

-- End distribution seeds
