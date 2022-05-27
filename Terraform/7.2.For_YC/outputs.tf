output "account_id" {
  value = "${data.yandex_client_config.client.cloud_id}"
  description = "YC cloud ID."
}

output "region" {
  value = "${data.yandex_client_config.client.zone}"
  description = "YC zone."
}

output "ip_address" {
  value = yandex_vpc_address.ext_netology.external_ipv4_address
  description = "YC login."
}

output "subnet_id" {
  value = yandex_vpc_subnet.netology-subnet.network_id
  description = "YC login."
}