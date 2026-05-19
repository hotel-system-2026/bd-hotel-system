-- ============================================================================
-- Maintenance Module Tables
-- Schema: maintenance
-- Module: Maintenance
-- Description: Maintenance tables for room maintenance, usage, remodeling and dashboard
-- ============================================================================

-- ==============================================
-- Table: room_maintenance
-- ==============================================
CREATE TABLE maintenance.room_maintenance (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    room_id UUID NOT NULL,
    employee_id UUID NOT NULL,
    maintenance_type VARCHAR(100) NOT NULL,
    start_date TIMESTAMPTZ NOT NULL,
    end_date TIMESTAMPTZ,
    maintenance_status VARCHAR(50) NOT NULL,
    observation TEXT,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT room_maintenance_status_check CHECK (status IN ('active', 'inactive', 'deleted')),
    CONSTRAINT room_maintenance_date_check CHECK (start_date <= end_date)
);

-- ==============================================
-- Table: maintenance_usage
-- ==============================================
CREATE TABLE maintenance.maintenance_usage (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    room_maintenance_id UUID NOT NULL,
    usage_reason TEXT NOT NULL,
    activity_detail TEXT,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT maintenance_usage_status_check CHECK (status IN ('active', 'inactive', 'deleted'))
);

-- ==============================================
-- Table: maintenance_remodeling
-- ==============================================
CREATE TABLE maintenance.maintenance_remodeling (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    room_maintenance_id UUID NOT NULL,
    remodeling_description TEXT,
    estimated_budget NUMERIC(14,2),
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT maintenance_remodeling_status_check CHECK (status IN ('active', 'inactive', 'deleted')),
    CONSTRAINT maintenance_remodeling_budget_check CHECK (estimated_budget IS NULL OR estimated_budget >= 0)
);

-- ==============================================
-- Table: maintenance_dashboard
-- ==============================================
CREATE TABLE maintenance.maintenance_dashboard (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    branch_id UUID NOT NULL,
    total_rooms INTEGER NOT NULL DEFAULT 0,
    rooms_available INTEGER NOT NULL DEFAULT 0,
    rooms_occupied INTEGER NOT NULL DEFAULT 0,
    rooms_under_maintenance INTEGER NOT NULL DEFAULT 0,
    cut_off_date DATE NOT NULL,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT maintenance_dashboard_status_check CHECK (status IN ('active', 'inactive', 'deleted')),
    CONSTRAINT maintenance_dashboard_counts_check CHECK (total_rooms >= 0 AND rooms_available >= 0 AND rooms_occupied >= 0 AND rooms_under_maintenance >= 0)
);
