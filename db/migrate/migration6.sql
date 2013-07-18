BEGIN;

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

ALTER TABLE public.shop_totals ADD CONSTRAINT kms_shop_totals_fk
FOREIGN KEY (km_id)
REFERENCES public.kms (id)
ON DELETE CASCADE
ON UPDATE CASCADE
NOT DEFERRABLE;

COMMIT;