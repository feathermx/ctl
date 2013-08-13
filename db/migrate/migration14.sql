BEGIN;

ALTER TABLE users DROP CONSTRAINT cities_users_fk;
ALTER TABLE users DROP COLUMN city_id;

CREATE SEQUENCE public.user_kms_id_seq;
CREATE TABLE public.user_kms (
                id BIGINT NOT NULL DEFAULT nextval('public.user_kms_id_seq'),
                user_id BIGINT NOT NULL,
                km_id BIGINT NOT NULL,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT user_kms_pk PRIMARY KEY (id)
);
ALTER SEQUENCE public.user_kms_id_seq OWNED BY public.user_kms.id;

ALTER TABLE public.user_kms ADD CONSTRAINT kms_user_kms_fk
FOREIGN KEY (km_id)
REFERENCES public.kms (id)
ON DELETE CASCADE
ON UPDATE CASCADE
NOT DEFERRABLE;

ALTER TABLE public.user_kms ADD CONSTRAINT users_user_kms_fk
FOREIGN KEY (user_id)
REFERENCES public.users (id)
ON DELETE CASCADE
ON UPDATE CASCADE
NOT DEFERRABLE;


COMMIT;