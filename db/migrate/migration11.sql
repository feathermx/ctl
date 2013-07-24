BEGIN;

ALTER TABLE shops
	ALTER COLUMN has_loading_area DROP NOT NULL,
	ALTER COLUMN has_loading_area SET DEFAULT 0,
	ALTER COLUMN loading_area_type DROP NOT NULL
;

ALTER TABLE parking_restrictions
	ADD COLUMN parking_restriction_type VARCHAR(1) NOT NULL
;

ALTER TABLE deliveries
	ADD COLUMN distance_to_shop DOUBLE PRECISION,
    ADD COLUMN is_out_of_segment INTEGER,
    ADD COLUMN shops_served INTEGER
;


COMMIT;