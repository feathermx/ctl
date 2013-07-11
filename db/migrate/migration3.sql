BEGIN;

ALTER TABLE kms 
	ADD COLUMN is_active INTEGER DEFAULT 0,
	ADD COLUMN public_meter_length INTEGER DEFAULT 0,
    ADD COLUMN dedicated_meter_length INTEGER DEFAULT 0,
    ADD COLUMN peak_deliveries INTEGER DEFAULT 0,
    ADD COLUMN peak_delivery_hour TIME,
    ADD COLUMN peak_disruptions INTEGER DEFAULT 0,
    ADD COLUMN peak_disruption_hour TIME,
    ADD COLUMN peak_traffic INTEGER DEFAULT 0,
	ADD COLUMN peak_traffic_hour TIME,
    ADD COLUMN min_disruption_time TIME,
    ADD COLUMN max_disruption_time TIME,
    ADD COLUMN min_delivery_time TIME,
    ADD COLUMN max_delivery_time TIME,
    ADD COLUMN chart_start_time TIME,
    ADD COLUMN chart_end_time TIME,
	ADD COLUMN street_lat DOUBLE PRECISION,
    ADD COLUMN street_lng DOUBLE PRECISION
;

ALTER TABLE cities ADD COLUMN active_count INTEGER DEFAULT 0;

ALTER TABLE tracks
	ADD COLUMN street_id BIGINT
;
ALTER TABLE public.tracks ADD CONSTRAINT streets_tracks_fk
FOREIGN KEY (street_id)
REFERENCES public.streets (id)
ON DELETE SET NULL
ON UPDATE SET NULL
NOT DEFERRABLE;

ALTER TABLE shops
	ADD COLUMN lat DOUBLE PRECISION,
    ADD COLUMN lng DOUBLE PRECISION
;

ALTER TABLE deliveries
	ADD COLUMN lat DOUBLE PRECISION,
	ADD COLUMN lng DOUBLE PRECISION
;

ALTER TABLE streets
	ADD COLUMN public_meter_length INTEGER,
    ADD COLUMN dedicated_meter_length INTEGER,
    ADD COLUMN track_count INTEGER DEFAULT 0
;

CREATE SEQUENCE public.deliveries_disruptions_id_seq;
CREATE TABLE public.deliveries_disruptions (
                id BIGINT NOT NULL DEFAULT nextval('public.deliveries_disruptions_id_seq'),
                km_id BIGINT NOT NULL,
                hour TIME NOT NULL,
                disruption_count INTEGER DEFAULT 0,
                delivery_count INTEGER DEFAULT 0,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT deliveries_disruptions_pk PRIMARY KEY (id)
);
ALTER SEQUENCE public.deliveries_disruptions_id_seq OWNED BY public.deliveries_disruptions.id;
ALTER TABLE public.deliveries_disruptions ADD CONSTRAINT kms_deliveries_disruptions_fk
FOREIGN KEY (km_id)
REFERENCES public.kms (id)
ON DELETE CASCADE
ON UPDATE CASCADE
NOT DEFERRABLE;

CREATE SEQUENCE public.traffic_count_totals_id_seq;
CREATE TABLE public.traffic_count_totals (
                id BIGINT NOT NULL DEFAULT nextval('public.traffic_count_totals_id_seq'),
                km_id BIGINT NOT NULL,
                
				morning_cars INTEGER NOT NULL,
                evening_cars INTEGER NOT NULL,
                noon_cars INTEGER NOT NULL,

                morning_taxis INTEGER NOT NULL,
                evening_taxis INTEGER NOT NULL,
                noon_taxis INTEGER NOT NULL,

                morning_pickup_trucks INTEGER NOT NULL,
                evening_pickup_trucks INTEGER NOT NULL,
                noon_pickup_trucks INTEGER NOT NULL,

                morning_articulated_trucks INTEGER NOT NULL,
                evening_articulated_trucks INTEGER NOT NULL,
				noon_articulated_trucks INTEGER NOT NULL,
				
                morning_rigid_trucks INTEGER NOT NULL,
                evening_rigid_trucks INTEGER NOT NULL,
                noon_rigid_trucks INTEGER NOT NULL,
				
                morning_vans INTEGER NOT NULL,
                evening_vans INTEGER NOT NULL,
                noon_vans INTEGER NOT NULL,
				
                morning_buses INTEGER NOT NULL,
                evening_buses INTEGER NOT NULL,
                noon_buses INTEGER NOT NULL,
				
                morning_bikes INTEGER NOT NULL,
                evening_bikes INTEGER NOT NULL,
                noon_bikes INTEGER NOT NULL,

                morning_motorbikes INTEGER NOT NULL,
                evening_motorbikes INTEGER NOT NULL,
                noon_motorbikes INTEGER NOT NULL,
				
                morning_pedestrians INTEGER NOT NULL,
                evening_pedestrians INTEGER NOT NULL,
                noon_pedestrians INTEGER NOT NULL,
				
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT traffic_count_totals_pk PRIMARY KEY (id)
);
ALTER SEQUENCE public.traffic_count_totals_id_seq OWNED BY public.traffic_count_totals.id;

ALTER TABLE traffic_counts
	ADD COLUMN traffic_total INTEGER DEFAULT 0
;

ALTER TABLE traffic_disruptions
	ADD COLUMN length_type INTEGER,
	ADD COLUMN lat DOUBLE PRECISION,
    ADD COLUMN lng DOUBLE PRECISION
;

COMMIT;
