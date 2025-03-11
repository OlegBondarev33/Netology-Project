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

output "alb_public_ip" {
  value = yandex_alb_load_balancer.load_balancer.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
  description = "Public IP address of the Application Load Balancer"
}
