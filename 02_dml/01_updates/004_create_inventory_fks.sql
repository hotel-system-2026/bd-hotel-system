-- Adds foreign key constraints for inventory module

ALTER TABLE inventory.product
    ADD CONSTRAINT fk_product_provider FOREIGN KEY (provider_id) REFERENCES inventory.provider(id);

ALTER TABLE inventory.product_tracking
    ADD CONSTRAINT fk_product_tracking_product FOREIGN KEY (product_id) REFERENCES inventory.product(id);

ALTER TABLE inventory.inventory_availability
    ADD CONSTRAINT fk_inventory_availability_product FOREIGN KEY (product_id) REFERENCES inventory.product(id),
    ADD CONSTRAINT fk_inventory_availability_service FOREIGN KEY (service_id) REFERENCES inventory.service(id);
