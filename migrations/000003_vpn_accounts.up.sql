CREATE TABLE vpnapp.vpn_accounts(
    id                  UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id           UUID            NOT NULL REFERENCES vpnapp.clients(id) ON DELETE RESTRICT,
    version             BIGINT          NOT NULL DEFAULT 1,

    name                VARCHAR(50)     NOT NULL
                                                    CHECK (char_length(name) BETWEEN 3 AND 50),
    balance             BIGINT          NOT NULL    DEFAULT 0,
    daily_price         BIGINT          NOT NULL    CHECK (daily_price >= 0),
    status              VARCHAR(20)     NOT NULL    DEFAULT 'active'
                                                    CHECK (status IN ('active', 'suspended', 'deleted')),
    disabled_reason      VARCHAR(30)                CHECK (disabled_reason IN (
                                                        'insufficient_balance',
                                                        'admin',
                                                        'client_deleted',
                                                        'server_maintenance'
                                                    )),

    last_activity_at    TIMESTAMPTZ,
    rx_bytes            BIGINT          NOT NULL    DEFAULT 0
                                                    CHECK (rx_bytes >= 0),
    tx_bytes            BIGINT          NOT NULL    DEFAULT 0
                                                    CHECK (tx_bytes >= 0),
    
    created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,

    CHECK (
        (status = 'active' AND disabled_reason IS NULL AND deleted_at IS NULL)
        OR
        (status = 'suspended' AND disabled_reason IS NOT NULL AND deleted_at IS NULL)
        OR
        (status = 'deleted' AND disabled_reason IS NULL AND deleted_at IS NOT NULL)
    )
);

CREATE INDEX idx_vpn_accounts_client_id
    ON vpnapp.vpn_accounts(client_id);