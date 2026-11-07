CREATE SCHEMA IF NOT EXISTS vpnapp;

CREATE TABLE vpnapp.clients (
    id              UUID            PRIMARY KEY         DEFAULT gen_random_uuid(),
    version         BIGINT          NOT NULL            DEFAULT 1,
    name            VARCHAR(50)     NOT NULL            CHECK(char_length(name) BETWEEN 3 AND 50),
    phone           VARCHAR(15)                         CHECK (
                                                            phone IS NULL OR (
                                                            phone ~ '^\+[0-9]+$'
                                                            AND char_length(phone) BETWEEN 10 AND 15
                                                            )
                                                        ),
    
    status          VARCHAR(20)     NOT NULL            DEFAULT 'active'    CHECK (status IN ('active', 'deleted')),
    created_at      TIMESTAMPTZ     NOT NULL            DEFAULT NOW(),
    updated_at      TIMESTAMPTZ     NOT NULL            DEFAULT NOW(),
    deleted_at      TIMESTAMPTZ,

    CHECK (
    (status = 'active' AND deleted_at IS NULL)
    OR
    (status = 'deleted' AND deleted_at IS NOT NULL)
    )
);