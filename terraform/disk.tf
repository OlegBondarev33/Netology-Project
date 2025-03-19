resource "yandex_compute_disk" "disk_vm_a" {
  name     = "fhm6neu5hmimvvtgrts2"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  image_id = "fd8arv291825p8bbvmb1"
  size     = 10  
}

resource "yandex_compute_disk" "disk_vm_b" {
  name     = "epde2vn4sg2dntvtbvm1"
  type     = "network-hdd"
  zone     = "ru-central1-b"
  image_id = "fd8arv291825p8bbvmb1"
  size     = 10  
}

resource "yandex_compute_disk" "disk_kibana_vm" {
  name     = "fhmve8p2bmoii6gu33nb"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  image_id = "fd8arv291825p8bbvmb1"
  size     = 10  
}

resource "yandex_compute_disk" "disk_elasticsearch_vm" {
  name     = "fhmsjs2mh177v8rmmo39"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  image_id = "fd8arv291825p8bbvmb1"
  size     = 10  
}

resource "yandex_compute_disk" "disk_vm_a" {
  name     = "fhm6neu5hmimvvtgrts2"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  image_id = "fd8arv291825p8bbvmb1"
  size     = 10  
}
