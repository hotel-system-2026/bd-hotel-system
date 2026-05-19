-- Removes foreign key constraints for security module

ALTER TABLE security."user" DROP CONSTRAINT IF EXISTS fk_user_person;
ALTER TABLE security."view" DROP CONSTRAINT IF EXISTS fk_view_module;
ALTER TABLE security.user_role DROP CONSTRAINT IF EXISTS fk_user_role_user;
ALTER TABLE security.user_role DROP CONSTRAINT IF EXISTS fk_user_role_role;
ALTER TABLE security.role_permission DROP CONSTRAINT IF EXISTS fk_role_permission_role;
ALTER TABLE security.role_permission DROP CONSTRAINT IF EXISTS fk_role_permission_permission;
ALTER TABLE security.module_view DROP CONSTRAINT IF EXISTS fk_module_view_module;
ALTER TABLE security.module_view DROP CONSTRAINT IF EXISTS fk_module_view_view;
