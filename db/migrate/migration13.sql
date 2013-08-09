BEGIN;

CREATE SEQUENCE public.delivery_totals_id_seq;
CREATE TABLE public.delivery_totals (
                id BIGINT NOT NULL DEFAULT nextval('public.delivery_totals_id_seq'),
                km_id BIGINT NOT NULL,
                hour TIME NOT NULL,
                total_sun INTEGER DEFAULT 0 NOT NULL,
                total_mon INTEGER DEFAULT 0 NOT NULL,
                total_tue INTEGER DEFAULT 0 NOT NULL,
                total_wed INTEGER DEFAULT 0 NOT NULL,
                total_thu INTEGER DEFAULT 0 NOT NULL,
                total_fri INTEGER DEFAULT 0 NOT NULL,
                total_sat INTEGER DEFAULT 0 NOT NULL,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT delivery_totals_pk PRIMARY KEY (id)
);
ALTER SEQUENCE public.delivery_totals_id_seq OWNED BY public.delivery_totals.id;


ALTER TABLE public.delivery_totals ADD CONSTRAINT kms_delivery_totals_fk
FOREIGN KEY (km_id)
REFERENCES public.kms (id)
ON DELETE CASCADE
ON UPDATE CASCADE
NOT DEFERRABLE;

ALTER TABLE kms
	ADD COLUMN max_deliveries INTEGER DEFAULT 0
;


COMMIT;
