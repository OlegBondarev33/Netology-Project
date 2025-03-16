resource "yandex_alb_load_balancer" "balanser" {
  name               = "balanser"
  network_id         = yandex_vpc_network.dipnet.id
  security_group_ids = [yandex_vpc_security_group.public-load-balancer.id, yandex_vpc_security_group.internal.id] 

  allocation_policy {
    location {
      zone_id   = "ru-central1-b"
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.private.id
    }
  }

  listener {
    name = "my-listener"
    endpoint {
      address {
        external_ipv4_address {
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
}
