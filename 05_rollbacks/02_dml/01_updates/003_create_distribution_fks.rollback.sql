-- Removes foreign key constraints for distribution module

ALTER TABLE distribution.branch DROP CONSTRAINT IF EXISTS fk_branch_company;
ALTER TABLE distribution.room DROP CONSTRAINT IF EXISTS fk_room_branch;
ALTER TABLE distribution.room DROP CONSTRAINT IF EXISTS fk_room_room_type;
ALTER TABLE distribution.room DROP CONSTRAINT IF EXISTS fk_room_room_status;
