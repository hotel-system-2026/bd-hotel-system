-- Removes foreign key constraints for parameterization module

ALTER TABLE parameterization.legal_information DROP CONSTRAINT IF EXISTS fk_legal_information_company;
ALTER TABLE parameterization.price DROP CONSTRAINT IF EXISTS fk_price_room_type;
ALTER TABLE parameterization.price DROP CONSTRAINT IF EXISTS fk_price_day_type;
ALTER TABLE parameterization.employee DROP CONSTRAINT IF EXISTS fk_employee_person;
