resource "yandex_compute_disk" "disk_vm_a" {
  name     = "fhm6neu5hmimvvtgrts2"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  image_id = "fd8arv291825p8bbvmb1"
  size     = 10
  
}
