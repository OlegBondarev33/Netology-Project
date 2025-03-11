resource "yandex_vpc_network" "default_network" {
  name        = "internal-network"
  description = "VPC network for internal VMs"
}

resource "yandex_vpc_subnet" "default_subnet_a" {
  name           = "${var.subnet_name}-a"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.default_network.id
  v4_cidr_blocks = ["10.1.0.0/24"]
}

resource "yandex_vpc_subnet" "default_subnet_b" {
  name           = "${var.subnet_name}-b"
  zone           = var.second_zone
  network_id     = yandex_vpc_network.default_network.id
  v4_cidr_blocks = ["10.2.0.0/24"]
}

resource "yandex_vpc_subnet" "default_subnet" {
  name           = "zabbix-subnet"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.default_network.id
  v4_cidr_blocks = ["10.1.0.0/24"]
}
