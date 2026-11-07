CREATE TABLE vpnapp.vpn_servers (
    id                  UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    version             BIGINT          NOT NULL DEFAULT 1,
    name                VARCHAR(50)     NOT NULL
                                        CHECK (char_length(name) BETWEEN 3 AND 50),
    description         VARCHAR(150),
    base_url            VARCHAR(255)    NOT NULL
                                        CHECK (base_url ~ '^https?://'),
    api_key_encrypted   BYTEA           NOT NULL,
    protocol            VARCHAR(50)     NOT NULL,
    created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);