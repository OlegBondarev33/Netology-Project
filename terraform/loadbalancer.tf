resource "yandex_alb_target_group" "target_group" {
  name      = "my-target-group"
  folder_id = var.yc_folder_id

  target {
    subnet_id = yandex_vpc_subnet.default_subnet_a.id
    address   = yandex_compute_instance.vm_a.network_interface[0].ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.default_subnet_b.id
    address   = yandex_compute_instance.vm_b.network_interface[0].ip_address
  }
}

resource "yandex_alb_http_backend_group" "backend_group" {
  name      = "my-backend-group"
  folder_id = var.yc_folder_id

  http_backend {
    name             = "my-http-backend"
    weight           = 100
    target_group_ids = [yandex_alb_target_group.target_group.id]

    healthcheck {
      timeout             = "3s"
      interval            = "5s"
      healthcheck_port    = 80
      http_healthcheck {
        path = var.healthcheck_path
      }
    }
  }
}

resource "yandex_alb_http_router" "http_router" {
  name      = "my-http-router"
  folder_id = var.yc_folder_id

  default {
    name        = "default-route"
    backend_group_id = yandex_alb_http_backend_group.backend_group.id
  }
}

resource "yandex_alb_load_balancer" "load_balancer" {
  name      = var.alb_name
  folder_id = var.yc_folder_id

  network_id = yandex_vpc_network.default_network.id

  listener {
    name = "http-listener"
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
