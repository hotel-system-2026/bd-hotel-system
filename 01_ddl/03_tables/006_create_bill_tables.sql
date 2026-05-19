-- ============================================================================
-- Bill Module Tables
-- Schema: bill
-- Module: Billing
-- Description: Hotel billing tables for pre-invoices, payments, invoices, and invoice details
-- ============================================================================

-- ==============================================
-- Table: invoice
-- ==============================================
CREATE TABLE bill.invoice (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id UUID NOT NULL,
    stay_id UUID NOT NULL,
    invoice_number VARCHAR(50) NOT NULL UNIQUE,
    issue_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    subtotal NUMERIC(12, 2) NOT NULL DEFAULT 0,
    tax_amount NUMERIC(12, 2) NOT NULL DEFAULT 0,
    discount_amount NUMERIC(12, 2) NOT NULL DEFAULT 0,
    total_amount NUMERIC(12, 2) NOT NULL DEFAULT 0,
    invoice_status VARCHAR(50) NOT NULL,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT invoice_status_check CHECK (status IN ('active', 'inactive', 'deleted')),
    CONSTRAINT invoice_value_check CHECK (subtotal >= 0 AND tax_amount >= 0 AND discount_amount >= 0 AND total_amount >= 0)
);

-- ==============================================
-- Table: pre_invoice
-- ==============================================
CREATE TABLE bill.pre_invoice (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    stay_id UUID NOT NULL,
    room_reservation_id UUID NOT NULL,
    client_id UUID NOT NULL,
    subtotal NUMERIC(12, 2) NOT NULL DEFAULT 0,
    tax_amount NUMERIC(12, 2) NOT NULL DEFAULT 0,
    discount_amount NUMERIC(12, 2) NOT NULL DEFAULT 0,
    total_amount NUMERIC(12, 2) NOT NULL DEFAULT 0,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT pre_invoice_status_check CHECK (status IN ('active', 'inactive', 'deleted')),
    CONSTRAINT pre_invoice_value_check CHECK (subtotal >= 0 AND tax_amount >= 0 AND discount_amount >= 0 AND total_amount >= 0)
);

-- ==============================================
-- Table: invoice_detail
-- ==============================================
CREATE TABLE bill.invoice_detail (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    invoice_id UUID NOT NULL,
    product_id UUID,
    service_id UUID,
    description TEXT,
    quantity INTEGER NOT NULL DEFAULT 1,
    unit_value NUMERIC(12, 2) NOT NULL,
    total_value NUMERIC(12, 2) NOT NULL,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT invoice_detail_status_check CHECK (status IN ('active', 'inactive', 'deleted')),
    CONSTRAINT invoice_detail_quantity_check CHECK (quantity > 0),
    CONSTRAINT invoice_detail_value_check CHECK (unit_value >= 0 AND total_value >= 0),
    CONSTRAINT invoice_detail_product_or_service_check CHECK (
        (product_id IS NOT NULL AND service_id IS NULL) OR
        (product_id IS NULL AND service_id IS NOT NULL)
    )
);

-- ==============================================
-- Table: partial_payment
-- ==============================================
CREATE TABLE bill.partial_payment (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    room_reservation_id UUID NOT NULL,
    invoice_id UUID NOT NULL,
    payment_method_id UUID NOT NULL,
    value NUMERIC(12, 2) NOT NULL,
    payment_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    payment_reference VARCHAR(150),
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT partial_payment_status_check CHECK (status IN ('active', 'inactive', 'deleted')),
    CONSTRAINT partial_payment_value_check CHECK (value > 0)
);