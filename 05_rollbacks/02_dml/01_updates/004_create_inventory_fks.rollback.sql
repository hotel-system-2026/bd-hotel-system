-- Removes foreign key constraints for inventory module

ALTER TABLE inventory.product DROP CONSTRAINT IF EXISTS fk_product_provider;
ALTER TABLE inventory.product_tracking DROP CONSTRAINT IF EXISTS fk_product_tracking_product;
ALTER TABLE inventory.inventory_availability DROP CONSTRAINT IF EXISTS fk_inventory_availability_product;
ALTER TABLE inventory.inventory_availability DROP CONSTRAINT IF EXISTS fk_inventory_availability_service;
