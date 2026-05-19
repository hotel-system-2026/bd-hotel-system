-- Adds foreign key constraints for service_provision module

ALTER TABLE service_provision.room_reservation
    ADD CONSTRAINT fk_room_reservation_client FOREIGN KEY (client_id) REFERENCES parameterization.client(id),
    ADD CONSTRAINT fk_room_reservation_room FOREIGN KEY (room_id) REFERENCES distribution.room(id);

ALTER TABLE service_provision.room_cancellation
    ADD CONSTRAINT fk_room_cancellation_reservation FOREIGN KEY (room_reservation_id) REFERENCES service_provision.room_reservation(id);

ALTER TABLE service_provision.room_availability
    ADD CONSTRAINT fk_room_availability_room FOREIGN KEY (room_id) REFERENCES distribution.room(id);

ALTER TABLE service_provision.room_catalog
    ADD CONSTRAINT fk_room_catalog_room FOREIGN KEY (room_id) REFERENCES distribution.room(id);

ALTER TABLE service_provision.check_in
    ADD CONSTRAINT fk_check_in_reservation FOREIGN KEY (room_reservation_id) REFERENCES service_provision.room_reservation(id),
    ADD CONSTRAINT fk_check_in_employee FOREIGN KEY (employee_id) REFERENCES parameterization.employee(id);

ALTER TABLE service_provision.stay
    ADD CONSTRAINT fk_stay_reservation FOREIGN KEY (room_reservation_id) REFERENCES service_provision.room_reservation(id),
    ADD CONSTRAINT fk_stay_client FOREIGN KEY (client_id) REFERENCES parameterization.client(id),
    ADD CONSTRAINT fk_stay_room FOREIGN KEY (room_id) REFERENCES distribution.room(id);

ALTER TABLE service_provision.check_out
    ADD CONSTRAINT fk_check_out_stay FOREIGN KEY (stay_id) REFERENCES service_provision.stay(id),
    ADD CONSTRAINT fk_check_out_employee FOREIGN KEY (employee_id) REFERENCES parameterization.employee(id);

ALTER TABLE service_provision.product_sale
    ADD CONSTRAINT fk_product_sale_stay FOREIGN KEY (stay_id) REFERENCES service_provision.stay(id),
    ADD CONSTRAINT fk_product_sale_product FOREIGN KEY (product_id) REFERENCES inventory.product(id);

ALTER TABLE service_provision.service_sale
    ADD CONSTRAINT fk_service_sale_stay FOREIGN KEY (stay_id) REFERENCES service_provision.stay(id),
    ADD CONSTRAINT fk_service_sale_service FOREIGN KEY (service_id) REFERENCES inventory.service(id);
