cluster_addr = "https://HOSTNAME:8201"
api_addr = "https://HOSTNAME:8200"
disable_mlock = true
ui = true
listener "tcp" {
    address = "0.0.0.0:8200"
    tls_cert_file      = "/opt/vault/tls/vault-cert.pem"
    tls_key_file       = "/opt/vault/tls/vault-key.pem"
    tls_client_ca_file = "/opt/vault/tls/vault-ca.pem"
}

storage "raft" {
  path    = "/opt/vault/data"
  node_id = "UNIQUE_ID"

  retry_join {
    auto_join               = "provider=aws region=AWS_REGION tag_key=vault tag_value=server"
    auto_join_scheme        = "https"
    leader_tls_servername   = "vault.local"
    leader_ca_cert_file     = "/opt/vault/tls/vault-ca.pem"
    leader_client_cert_file = "/opt/vault/tls/vault-cert.pem"
    leader_client_key_file  = "/opt/vault/tls/vault-key.pem"
  }
}

seal "awskms" {
  region     = "AWS_REGION"
  kms_key_id = "KMS_KEY_ARN"
}
