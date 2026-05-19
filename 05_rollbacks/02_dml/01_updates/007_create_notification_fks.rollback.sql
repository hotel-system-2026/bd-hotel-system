-- Removes foreign key constraints for notification module

ALTER TABLE notification.alert DROP CONSTRAINT IF EXISTS fk_alert_client;
ALTER TABLE notification.alert DROP CONSTRAINT IF EXISTS fk_alert_reservation;
ALTER TABLE notification.customer_loyalty DROP CONSTRAINT IF EXISTS fk_customer_loyalty_client;
