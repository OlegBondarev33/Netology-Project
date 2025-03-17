resource "yandex_alb_target_group" "target_group" {
  name      = "vm-target-group"
  folder_id = var.yc_folder_id

  target {
    subnet_id  = "e9bapbiil0m4emmc5od0"
    ip_address = "10.1.0.12"
    #ip_address = data.yandex_compute_instance.vm1.network_interface[0].ip_address[0]
  }

  target {
    subnet_id  = "e2l2clorkancvk02odd4"
    ip_address = "10.2.0.18"
    #ip_address = data.yandex_compute_instance.vm2.network_interface[0].ip_address[0]
  }
}

resource "yandex_alb_load_balancer" "load_balancer" {
  name      = balanser
  folder_id = var.yc_folder_id

  network_id = yandex_vpc_network.default_network.id

  listener {
    name = "mikky"
    endpoint {
      address {
        external_ipv4_address = {
        }
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.http_router.id
      }
    }
  }

  allocation_policy {
    location {
      zone_id  = var.default_zone
      subnet_id = yandex_vpc_subnet.default_subnet_a.id
    }
        location {
      zone_id  = var.second_zone
      subnet_id = yandex_vpc_subnet.default_subnet_b.id
    }

  }
}
