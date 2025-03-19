resource "yandex_compute_disk" "disk-web-1" {
  name     = "disk-vm-web1"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  image_id = "fd88rqql4soidsdqf98a"
  size     = 8
  
}
