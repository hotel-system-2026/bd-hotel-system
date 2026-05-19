-- Adds foreign key constraints for bill module

ALTER TABLE bill.pre_invoice
    ADD CONSTRAINT fk_pre_invoice_stay FOREIGN KEY (stay_id) REFERENCES service_provision.stay(id),
    ADD CONSTRAINT fk_pre_invoice_reservation FOREIGN KEY (room_reservation_id) REFERENCES service_provision.room_reservation(id),
    ADD CONSTRAINT fk_pre_invoice_client FOREIGN KEY (client_id) REFERENCES parameterization.client(id);

ALTER TABLE bill.partial_payment
    ADD CONSTRAINT fk_partial_payment_reservation FOREIGN KEY (room_reservation_id) REFERENCES service_provision.room_reservation(id),
    ADD CONSTRAINT fk_partial_payment_invoice FOREIGN KEY (invoice_id) REFERENCES bill.invoice(id),
    ADD CONSTRAINT fk_partial_payment_payment_method FOREIGN KEY (payment_method_id) REFERENCES parameterization.payment_method(id);

ALTER TABLE bill.invoice
    ADD CONSTRAINT fk_invoice_client FOREIGN KEY (client_id) REFERENCES parameterization.client(id),
    ADD CONSTRAINT fk_invoice_stay FOREIGN KEY (stay_id) REFERENCES service_provision.stay(id);

ALTER TABLE bill.invoice_detail
    ADD CONSTRAINT fk_invoice_detail_invoice FOREIGN KEY (invoice_id) REFERENCES bill.invoice(id),
    ADD CONSTRAINT fk_invoice_detail_product FOREIGN KEY (product_id) REFERENCES inventory.product(id),
    ADD CONSTRAINT fk_invoice_detail_service FOREIGN KEY (service_id) REFERENCES inventory.service(id);
