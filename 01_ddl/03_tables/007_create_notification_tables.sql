-- ============================================================================
-- Notification Module Tables
-- Schema: notification
-- Module: Notification
-- Description: Notification tables for promotions, alerts, terms and conditions, and customer loyalty
-- ============================================================================

-- ==============================================
-- Table: promotion
-- ==============================================
CREATE TABLE notification.promotion (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(150) NOT NULL,
    description TEXT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    channel VARCHAR(50) NOT NULL,
    active BOOLEAN DEFAULT TRUE NOT NULL,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT promotion_status_check CHECK (status IN ('active', 'inactive', 'deleted')),
    CONSTRAINT promotion_date_range_check CHECK (start_date <= end_date)
);

-- ==============================================
-- Table: alert
-- ==============================================
CREATE TABLE notification.alert (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id UUID NOT NULL,
    room_reservation_id UUID,
    title VARCHAR(150) NOT NULL,
    message TEXT NOT NULL,
    channel VARCHAR(50) NOT NULL,
    send_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT alert_status_check CHECK (status IN ('active', 'inactive', 'deleted'))
);

-- ==============================================
-- Table: terms_condition
-- ==============================================
CREATE TABLE notification.terms_condition (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(150) NOT NULL,
    content TEXT NOT NULL,
    version VARCHAR(50) NOT NULL,
    effective_date DATE NOT NULL,
    mandatory BOOLEAN DEFAULT TRUE NOT NULL,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT terms_condition_status_check CHECK (status IN ('active', 'inactive', 'deleted'))
);

-- ==============================================
-- Table: customer_loyalty
-- ==============================================
CREATE TABLE notification.customer_loyalty (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id UUID NOT NULL,
    level VARCHAR(100) NOT NULL,
    points INTEGER NOT NULL DEFAULT 0,
    last_interaction_at TIMESTAMPTZ,
    observation TEXT,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT customer_loyalty_status_check CHECK (status IN ('active', 'inactive', 'deleted')),
    CONSTRAINT customer_loyalty_points_check CHECK (points >= 0)
);