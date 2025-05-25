ui = true  # 启用Web界面

seal "shamir" {}
# seal "transit" {
#   auto_rotate_period = "720h"  # 每30天自动轮换
#   address    = "http://120.76.42.201:8200"
#   token      = "hvs.sdv4CxmZVNhlHUmaeOqSFyB3"
#   mount_path = "transit/"
#   key_name   = "unseal-key"
# }

# 启用 Vault 的 Prometheus 监控指标
telemetry {
  prometheus_retention_time = "24h"
  disable_hostname = true
  enable_metric "vault_transit_key_rotations_total" {}
}

# 存储配置
storage "raft" {
  path    = "/var/lib/vault/data"
  node_id = "node1"
}

# 监听器配置
listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = 1  # 禁用TLS
}

# 审计日志配置
audit "file" {
  path = "/var/lib/vault/audit.log"
  mode = "744"
}

api_addr     = "http://120.76.42.201:8200"  # 客户端 API 地址
cluster_addr = "http://120.76.42.201:8201"  # 集群地址

# 日志管理
log_level = "info"
log_file = "/var/log/vault/server.log"

disable_mlock = true
