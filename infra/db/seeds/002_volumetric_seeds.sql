-- Volumetric seeds: inserts a moderate number of clients to simulate data volume
-- Uses generate_series to create rows; idempotent by checking document_number

INSERT INTO parameterization.client (id, document_type, document_number, first_name, last_name, phone, email, created_by)
SELECT gen_random_uuid(), 'ID', concat('V', gs::text), concat('Client', gs::text), concat('Surname', gs::text), concat('55', lpad(gs::text,4,'0')), concat('client', gs::text, '@example.test'), 'seed'
FROM generate_series(1,200) gs
WHERE NOT EXISTS (SELECT 1 FROM parameterization.client pc WHERE pc.document_number = concat('V', gs::text));

-- Add some rooms for distribution (if table exists)
DO $$
BEGIN
  -- Only insert rooms if distribution.room exists and required reference rows exist
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'distribution' AND table_name = 'room')
     AND EXISTS (SELECT 1 FROM distribution.branch)
     AND EXISTS (SELECT 1 FROM distribution.room_type)
     AND EXISTS (SELECT 1 FROM distribution.room_status) THEN

    INSERT INTO distribution.room (id, branch_id, room_type_id, room_status_id, number, floor, capacity, created_by)
    SELECT gen_random_uuid(), b.id, rt.id, rs.id, concat('R', gs::text), (gs % 10), 2, 'seed'
    FROM generate_series(1,100) gs
    CROSS JOIN LATERAL (SELECT id FROM distribution.branch LIMIT 1) b
    CROSS JOIN LATERAL (SELECT id FROM distribution.room_type LIMIT 1) rt
    CROSS JOIN LATERAL (SELECT id FROM distribution.room_status LIMIT 1) rs
    WHERE NOT EXISTS (SELECT 1 FROM distribution.room r WHERE r.number = concat('R', gs::text));

  ELSE
    RAISE NOTICE 'Skipping distribution.room inserts: required reference data (branch, room_type, room_status) not present.';
  END IF;
END
$$;

-- End of volumetric seeds
