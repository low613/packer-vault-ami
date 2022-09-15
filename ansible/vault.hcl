cluster_addr = "http://HOSTNAME:8201"
api_addr = "http://HOSTNAME:8200"
disable_mlock = true
ui = true
listener "tcp" {
    address = "0.0.0.0:8200"
    tls_disable = true
}

storage "raft" {
  path    = "/opt/vault/data"
  node_id = "UNIQUE_ID"

  retry_join {
    auto_join               = "provider=aws region=AWS_REGION tag_key=vault tag_value=server"
    auto_join_scheme        = "http"
  }
}

seal "awskms" {
  region     = "AWS_REGION"
  kms_key_id = "KMS_KEY_ARN"
}
