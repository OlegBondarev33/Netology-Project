output "vm_a_internal_ip" {
  value       = yandex_compute_instance.vm_a.network_interface[0].ip_address
  description = "Internal IP address of VM A"
}

output "vm_b_internal_ip" {
  value       = yandex_compute_instance.vm_b.network_interface[0].ip_address
  description = "Internal IP address of VM B"
}

output "bastion_public_ip" {
  value       = yandex_compute_instance.bastion.network_interface[0].nat_ip_address
  description = "Public IP address of the Bastion host"
}
