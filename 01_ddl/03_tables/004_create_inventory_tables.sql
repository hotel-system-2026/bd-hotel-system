-- ============================================================================
-- Inventory Module Tables
-- Schema: inventory
-- Module: Inventory
-- Description: Inventory management tables for products, services, providers, and tracking
-- ============================================================================

-- ==============================================
-- Table: provider
-- ==============================================
CREATE TABLE inventory.provider (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(150) NOT NULL UNIQUE,
    nit VARCHAR(50) NOT NULL UNIQUE,
    phone VARCHAR(20),
    email VARCHAR(100),
    address VARCHAR(255),
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT provider_status_check CHECK (status IN ('active', 'inactive', 'deleted'))
);

-- ==============================================
-- Table: product
-- ==============================================
CREATE TABLE inventory.product (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    provider_id UUID NOT NULL,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    sale_value NUMERIC(12, 2) NOT NULL,
    current_stock INTEGER NOT NULL DEFAULT 0,
    minimum_stock INTEGER NOT NULL DEFAULT 0,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT product_status_check CHECK (status IN ('active', 'inactive', 'deleted')),
    CONSTRAINT product_stock_check CHECK (current_stock >= 0 AND minimum_stock >= 0),
    CONSTRAINT product_price_check CHECK (sale_value > 0)
);

-- ==============================================
-- Table: service
-- ==============================================
CREATE TABLE inventory.service (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(150) NOT NULL UNIQUE,
    description TEXT,
    sale_value NUMERIC(12, 2) NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT service_status_check CHECK (status IN ('active', 'inactive', 'deleted')),
    CONSTRAINT service_price_check CHECK (sale_value > 0)
);

-- ==============================================
-- Table: product_tracking
-- ==============================================
CREATE TABLE inventory.product_tracking (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL,
    movement_type VARCHAR(50) NOT NULL,
    quantity INTEGER NOT NULL,
    movement_date DATE NOT NULL DEFAULT CURRENT_DATE,
    observation TEXT,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT product_tracking_status_check CHECK (status IN ('active', 'inactive', 'deleted')),
    CONSTRAINT product_tracking_movement_type_check CHECK (movement_type IN ('entry', 'exit', 'adjustment', 'return'))
);

-- ==============================================
-- Table: inventory_availability
-- ==============================================
CREATE TABLE inventory.inventory_availability (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID,
    service_id UUID,
    available_quantity INTEGER,
    is_available BOOLEAN DEFAULT TRUE,
    observation TEXT,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT inventory_availability_status_check CHECK (status IN ('active', 'inactive', 'deleted')),
    CONSTRAINT inventory_product_or_service_check CHECK ((product_id IS NOT NULL AND service_id IS NULL) OR (product_id IS NULL AND service_id IS NOT NULL))
);