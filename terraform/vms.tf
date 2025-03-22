resource "yandex_compute_instance" "vm_a" {
  name        = "internal-vm-a"
  zone        = var.default_zone
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default_subnet_a.id
    nat       = false
    security_group_ids = [yandex_vpc_security_group.internal_vms_sg.id]
  }

  metadata = {
    ssh-keys = "vboxuser:${var.ssh_public_key}"
  }

allow_stopping_for_update = true
#depends_on = [yandex_vpc_subnet.default_subnet_a]
}


resource "yandex_compute_instance" "vm_b" {
  name        = "internal-vm-b"
  zone        = var.second_zone
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default_subnet_b.id
    nat       = false
  }

  metadata = {
    ssh-keys = "vboxuser:${var.ssh_public_key}"
  }
allow_stopping_for_update = true
  #depends_on = [yandex_vpc_subnet.default_subnet_b]
}

resource "yandex_compute_instance" "kibana_vm" {
  name        = "kibana-vm"
  zone        = var.default_zone
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default_subnet_a.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.kibana.id]
  }

  metadata = {
    ssh-keys = "vboxuser:${var.ssh_public_key}"
  }
}

resource "yandex_compute_instance" "elasticsearch_vm" {
  name        = "elasticsearch-vm"
  zone        = var.default_zone
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default_subnet_a.id
    nat       = false
    security_group_ids = [yandex_vpc_security_group.elastic.id]
  }

  metadata = {
    ssh-keys = "vboxuser:${var.ssh_public_key}"
  }
}

resource "yandex_compute_instance" "bastion" {
  name        = "bastion-host"
  zone        = var.default_zone
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default_subnet_a.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.bastion_sg.id]
  }

  metadata = {
    ssh-keys = "vboxuser:${var.ssh_public_key}"
  }
}

resource "yandex_compute_instance" "zabbix" {
  name        = "vm1-zabbix"
  zone        = var.default_zone
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default_subnet_a.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.zabbix.id]
  }

  metadata = {
    ssh-keys = "vboxuser:${var.ssh_public_key}"
  }
}
