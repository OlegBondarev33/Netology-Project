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
    "${yandex_compute_disk.disk_vm_a.id}",
    "${yandex_compute_disk.disk_vm_b.id}",
    "${yandex_compute_disk.disk_kibana_vm.id}",
    "${yandex_compute_disk.disk_elasticsearch_vm.id}",
    "${yandex_compute_disk.disk_bastion.id}",
  ]

  depends_on = [
     yandex_compute_instance.vm_a,
     yandex_compute_instance.vm_b,
     yandex_compute_instance.kibana_vm,
     yandex_compute_instance.elasticsearch_vm,
     yandex_compute_instance.disk_bastion,
  ]
}
