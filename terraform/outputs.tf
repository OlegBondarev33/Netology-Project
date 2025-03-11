output "vm_a_internal_ip" {
  value       = yandex_compute_instance.vm_a.network_interface[0].ip_address
  description = "IP address internal-vm-a"
}

output "vm_b_internal_ip" {
  value       = yandex_compute_instance.vm_b.network_interface[0].ip_address
  description = "IP address internal-vm-b"
}

output "bastion_public_ip" {
  value       = yandex_compute_instance.bastion.network_interface[0].nat_ip_address
  description = "IP address Bastion"
}

output "bastion_internal_ip" {
  value       = yandex_compute_instance.bastion.network_interface[0].ip_address
  description = "IP address Bastion"
}

output "target_group_id" {
  value = yandex_alb_target_group.target_group.id
}
