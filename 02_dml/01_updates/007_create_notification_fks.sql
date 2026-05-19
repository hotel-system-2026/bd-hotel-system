-- Adds foreign key constraints for notification module

ALTER TABLE notification.alert
    ADD CONSTRAINT fk_alert_client FOREIGN KEY (client_id) REFERENCES parameterization.client(id),
    ADD CONSTRAINT fk_alert_reservation FOREIGN KEY (room_reservation_id) REFERENCES service_provision.room_reservation(id);

ALTER TABLE notification.customer_loyalty
    ADD CONSTRAINT fk_customer_loyalty_client FOREIGN KEY (client_id) REFERENCES parameterization.client(id);
