// Configure the Yandex.Cloud provider
provider "yandex" {
  cloud_id                 = "b1gs4sjqbi3m84ii35ou"
  folder_id                = "b1gu1oe1m0qlnkj61u6a"
  zone                     = "ru-central1-a"
}

// Create a new instance
resource "yandex_compute_instance" "netology-vm" {
  name = "vm-from-test-image"
  platform_id = "standard-v1"
  
  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd81hgrcv6lsnkremf32"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.netology-subnet.id}"
  }

  metadata = {
    foo      = "bar"
    ssh-keys = "ubuntu:${file("~/.ssh/for_netology_rsa.pub")}"
  }
}

resource "yandex_vpc_network" "netology" {}

resource "yandex_vpc_subnet" "netology-subnet" {
  v4_cidr_blocks = ["10.2.0.0/16"]
  network_id = "${yandex_vpc_network.netology.id}"
}

resource "yandex_vpc_address" "ext_netology" {
  name = "ext_ip"

  external_ipv4_address {
    zone_id = "ru-central1-a"
  }
}

data "yandex_client_config" "client" {}