resource "yandex_vpc_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Bastion"
  network_id  = yandex_vpc_network.default_network.id

  ingress {
    protocol       = "tcp"
    port           = 22
    v4_cidr_blocks = [var.my-address]
    description = "SSH my Internet"
  }

  ingress {
    protocol       = "ANY"
    port           = 10050
    v4_cidr_blocks = ["0.0.0.0/0"]
    description = "For Zabbix"
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    #from_port      = 1
    #to_port        = 65535
  }
}

resource "yandex_vpc_security_group" "internal_vms_sg" {
  name        = "internal-vms-sg"
  description = "VM"
  network_id  = yandex_vpc_network.default_network.id

  ingress {
    protocol       = "tcp"
    port           = 22
    v4_cidr_blocks = ["${yandex_compute_instance.bastion.network_interface[0].ip_address}/32"]
    description = "SSH from Bastion"
  }

  ingress {
    protocol       = "tcp"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
    description = "TCP port nginx"
  }

 ingress {
    protocol       = "ANY"
    port           = 10050
    v4_cidr_blocks = ["0.0.0.0/0"]
    description = "For Zabbix"
  }

}

resource "yandex_vpc_security_group" "elastic" {
  name        = "elastic-sg"
  description = "ElasticSearch"
  network_id  = yandex_vpc_network.default_network.id

  ingress {
    protocol       = "tcp"
    port           = 22
    v4_cidr_blocks = [var.my-address]
    description = "SSH for Bastion"
  }

  ingress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    description = "Internet"
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "balanser" {
  name        = "balanser"
  description = "Balanser"
  network_id  = yandex_vpc_network.default_network.id

  ingress {
    protocol       = "ANY"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
    description = "Internet"
  }

  ingress {
      description       = "Status Balanser"
      port              = 30080
      predefined_target = "loadbalancer_healthchecks"
      protocol          = "TCP"
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "kibana" {
  name        = "kibana"
  description = "Kibana"
  network_id  = yandex_vpc_network.default_network.id

  ingress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = [var.my-address]
  }

ingress {
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

ingress {
    protocol       = "TCP"
    port           = 9200
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "zabbix" {
  name        = "zabbix-vm"
  description = "Zabbix"
  network_id  = yandex_vpc_network.default_network.id

  ingress {
    protocol       = "ANY"
    port           = 10050
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = [var.my-address]
  }

ingress {
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
