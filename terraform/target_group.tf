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
