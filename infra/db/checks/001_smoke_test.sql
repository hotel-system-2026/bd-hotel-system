-- Smoke test to validate canonical + volumetric seeds
DO $$
DECLARE
	v_roles int;
	v_comp int;
	v_clients int;
 v_room_types int;
 v_branches int;
 v_products int;
 v_promos int;
 v_people int;
BEGIN
	SELECT count(*) INTO v_roles FROM security.role;
	IF v_roles < 3 THEN
		RAISE EXCEPTION 'Smoke test failure: expected >=3 roles, found %', v_roles;
	END IF;

	SELECT count(*) INTO v_comp FROM parameterization.company;
	IF v_comp < 3 THEN
		RAISE EXCEPTION 'Smoke test failure: expected >=3 companies, found %', v_comp;
	END IF;

	SELECT count(*) INTO v_clients FROM parameterization.client;
	IF v_clients < 10 THEN
		RAISE EXCEPTION 'Smoke test failure: expected >=10 clients, found %', v_clients;
	END IF;

	SELECT count(*) INTO v_room_types FROM distribution.room_type;
	IF v_room_types < 1 THEN
		RAISE EXCEPTION 'Smoke test failure: expected >=1 room_type, found %', v_room_types;
	END IF;

	SELECT count(*) INTO v_branches FROM distribution.branch;
	IF v_branches < 1 THEN
		RAISE EXCEPTION 'Smoke test failure: expected >=1 branch, found %', v_branches;
	END IF;

	SELECT count(*) INTO v_products FROM inventory.product;
	IF v_products < 1 THEN
		RAISE EXCEPTION 'Smoke test failure: expected >=1 product, found %', v_products;
	END IF;

	SELECT count(*) INTO v_promos FROM notification.promotion;
	IF v_promos < 1 THEN
		RAISE EXCEPTION 'Smoke test failure: expected >=1 promotion, found %', v_promos;
	END IF;

	SELECT count(*) INTO v_people FROM security.person;
	IF v_people < 1 THEN
		RAISE EXCEPTION 'Smoke test failure: expected >=1 person, found %', v_people;
	END IF;
END
$$;

-- If this script finishes without error, smoke test passed
