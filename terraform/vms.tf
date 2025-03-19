resource "yandex_compute_instance" "vm_a" {
  name        = "internal-vm-a"
  zone        = var.default_zone
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id     = "${yandex_compute_disk.disk_vm_a.id}"
    }

  network_interface {
    subnet_id = yandex_vpc_subnet.default_subnet_a.id
    nat       = false 
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}" 
  }

  depends_on = [yandex_vpc_subnet.default_subnet_a] 
}


resource "yandex_compute_instance" "vm_b" {
  name        = "internal-vm-b"
  zone        = var.second_zone
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id     = "${yandex_compute_disk.disk_vm_b.id}"
    }

  network_interface {
    subnet_id = yandex_vpc_subnet.default_subnet_b.id
    nat       = false 
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}" 
  }
  depends_on = [yandex_vpc_subnet.default_subnet_b] 
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
    disk_id     = "${yandex_compute_disk.disk_kibana_vm.id}"
    }

  network_interface {
    subnet_id = yandex_vpc_subnet.default_subnet_a.id
    nat       = true
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
    disk_id     = "${yandex_compute_disk.disk_elasticsearch_vm.id}"
    }

  network_interface {
    subnet_id = yandex_vpc_subnet.default_subnet_a.id
    nat       = false
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
    disk_id     = "${yandex_compute_disk.disk_bastion.id}"
    }

  network_interface {
    subnet_id = yandex_vpc_subnet.default_subnet_a.id
    nat       = true
  }

  metadata = {
    ssh-keys = "vboxuser:${var.ssh_public_key}"
  }
}
