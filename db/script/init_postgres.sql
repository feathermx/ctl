
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