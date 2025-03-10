resource "yandex_compute_instance" "vm_a" {
  name        = "${var.vm_prefix}-a"
  zone        = var.default_zone
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default_subnet_a.id
    nat       = false # No public IP address
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}" # Replace 'ubuntu' with the correct username for your image
  }

  depends_on = [yandex_vpc_subnet.default_subnet_a] # Ensures subnet is created first
}


resource "yandex_compute_instance" "vm_b" {
  name        = "${var.vm_prefix}-b"
  zone        = var.second_zone
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default_subnet_b.id
    nat       = false # No public IP address
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}" # Replace 'ubuntu' with the correct username for your image
  }
  depends_on = [yandex_vpc_subnet.default_subnet_b] # Ensures subnet is created first
}
