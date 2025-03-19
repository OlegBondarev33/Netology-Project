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

resource "yandex_alb_backend_group" "backend_group" {
  name = "backend-group"
  folder_id = var.yc_folder_id

  http_backend {
    name = "http-backend"
    port = 80
    weight = 100
    target_group_ids = [yandex_alb_target_group.target_group.id]

    load_balancing_config {
      locality_aware_routing_percent = 0
      mode                           = "ROUND_ROBIN"
      panic_threshold                = 90
      strict_locality                = false
    }
  }
}
