
CREATE SEQUENCE public.languages_id_seq;

CREATE TABLE public.languages (
                id BIGINT NOT NULL DEFAULT nextval('public.languages_id_seq'),
                name VARCHAR(100) NOT NULL,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT languages_pk PRIMARY KEY (id)
);


ALTER SEQUENCE public.languages_id_seq OWNED BY public.languages.id;

CREATE SEQUENCE public.countries_id_seq;

CREATE TABLE public.countries (
                id BIGINT NOT NULL DEFAULT nextval('public.countries_id_seq'),
                city_count INTEGER DEFAULT 0 NOT NULL,
                name VARCHAR(100) NOT NULL,
                extension VARCHAR(10),
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT countries_pk PRIMARY KEY (id)
);


ALTER SEQUENCE public.countries_id_seq OWNED BY public.countries.id;

CREATE SEQUENCE public.cities_id_seq;

CREATE TABLE public.cities (
                id BIGINT NOT NULL DEFAULT nextval('public.cities_id_seq'),
                active_count INTEGER DEFAULT 0,
                country_id BIGINT NOT NULL,
                language_id BIGINT,
                name VARCHAR(100) NOT NULL,
                city_time_zone VARCHAR(150),
                population INTEGER,
                population_density DOUBLE PRECISION,
                area DOUBLE PRECISION,
                us_exchange_rate DOUBLE PRECISION,
                gdp DOUBLE PRECISION,
                big_mac_index DOUBLE PRECISION,
                lat DOUBLE PRECISION NOT NULL,
                lng DOUBLE PRECISION NOT NULL,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT cities_pk PRIMARY KEY (id)
);


ALTER SEQUENCE public.cities_id_seq OWNED BY public.cities.id;

CREATE SEQUENCE public.kms_id_seq;

CREATE TABLE public.kms (
                id BIGINT NOT NULL DEFAULT nextval('public.kms_id_seq'),
                is_active INTEGER DEFAULT 0,
                tracks_count INTEGER DEFAULT 0 NOT NULL,
                traffic_counts_count INTEGER DEFAULT 0 NOT NULL,
                traffic_disruptions_count INTEGER DEFAULT 0 NOT NULL,
                street_data_count INTEGER DEFAULT 0 NOT NULL,
                parking_restrictions_count INTEGER DEFAULT 0 NOT NULL,
                shops_count INTEGER DEFAULT 0 NOT NULL,
                deliveries_count INTEGER DEFAULT 0 NOT NULL,
                public_meter_length DOUBLE PRECISION DEFAULT 0,
                dedicated_meter_length DOUBLE PRECISION DEFAULT 0,
                peak_deliveries INTEGER DEFAULT 0,
                peak_delivery_hour TIME,
                peak_disruptions INTEGER DEFAULT 0,
                peak_disruption_hour TIME,
                peak_traffic INTEGER DEFAULT 0,
                peak_traffic_hour TIME,
                min_disruption_time TIME,
                max_disruption_time TIME,
                min_delivery_time TIME,
                max_delivery_time TIME,
                chart_start_time TIME,
                chart_end_time TIME,
                city_id BIGINT NOT NULL,
                name VARCHAR(100) NOT NULL,
                description TEXT,
                comments TEXT,
                lat DOUBLE PRECISION NOT NULL,
                lng DOUBLE PRECISION NOT NULL,
                street_lat DOUBLE PRECISION,
                street_lng DOUBLE PRECISION,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT kms_pk PRIMARY KEY (id)
);


ALTER SEQUENCE public.kms_id_seq OWNED BY public.kms.id;

CREATE SEQUENCE public.shop_totals_id_seq;

CREATE TABLE public.shop_totals (
                id BIGINT NOT NULL DEFAULT nextval('public.shop_totals_id_seq'),
                km_id BIGINT NOT NULL,
                shop_type VARCHAR(10) NOT NULL,
                total INTEGER NOT NULL,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT shop_totals_pk PRIMARY KEY (id)
);


ALTER SEQUENCE public.shop_totals_id_seq OWNED BY public.shop_totals.id;

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

CREATE SEQUENCE public.blocks_id_seq;

CREATE TABLE public.blocks (
                id BIGINT NOT NULL DEFAULT nextval('public.blocks_id_seq'),
                km_id BIGINT NOT NULL,
                research_id BIGINT NOT NULL,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT blocks_pk PRIMARY KEY (id)
);


ALTER SEQUENCE public.blocks_id_seq OWNED BY public.blocks.id;

CREATE SEQUENCE public.streets_id_seq;

CREATE TABLE public.streets (
                id BIGINT NOT NULL DEFAULT nextval('public.streets_id_seq'),
                km_id BIGINT NOT NULL,
                block_id BIGINT NOT NULL,
                research_id BIGINT NOT NULL,
                public_meter_length DOUBLE PRECISION DEFAULT 0,
                dedicated_meter_length DOUBLE PRECISION DEFAULT 0,
                track_count INTEGER DEFAULT 0,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT streets_pk PRIMARY KEY (id)
);


ALTER SEQUENCE public.streets_id_seq OWNED BY public.streets.id;

CREATE SEQUENCE public.traffic_disruptions_id_seq;

CREATE TABLE public.traffic_disruptions (
                id BIGINT NOT NULL DEFAULT nextval('public.traffic_disruptions_id_seq'),
                km_id BIGINT NOT NULL,
                street_id BIGINT NOT NULL,
                source VARCHAR(1) NOT NULL,
                vehicle_type VARCHAR(30) NOT NULL,
                length_type INTEGER,
                started_at TIMESTAMP NOT NULL,
                ended_at TIMESTAMP NOT NULL,
                more_than_five_secs INTEGER DEFAULT 0 NOT NULL,
                disruption_type VARCHAR(1),
                blocked_lanes DOUBLE PRECISION,
                vehicles_affected INTEGER,
                slowed_or_stop VARCHAR(1),
                notes TEXT,
                lat DOUBLE PRECISION,
                lng DOUBLE PRECISION,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT traffic_disruptions_pk PRIMARY KEY (id)
);


ALTER SEQUENCE public.traffic_disruptions_id_seq OWNED BY public.traffic_disruptions.id;

CREATE SEQUENCE public.parking_restrictions_id_seq;

CREATE TABLE public.parking_restrictions (
                id BIGINT NOT NULL DEFAULT nextval('public.parking_restrictions_id_seq'),
                km_id BIGINT NOT NULL,
                street_id BIGINT NOT NULL,
                day_of_week INTEGER NOT NULL,
                starts_at TIME,
                ends_at TIME,
                parking_duration DOUBLE PRECISION,
                notes TEXT,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT parking_restrictions_pk PRIMARY KEY (id)
);


ALTER SEQUENCE public.parking_restrictions_id_seq OWNED BY public.parking_restrictions.id;

CREATE SEQUENCE public.street_data_id_seq;

CREATE TABLE public.street_data (
                id BIGINT NOT NULL DEFAULT nextval('public.street_data_id_seq'),
                km_id BIGINT NOT NULL,
                street_id BIGINT NOT NULL,
                way INTEGER NOT NULL,
                driving_lanes INTEGER NOT NULL,
                bike_lanes INTEGER NOT NULL,
                parking_lanes INTEGER NOT NULL,
                public_transport_lanes INTEGER DEFAULT 0 NOT NULL,
                extra_crosswalks INTEGER DEFAULT 0 NOT NULL,
                width_of_sidewalks DOUBLE PRECISION NOT NULL,
                transport_stop VARCHAR(10),
                has_loading_area INTEGER DEFAULT 0 NOT NULL,
                loading_area_length DOUBLE PRECISION,
                has_parking_area INTEGER DEFAULT 0 NOT NULL,
                parking_area_length DOUBLE PRECISION,
                parking_payment VARCHAR(1),
                notes TEXT,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT street_data_pk PRIMARY KEY (id)
);


ALTER SEQUENCE public.street_data_id_seq OWNED BY public.street_data.id;

CREATE SEQUENCE public.traffic_counts_id_seq;

CREATE TABLE public.traffic_counts (
                id BIGINT NOT NULL DEFAULT nextval('public.traffic_counts_id_seq'),
                km_id BIGINT NOT NULL,
                street_id BIGINT NOT NULL,
                started_at TIMESTAMP NOT NULL,
                ended_at TIMESTAMP NOT NULL,
                cars INTEGER DEFAULT 0 NOT NULL,
                taxis INTEGER DEFAULT 0 NOT NULL,
                pickup_trucks INTEGER DEFAULT 0 NOT NULL,
                articulated_trucks INTEGER DEFAULT 0 NOT NULL,
                rigid_trucks INTEGER DEFAULT 0 NOT NULL,
                vans INTEGER DEFAULT 0 NOT NULL,
                buses INTEGER DEFAULT 0 NOT NULL,
                bikes INTEGER DEFAULT 0 NOT NULL,
                motorbikes INTEGER DEFAULT 0 NOT NULL,
                pedestrians INTEGER DEFAULT 0 NOT NULL,
                traffic_total INTEGER DEFAULT 0,
                notes TEXT,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT traffic_counts_pk PRIMARY KEY (id)
);


ALTER SEQUENCE public.traffic_counts_id_seq OWNED BY public.traffic_counts.id;

CREATE SEQUENCE public.shops_id_seq;

CREATE TABLE public.shops (
                id BIGINT NOT NULL DEFAULT nextval('public.shops_id_seq'),
                km_id BIGINT NOT NULL,
                street_id BIGINT NOT NULL,
                shop_id VARCHAR(100) NOT NULL,
                registered_at TIMESTAMP NOT NULL,
                shop_type VARCHAR(10) NOT NULL,
                name VARCHAR(100) NOT NULL,
                front_length DOUBLE PRECISION,
                starting_floor INTEGER,
                total_floors INTEGER DEFAULT 1,
                has_loading_area INTEGER NOT NULL,
                loading_area_type INTEGER NOT NULL,
                notes TEXT,
                lat DOUBLE PRECISION,
                lng DOUBLE PRECISION,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT shops_pk PRIMARY KEY (id)
);


ALTER SEQUENCE public.shops_id_seq OWNED BY public.shops.id;

CREATE SEQUENCE public.deliveries_id_seq;

CREATE TABLE public.deliveries (
                id BIGINT NOT NULL DEFAULT nextval('public.deliveries_id_seq'),
                km_id BIGINT NOT NULL,
                street_id BIGINT NOT NULL,
                shop_id BIGINT NOT NULL,
                started_at TIMESTAMP NOT NULL,
                ended_at TIMESTAMP NOT NULL,
                vehicle_type VARCHAR(30) NOT NULL,
                delivering_company VARCHAR(50) NOT NULL,
                product_delivered VARCHAR(50) NOT NULL,
                refrigerated_vehicle INTEGER DEFAULT 0 NOT NULL,
                boxes_delivered INTEGER,
                delivery_type VARCHAR(1) NOT NULL,
                with_equipment INTEGER DEFAULT 0 NOT NULL,
                number_of_trips INTEGER DEFAULT 1,
                notes TEXT,
                lat DOUBLE PRECISION,
                lng DOUBLE PRECISION,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT deliveries_pk PRIMARY KEY (id)
);


ALTER SEQUENCE public.deliveries_id_seq OWNED BY public.deliveries.id;

CREATE SEQUENCE public.tracks_id_seq;

CREATE TABLE public.tracks (
                id BIGINT NOT NULL DEFAULT nextval('public.tracks_id_seq'),
                km_id BIGINT NOT NULL,
                street_id BIGINT,
                lat DOUBLE PRECISION NOT NULL,
                lng DOUBLE PRECISION NOT NULL,
                tracked_at TIMESTAMP NOT NULL,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT tracks_pk PRIMARY KEY (id)
);


ALTER SEQUENCE public.tracks_id_seq OWNED BY public.tracks.id;

CREATE SEQUENCE public.upload_configs_id_seq;

CREATE TABLE public.upload_configs (
                id BIGINT NOT NULL DEFAULT nextval('public.upload_configs_id_seq'),
                max_size INTEGER NOT NULL,
                identity VARCHAR(100) NOT NULL,
                allowed_extensions TEXT NOT NULL,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT upload_configs_pk PRIMARY KEY (id)
);


ALTER SEQUENCE public.upload_configs_id_seq OWNED BY public.upload_configs.id;

CREATE SEQUENCE public.users_id_seq;

CREATE TABLE public.users (
                id BIGINT NOT NULL DEFAULT nextval('public.users_id_seq'),
                city_id BIGINT,
                name VARCHAR(100) NOT NULL,
                last_names VARCHAR(100) NOT NULL,
                mail VARCHAR(50) NOT NULL,
                password VARCHAR(40) NOT NULL,
                list_perms INTEGER DEFAULT 0 NOT NULL,
                add_perms INTEGER DEFAULT 0 NOT NULL,
                edit_perms INTEGER DEFAULT 0 NOT NULL,
                delete_perms INTEGER NOT NULL,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT users_pk PRIMARY KEY (id)
);


ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;

CREATE SEQUENCE public.uploads_id_seq;

CREATE TABLE public.uploads (
                id BIGINT NOT NULL DEFAULT nextval('public.uploads_id_seq'),
                upload_config_id BIGINT NOT NULL,
                user_id BIGINT NOT NULL,
                token TEXT NOT NULL,
                secret TEXT NOT NULL,
                extension VARCHAR(10) NOT NULL,
                expires_at TIMESTAMP NOT NULL,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT uploads_pk PRIMARY KEY (id)
);


ALTER SEQUENCE public.uploads_id_seq OWNED BY public.uploads.id;

CREATE SEQUENCE public.tokens_id_seq;

CREATE TABLE public.tokens (
                id BIGINT NOT NULL DEFAULT nextval('public.tokens_id_seq'),
                identity INTEGER NOT NULL,
                user_id BIGINT NOT NULL,
                token TEXT NOT NULL,
                secret TEXT NOT NULL,
                expires_at TIMESTAMP NOT NULL,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT tokens_pk PRIMARY KEY (id)
);


ALTER SEQUENCE public.tokens_id_seq OWNED BY public.tokens.id;

ALTER TABLE public.cities ADD CONSTRAINT languages_cities_fk
FOREIGN KEY (language_id)
REFERENCES public.languages (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.cities ADD CONSTRAINT countries_cities_fk
FOREIGN KEY (country_id)
REFERENCES public.countries (id)
ON DELETE CASCADE
ON UPDATE CASCADE
NOT DEFERRABLE;

ALTER TABLE public.users ADD CONSTRAINT cities_users_fk
FOREIGN KEY (city_id)
REFERENCES public.cities (id)
ON DELETE SET NULL
ON UPDATE SET NULL
NOT DEFERRABLE;

ALTER TABLE public.kms ADD CONSTRAINT cities_blocks_fk
FOREIGN KEY (city_id)
REFERENCES public.cities (id)
ON DELETE CASCADE
ON UPDATE CASCADE
NOT DEFERRABLE;

ALTER TABLE public.tracks ADD CONSTRAINT blocks_tracks_fk
FOREIGN KEY (km_id)
REFERENCES public.kms (id)
ON DELETE CASCADE
ON UPDATE CASCADE
NOT DEFERRABLE;

ALTER TABLE public.shops ADD CONSTRAINT kms_shops_fk
FOREIGN KEY (km_id)
REFERENCES public.kms (id)
ON DELETE CASCADE
ON UPDATE CASCADE
NOT DEFERRABLE;

ALTER TABLE public.traffic_counts ADD CONSTRAINT kms_traffic_counts_fk
FOREIGN KEY (km_id)
REFERENCES public.kms (id)
ON DELETE CASCADE
ON UPDATE CASCADE
NOT DEFERRABLE;

ALTER TABLE public.streets ADD CONSTRAINT kms_streets_fk
FOREIGN KEY (km_id)
REFERENCES public.kms (id)
ON DELETE CASCADE
ON UPDATE CASCADE
NOT DEFERRABLE;

ALTER TABLE public.blocks ADD CONSTRAINT kms_blocks_fk
FOREIGN KEY (km_id)
REFERENCES public.kms (id)
ON DELETE CASCADE
ON UPDATE CASCADE
NOT DEFERRABLE;

ALTER TABLE public.parking_restrictions ADD CONSTRAINT kms_parking_restrictions_fk
FOREIGN KEY (km_id)
REFERENCES public.kms (id)
ON DELETE CASCADE
ON UPDATE CASCADE
NOT DEFERRABLE;

ALTER TABLE public.traffic_disruptions ADD CONSTRAINT kms_traffic_disruptions_fk
FOREIGN KEY (km_id)
REFERENCES public.kms (id)
ON DELETE CASCADE
ON UPDATE CASCADE
NOT DEFERRABLE;

ALTER TABLE public.street_data ADD CONSTRAINT kms_street_data_fk
FOREIGN KEY (km_id)
REFERENCES public.kms (id)
ON DELETE CASCADE
ON UPDATE CASCADE
NOT DEFERRABLE;

ALTER TABLE public.deliveries ADD CONSTRAINT kms_deliveries_fk
FOREIGN KEY (km_id)
REFERENCES public.kms (id)
ON DELETE CASCADE
ON UPDATE CASCADE
NOT DEFERRABLE;

ALTER TABLE public.deliveries_disruptions ADD CONSTRAINT kms_deliveries_disruptions_fk
FOREIGN KEY (km_id)
REFERENCES public.kms (id)
ON DELETE CASCADE
ON UPDATE CASCADE
NOT DEFERRABLE;

ALTER TABLE public.traffic_count_totals ADD CONSTRAINT kms_traffic_count_totals_fk
FOREIGN KEY (km_id)
REFERENCES public.kms (id)
ON DELETE CASCADE
ON UPDATE CASCADE
NOT DEFERRABLE;

ALTER TABLE public.shop_totals ADD CONSTRAINT kms_shop_totals_fk
FOREIGN KEY (km_id)
REFERENCES public.kms (id)
ON DELETE CASCADE
ON UPDATE CASCADE
NOT DEFERRABLE;

ALTER TABLE public.streets ADD CONSTRAINT blocks_streets_fk
FOREIGN KEY (block_id)
REFERENCES public.blocks (id)
ON DELETE CASCADE
ON UPDATE CASCADE
NOT DEFERRABLE;

ALTER TABLE public.shops ADD CONSTRAINT streets_shops_fk
FOREIGN KEY (street_id)
REFERENCES public.streets (id)
ON DELETE CASCADE
ON UPDATE CASCADE
NOT DEFERRABLE;

ALTER TABLE public.traffic_counts ADD CONSTRAINT streets_traffic_counts_fk
FOREIGN KEY (street_id)
REFERENCES public.streets (id)
ON DELETE CASCADE
ON UPDATE CASCADE
NOT DEFERRABLE;

ALTER TABLE public.street_data ADD CONSTRAINT streets_street_segments_fk
FOREIGN KEY (street_id)
REFERENCES public.streets (id)
ON DELETE CASCADE
ON UPDATE CASCADE
NOT DEFERRABLE;

ALTER TABLE public.parking_restrictions ADD CONSTRAINT streets_parking_restrictions_fk
FOREIGN KEY (street_id)
REFERENCES public.streets (id)
ON DELETE CASCADE
ON UPDATE CASCADE
NOT DEFERRABLE;

ALTER TABLE public.traffic_disruptions ADD CONSTRAINT streets_traffic_disruptions_fk
FOREIGN KEY (street_id)
REFERENCES public.streets (id)
ON DELETE CASCADE
ON UPDATE CASCADE
NOT DEFERRABLE;

ALTER TABLE public.deliveries ADD CONSTRAINT streets_deliveries_fk
FOREIGN KEY (street_id)
REFERENCES public.streets (id)
ON DELETE CASCADE
ON UPDATE CASCADE
NOT DEFERRABLE;

ALTER TABLE public.tracks ADD CONSTRAINT streets_tracks_fk
FOREIGN KEY (street_id)
REFERENCES public.streets (id)
ON DELETE SET NULL
ON UPDATE SET NULL
NOT DEFERRABLE;

ALTER TABLE public.deliveries ADD CONSTRAINT shops_deliveries_fk
FOREIGN KEY (shop_id)
REFERENCES public.shops (id)
ON DELETE CASCADE
ON UPDATE CASCADE
NOT DEFERRABLE;

ALTER TABLE public.uploads ADD CONSTRAINT upload_configs_uploads_fk
FOREIGN KEY (upload_config_id)
REFERENCES public.upload_configs (id)
ON DELETE CASCADE
ON UPDATE CASCADE
NOT DEFERRABLE;

ALTER TABLE public.tokens ADD CONSTRAINT users_tokens_fk
FOREIGN KEY (user_id)
REFERENCES public.users (id)
ON DELETE CASCADE
ON UPDATE CASCADE
NOT DEFERRABLE;

ALTER TABLE public.uploads ADD CONSTRAINT users_uploads_fk
FOREIGN KEY (user_id)
REFERENCES public.users (id)
ON DELETE CASCADE
ON UPDATE CASCADE
NOT DEFERRABLE;