resource "yandex_compute_snapshot_schedule" "snapshots" {
  name = "snapshots"
  description    = "snapshots seven days"
 
    schedule_policy {
    expression = "0 1 * * *"
  }

  retention_period = "168h"

  snapshot_spec {
    description = "retention-snapshot"

  }

  disk_ids = [
    "${yandex_compute_disk.epde2vn4sg2dntvtbvm1.id}",
    "${yandex_compute_disk.fhm6neu5hmimvvtgrts2.id}",
    "${yandex_compute_disk.fhmmk3n8jo772ke48ca4.id}",
    "${yandex_compute_disk.fhmsjs2mh177v8rmmo39.id}",
    "${yandex_compute_disk.fhmve8p2bmoii6gu33nb.id}",
    "${yandex_compute_disk.fhmvro7m85vti0qvfod5.id}",
  ]

  depends_on = [
     yandex_compute_instance.internal-vm-b,
     yandex_compute_instance.internal-vm-a,
     yandex_compute_instance.vm-zabbix,
     yandex_compute_instance.elasticsearch-vm,
     yandex_compute_instance.kibana-vm,
     yandex_compute_instance.bastion-host
  ]

}
