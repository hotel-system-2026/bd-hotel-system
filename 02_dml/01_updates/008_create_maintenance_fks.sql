-- Adds foreign key constraints for maintenance module

ALTER TABLE maintenance.room_maintenance
    ADD CONSTRAINT fk_room_maintenance_room FOREIGN KEY (room_id) REFERENCES distribution.room(id),
    ADD CONSTRAINT fk_room_maintenance_employee FOREIGN KEY (employee_id) REFERENCES parameterization.employee(id);

ALTER TABLE maintenance.maintenance_usage
    ADD CONSTRAINT fk_maintenance_usage_room_maintenance FOREIGN KEY (room_maintenance_id) REFERENCES maintenance.room_maintenance(id);

ALTER TABLE maintenance.maintenance_remodeling
    ADD CONSTRAINT fk_maintenance_remodeling_room_maintenance FOREIGN KEY (room_maintenance_id) REFERENCES maintenance.room_maintenance(id);

ALTER TABLE maintenance.maintenance_dashboard
    ADD CONSTRAINT fk_maintenance_dashboard_branch FOREIGN KEY (branch_id) REFERENCES distribution.branch(id);
