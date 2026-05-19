-- Adds foreign key constraints for distribution module

ALTER TABLE distribution.branch
    ADD CONSTRAINT fk_branch_company FOREIGN KEY (company_id) REFERENCES parameterization.company(id);

ALTER TABLE distribution.room
    ADD CONSTRAINT fk_room_branch FOREIGN KEY (branch_id) REFERENCES distribution.branch(id),
    ADD CONSTRAINT fk_room_room_type FOREIGN KEY (room_type_id) REFERENCES distribution.room_type(id),
    ADD CONSTRAINT fk_room_room_status FOREIGN KEY (room_status_id) REFERENCES distribution.room_status(id);
