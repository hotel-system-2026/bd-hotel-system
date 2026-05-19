-- Removes foreign key constraints for service_provision module

ALTER TABLE service_provision.room_reservation DROP CONSTRAINT IF EXISTS fk_room_reservation_client;
ALTER TABLE service_provision.room_reservation DROP CONSTRAINT IF EXISTS fk_room_reservation_room;
ALTER TABLE service_provision.room_cancellation DROP CONSTRAINT IF EXISTS fk_room_cancellation_reservation;
ALTER TABLE service_provision.room_availability DROP CONSTRAINT IF EXISTS fk_room_availability_room;
ALTER TABLE service_provision.room_catalog DROP CONSTRAINT IF EXISTS fk_room_catalog_room;
ALTER TABLE service_provision.check_in DROP CONSTRAINT IF EXISTS fk_check_in_reservation;
ALTER TABLE service_provision.check_in DROP CONSTRAINT IF EXISTS fk_check_in_employee;
ALTER TABLE service_provision.stay DROP CONSTRAINT IF EXISTS fk_stay_reservation;
ALTER TABLE service_provision.stay DROP CONSTRAINT IF EXISTS fk_stay_client;
ALTER TABLE service_provision.stay DROP CONSTRAINT IF EXISTS fk_stay_room;
ALTER TABLE service_provision.check_out DROP CONSTRAINT IF EXISTS fk_check_out_stay;
ALTER TABLE service_provision.check_out DROP CONSTRAINT IF EXISTS fk_check_out_employee;
ALTER TABLE service_provision.product_sale DROP CONSTRAINT IF EXISTS fk_product_sale_stay;
ALTER TABLE service_provision.product_sale DROP CONSTRAINT IF EXISTS fk_product_sale_product;
ALTER TABLE service_provision.service_sale DROP CONSTRAINT IF EXISTS fk_service_sale_stay;
ALTER TABLE service_provision.service_sale DROP CONSTRAINT IF EXISTS fk_service_sale_service;
