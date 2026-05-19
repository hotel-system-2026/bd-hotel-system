-- Removes foreign key constraints for bill module

ALTER TABLE bill.pre_invoice DROP CONSTRAINT IF EXISTS fk_pre_invoice_stay;
ALTER TABLE bill.pre_invoice DROP CONSTRAINT IF EXISTS fk_pre_invoice_reservation;
ALTER TABLE bill.pre_invoice DROP CONSTRAINT IF EXISTS fk_pre_invoice_client;
ALTER TABLE bill.partial_payment DROP CONSTRAINT IF EXISTS fk_partial_payment_reservation;
ALTER TABLE bill.partial_payment DROP CONSTRAINT IF EXISTS fk_partial_payment_invoice;
ALTER TABLE bill.partial_payment DROP CONSTRAINT IF EXISTS fk_partial_payment_payment_method;
ALTER TABLE bill.invoice DROP CONSTRAINT IF EXISTS fk_invoice_client;
ALTER TABLE bill.invoice DROP CONSTRAINT IF EXISTS fk_invoice_stay;
ALTER TABLE bill.invoice_detail DROP CONSTRAINT IF EXISTS fk_invoice_detail_invoice;
ALTER TABLE bill.invoice_detail DROP CONSTRAINT IF EXISTS fk_invoice_detail_product;
ALTER TABLE bill.invoice_detail DROP CONSTRAINT IF EXISTS fk_invoice_detail_service;
