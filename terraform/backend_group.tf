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
