CREATE TABLE vpnapp.vpn_configurations(
    id                  UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    version             BIGINT          NOT NULL DEFAULT 1,

    server_id           UUID            NOT NULL REFERENCES vpnapp.vpn_servers(id) ON DELETE RESTRICT,
    vpn_account_id      UUID            NOT NULL REFERENCES vpnapp.vpn_accounts(id) ON DELETE RESTRICT,
    provider_client_id  VARCHAR(255)    NOT NULL,

    config_encrypted    BYTEA           NOT NULL,
    status              VARCHAR(20)     NOT NULL    DEFAULT 'provisioning'
                                                    CHECK (status IN (
                                                        'provisioning',
                                                        'active',
                                                        'disabled',
                                                        'error',
                                                        'retired'
                                                    )),

    created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    retired_at          TIMESTAMPTZ,

    UNIQUE (server_id, provider_client_id),

    CHECK (
        (status = 'retired' AND retired_at IS NOT NULL)
        OR
        (status <> 'retired' AND retired_at IS NULL)
    )
);

CREATE INDEX idx_vpn_configurations_vpn_account_id
    ON vpnapp.vpn_configurations(vpn_account_id);