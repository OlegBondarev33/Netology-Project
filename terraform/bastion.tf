resource "yandex_compute_instance" "bastion" {
  name        = "bastion-host"
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
    nat       = true # Public IP address
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }
}
