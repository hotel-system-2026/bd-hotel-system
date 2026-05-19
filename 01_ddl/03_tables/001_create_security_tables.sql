-- ============================================================================
-- Security Module Tables
-- Schema: security
-- Module: Security & Authorization
-- Description: Core security tables for user management, roles, permissions, and RBAC
-- ============================================================================

-- ==============================================
-- Table: person
-- Description: Base person data (used for employees and clients)
-- ==============================================
CREATE TABLE security.person (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    document_type VARCHAR(50) NOT NULL,
    document_number VARCHAR(50) NOT NULL UNIQUE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT person_status_check CHECK (status IN ('active', 'inactive', 'deleted'))
);

-- ==============================================
-- Table: role
-- Description: System roles for RBAC
-- ==============================================
CREATE TABLE security.role (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT role_status_check CHECK (status IN ('active', 'inactive', 'deleted'))
);

-- ==============================================
-- Table: permission
-- Description: Granular permissions in the system
-- ==============================================
CREATE TABLE security.permission (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    action VARCHAR(100) NOT NULL,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT permission_status_check CHECK (status IN ('active', 'inactive', 'deleted'))
);

-- ==============================================
-- Table: module
-- Description: Application modules/features
-- ==============================================
CREATE TABLE security.module (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    base_path VARCHAR(255) NOT NULL,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT module_status_check CHECK (status IN ('active', 'inactive', 'deleted'))
);

-- ==============================================
-- Table: user
-- Description: System users linked to persons
-- ==============================================
CREATE TABLE security."user" (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    person_id UUID NOT NULL,
    username VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    last_access_at TIMESTAMPTZ,
    is_blocked BOOLEAN DEFAULT FALSE,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT user_status_check CHECK (status IN ('active', 'inactive', 'deleted'))
);

-- ==============================================
-- Table: view
-- Description: Views/pages within modules
-- ==============================================
CREATE TABLE security."view" (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    module_id UUID NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    route VARCHAR(255) NOT NULL,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT view_status_check CHECK (status IN ('active', 'inactive', 'deleted')),
    CONSTRAINT unique_view_per_module UNIQUE(module_id, route)
);

-- ==============================================
-- Table: user_role
-- Description: Junction table for user-role relationships (M:M)
-- ==============================================
CREATE TABLE security.user_role (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    role_id UUID NOT NULL,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT user_role_status_check CHECK (status IN ('active', 'inactive', 'deleted')),
    CONSTRAINT unique_user_role UNIQUE(user_id, role_id) WHERE status != 'deleted'
);

-- ==============================================
-- Table: role_permission
-- Description: Junction table for role-permission relationships (M:M)
-- ==============================================
CREATE TABLE security.role_permission (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_id UUID NOT NULL,
    permission_id UUID NOT NULL,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT role_permission_status_check CHECK (status IN ('active', 'inactive', 'deleted')),
    CONSTRAINT unique_role_permission UNIQUE(role_id, permission_id) WHERE status != 'deleted'
);

-- ==============================================
-- Table: module_view
-- Description: Junction table for module-view relationships (M:M)
-- ==============================================
CREATE TABLE security.module_view (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    module_id UUID NOT NULL,
    view_id UUID NOT NULL,
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by VARCHAR(100),
    updated_at TIMESTAMPTZ,
    deleted_by VARCHAR(100),
    deleted_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'active' NOT NULL,
    CONSTRAINT module_view_status_check CHECK (status IN ('active', 'inactive', 'deleted')),
    CONSTRAINT unique_module_view UNIQUE(module_id, view_id) WHERE status != 'deleted'
);