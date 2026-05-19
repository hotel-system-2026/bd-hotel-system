-- ============================================================================
-- Service Provision Module Tables
-- Schema: service_provision
-- Module: Service Provision
-- Description: Hotel service provision tables for reservations, stays, check-in/out, catalog, and sales
-- ============================================================================

-- ==============================================
-- Table: room_reservation
-- ==============================================
CREATE TABLE service_provision.room_reservation (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id UUID NOT NULL,
    room_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    person_count INTEGER NOT NULL,
    reservation_status VARCHAR(50) NOT NULL,
    estimated_value NUMERIC(12, 2) NOT NULL DEFAULT 0,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT room_reservation_status_check CHECK (status IN ('active', 'inactive', 'deleted')),
    CONSTRAINT room_reservation_date_range_check CHECK (start_date <= end_date),
    CONSTRAINT room_reservation_person_count_check CHECK (person_count > 0),
    CONSTRAINT room_reservation_value_check CHECK (estimated_value >= 0)
);

-- ==============================================
-- Table: room_cancellation
-- ==============================================
CREATE TABLE service_provision.room_cancellation (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    room_reservation_id UUID NOT NULL,
    reason TEXT NOT NULL,
    cancellation_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    applies_penalty BOOLEAN DEFAULT FALSE NOT NULL,
    penalty_value NUMERIC(12, 2) DEFAULT 0 NOT NULL,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT room_cancellation_status_check CHECK (status IN ('active', 'inactive', 'deleted')),
    CONSTRAINT room_cancellation_penalty_check CHECK (penalty_value >= 0)
);

-- ==============================================
-- Table: room_availability
-- ==============================================
CREATE TABLE service_provision.room_availability (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    room_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    available BOOLEAN DEFAULT TRUE NOT NULL,
    unavailable_reason TEXT,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT room_availability_status_check CHECK (status IN ('active', 'inactive', 'deleted')),
    CONSTRAINT room_availability_date_range_check CHECK (start_date <= end_date)
);

-- ==============================================
-- Table: room_catalog
-- ==============================================
CREATE TABLE service_provision.room_catalog (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    room_id UUID NOT NULL,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    base_price NUMERIC(12, 2) NOT NULL DEFAULT 0,
    visible BOOLEAN DEFAULT TRUE NOT NULL,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT room_catalog_status_check CHECK (status IN ('active', 'inactive', 'deleted')),
    CONSTRAINT room_catalog_price_check CHECK (base_price >= 0)
);

-- ==============================================
-- Table: check_in
-- ==============================================
CREATE TABLE service_provision.check_in (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    room_reservation_id UUID NOT NULL,
    employee_id UUID NOT NULL,
    entry_time TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    observation TEXT,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT check_in_status_check CHECK (status IN ('active', 'inactive', 'deleted'))
);

-- ==============================================
-- Table: stay
-- ==============================================
CREATE TABLE service_provision.stay (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    room_reservation_id UUID NOT NULL,
    client_id UUID NOT NULL,
    room_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    stay_status VARCHAR(50) NOT NULL,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT stay_status_check CHECK (status IN ('active', 'inactive', 'deleted')),
    CONSTRAINT stay_date_range_check CHECK (start_date <= end_date)
);

-- ==============================================
-- Table: check_out
-- ==============================================
CREATE TABLE service_provision.check_out (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    stay_id UUID NOT NULL,
    employee_id UUID NOT NULL,
    exit_time TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    observation TEXT,
    total_value NUMERIC(12, 2) NOT NULL DEFAULT 0,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT check_out_status_check CHECK (status IN ('active', 'inactive', 'deleted')),
    CONSTRAINT check_out_value_check CHECK (total_value >= 0)
);

-- ==============================================
-- Table: product_sale
-- ==============================================
CREATE TABLE service_provision.product_sale (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    stay_id UUID NOT NULL,
    product_id UUID NOT NULL,
    quantity INTEGER NOT NULL,
    unit_value NUMERIC(12, 2) NOT NULL,
    total_value NUMERIC(12, 2) NOT NULL,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT product_sale_status_check CHECK (status IN ('active', 'inactive', 'deleted')),
    CONSTRAINT product_sale_quantity_check CHECK (quantity > 0),
    CONSTRAINT product_sale_value_check CHECK (unit_value >= 0 AND total_value >= 0)
);

-- ==============================================
-- Table: service_sale
-- ==============================================
CREATE TABLE service_provision.service_sale (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    stay_id UUID NOT NULL,
    service_id UUID NOT NULL,
    quantity INTEGER NOT NULL,
    unit_value NUMERIC(12, 2) NOT NULL,
    total_value NUMERIC(12, 2) NOT NULL,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT service_sale_status_check CHECK (status IN ('active', 'inactive', 'deleted')),
    CONSTRAINT service_sale_quantity_check CHECK (quantity > 0),
    CONSTRAINT service_sale_value_check CHECK (unit_value >= 0 AND total_value >= 0)
);