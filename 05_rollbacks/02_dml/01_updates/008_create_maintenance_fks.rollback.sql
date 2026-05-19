-- Removes foreign key constraints for maintenance module

ALTER TABLE maintenance.room_maintenance DROP CONSTRAINT IF EXISTS fk_room_maintenance_room;
ALTER TABLE maintenance.room_maintenance DROP CONSTRAINT IF EXISTS fk_room_maintenance_employee;
ALTER TABLE maintenance.maintenance_usage DROP CONSTRAINT IF EXISTS fk_maintenance_usage_room_maintenance;
ALTER TABLE maintenance.maintenance_remodeling DROP CONSTRAINT IF EXISTS fk_maintenance_remodeling_room_maintenance;
ALTER TABLE maintenance.maintenance_dashboard DROP CONSTRAINT IF EXISTS fk_maintenance_dashboard_branch;
