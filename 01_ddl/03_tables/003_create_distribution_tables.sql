-- ============================================================================
-- Distribution Module Tables
-- Schema: distribution
-- Module: Distribution
-- Description: Hotel distribution tables for branches, room types, statuses, and rooms
-- ============================================================================

-- ==============================================
-- Table: room_type
-- ==============================================
CREATE TABLE distribution.room_type (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    base_capacity INTEGER NOT NULL,
    max_capacity INTEGER NOT NULL,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT room_type_status_check CHECK (status IN ('active', 'inactive', 'deleted')),
    CONSTRAINT room_type_capacity_check CHECK (base_capacity > 0 AND max_capacity >= base_capacity)
);

-- ==============================================
-- Table: room_status
-- ==============================================
CREATE TABLE distribution.room_status (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    allows_reservation BOOLEAN DEFAULT FALSE,
    allows_check_in BOOLEAN DEFAULT FALSE,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT room_status_check CHECK (status IN ('active', 'inactive', 'deleted'))
);

-- ==============================================
-- Table: branch
-- ==============================================
CREATE TABLE distribution.branch (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL,
    name VARCHAR(150) NOT NULL,
    address VARCHAR(255),
    city VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT branch_status_check CHECK (status IN ('active', 'inactive', 'deleted'))
);

-- ==============================================
-- Table: room
-- ==============================================
CREATE TABLE distribution.room (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    branch_id UUID NOT NULL,
    room_type_id UUID NOT NULL,
    room_status_id UUID NOT NULL,
    number VARCHAR(50) NOT NULL,
    floor INTEGER,
    capacity INTEGER NOT NULL,
    description TEXT,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT room_status_check CHECK (status IN ('active', 'inactive', 'deleted')),
    CONSTRAINT room_capacity_check CHECK (capacity > 0)
);

CREATE UNIQUE INDEX idx_room_unique_per_branch
    ON distribution.room (branch_id, number)
    WHERE status != 'deleted';