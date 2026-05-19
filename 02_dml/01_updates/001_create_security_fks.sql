-- Adds foreign key constraints for security module

ALTER TABLE security."user"
    ADD CONSTRAINT fk_user_person FOREIGN KEY (person_id) REFERENCES security.person(id);

ALTER TABLE security."view"
    ADD CONSTRAINT fk_view_module FOREIGN KEY (module_id) REFERENCES security.module(id);

ALTER TABLE security.user_role
    ADD CONSTRAINT fk_user_role_user FOREIGN KEY (user_id) REFERENCES security."user"(id),
    ADD CONSTRAINT fk_user_role_role FOREIGN KEY (role_id) REFERENCES security.role(id);

ALTER TABLE security.role_permission
    ADD CONSTRAINT fk_role_permission_role FOREIGN KEY (role_id) REFERENCES security.role(id),
    ADD CONSTRAINT fk_role_permission_permission FOREIGN KEY (permission_id) REFERENCES security.permission(id);

ALTER TABLE security.module_view
    ADD CONSTRAINT fk_module_view_module FOREIGN KEY (module_id) REFERENCES security.module(id),
    ADD CONSTRAINT fk_module_view_view FOREIGN KEY (view_id) REFERENCES security."view"(id);
