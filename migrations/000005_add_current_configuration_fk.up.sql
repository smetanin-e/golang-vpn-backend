ALTER TABLE vpnapp.vpn_configurations
ADD CONSTRAINT uq_vpn_configurations_account_id_id
UNIQUE (vpn_account_id, id);

ALTER TABLE vpnapp.vpn_accounts
ADD COLUMN current_configuration_id UUID;

ALTER TABLE vpnapp.vpn_accounts
ADD CONSTRAINT fk_vpn_accounts_current_configuration
FOREIGN KEY (id, current_configuration_id)
REFERENCES vpnapp.vpn_configurations(vpn_account_id, id)
ON DELETE RESTRICT;