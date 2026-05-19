-- Adds foreign key constraints for parameterization module

ALTER TABLE parameterization.legal_information
    ADD CONSTRAINT fk_legal_information_company FOREIGN KEY (company_id) REFERENCES parameterization.company(id);

ALTER TABLE parameterization.price
    ADD CONSTRAINT fk_price_room_type FOREIGN KEY (room_type_id) REFERENCES distribution.room_type(id),
    ADD CONSTRAINT fk_price_day_type FOREIGN KEY (day_type_id) REFERENCES parameterization.day_type(id);

ALTER TABLE parameterization.employee
    ADD CONSTRAINT fk_employee_person FOREIGN KEY (person_id) REFERENCES security.person(id);
