BEGIN;

ALTER TABLE deliveries
	ADD COLUMN delivery_key VARCHAR(30)
;

ALTER TABLE traffic_disruptions
	ADD COLUMN delivery_key VARCHAR(30)
;

ALTER TABLE traffic_disruptions
	ADD COLUMN entered_car INTEGER DEFAULT 0
;


END;