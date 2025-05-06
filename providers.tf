provider "alicloud" {
  alias      = "main"
  region     = "cn-hangzhou"
  access_key = var.alicloud_access_key
  secret_key = var.alicloud_secret_key
}
